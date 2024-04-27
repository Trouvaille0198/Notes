---
title: "Go Viper 库"
date: 2022-05-08
draft: false
author: "MelonCholi"
tags: [Go 库]
categories: [Golang]
---

# Viper

> https://github.com/spf13/viper

Viper 是适用于 Go 应用程序的完整**配置解决方案**。它被设计用于在应用程序中工作，并且可以处理所有类型的配置需求和格式。

它支持以下特性：

- 设置默认值
- 从 `JSON`、`TOML`、`YAML`、`HCL`、`envfile` 和 `Java properties` 格式的配置文件读取配置信息
- 实时监控和重新读取配置文件（可选）
- 从环境变量中读取
- 从远程配置系统（etcd 或 Consul）读取并监控配置变化
- 从命令行参数读取配置
- 从 buffer 读取配置
- 显式配置值

```shell
go get github.com/spf13/viper
```

Viper 能够为你执行下列操作：

1. **查找、加载和反序列化**上述各种格式的配置文件。
2. 提供一种机制为你的不同配置选项**设置默认值**。
3. 提供一种机制来通过**命令行参数**覆盖指定选项的值。
4. 提供**别名系统**，以便在不破坏现有代码的情况下轻松重命名参数。
5. 当用户提供了与默认值相同的命令行或配置文件时，可以很容易地分辨出它们之间的区别。

Viper 会按照下面的优先级。每个项目的优先级都高于它下面的项目:

- 显示调用 `Set` 设置值
- 命令行参数（flag）
- 环境变量
- 配置文件
- key/value 存储
- 默认值

> 目前 Viper 配置的键（Key）是大小写不敏感的。目前正在讨论是否将这一选项设为可选。

## 把值存入 Viper

### 建立默认值

一个好的配置系统应该支持默认值。一般的键不需要默认值，但如果没有通过配置文件、环境变量、远程配置或命令行标志（flag）设置键，则默认值非常有用。

例如：

```go
viper.SetDefault("ContentDir", "content")
viper.SetDefault("LayoutDir", "layouts")
viper.SetDefault("Taxonomies", map[string]string{"tag": "tags", "category": "categories"})
```

### 读取配置文件

Viper 支持 `JSON`、`TOML`、`YAML`、`HCL`、`envfile` 和 `Java properties` 格式的配置文件。Viper 可以搜索多个路径，但 Viper 实例与配置文件是一对一的。Viper 不默认任何配置搜索路径，将默认决策留给程序。

下面是一个如何使用 Viper 搜索和读取配置文件的示例。不需要任何特定的路径，但是至少应该提供一个配置文件预期出现的路径。

```go
viper.SetConfigFile("./config.yaml") // 指定配置文件路径
viper.SetConfigName("config") // 配置文件名称(无扩展名)
viper.SetConfigType("yaml") // 如果配置文件的名称中没有扩展名，则需要配置此项
viper.AddConfigPath("/etc/appname/")   // 查找配置文件所在的路径
viper.AddConfigPath("$HOME/.appname")  // 多次调用以添加多个搜索路径
viper.AddConfigPath(".")               // 还可以在工作目录中查找配置

err := viper.ReadInConfig() // 查找并读取配置文件
if err != nil { // 处理读取配置文件的错误
	panic(fmt.Errorf("Fatal error config file: %s \n", err))
}
```

在加载配置文件出错时，你可以像下面这样处理找不到配置文件的特定情况：

```go
if err := viper.ReadInConfig(); err != nil {
    if _, ok := err.(viper.ConfigFileNotFoundError); ok {
        // 配置文件未找到错误；如果需要可以忽略
    } else {
        // 配置文件被找到，但产生了另外的错误
    }
}

// 配置文件找到并成功解析
```

> 你也可以有不带扩展名的文件，并以编程方式指定其格式。这针对于位于用户 `$HOME` 目录中的配置文件没有任何扩展名，如 `.bashrc`。

更多方法，详见 “访问配置”

### 写入配置文件

从配置文件中读取配置文件是有用的，但是有时你想要存储在运行时所做的所有修改。为此，可以使用下面一组命令，每个命令都有自己的用途:

- WriteConfig - 将当前的 `viper` 配置写入预定义的路径并覆盖（如果存在的话）。如果没有预定义的路径，则报错。
- SafeWriteConfig - 将当前的 `viper` 配置写入预定义的路径。如果没有预定义的路径，则报错。如果存在，将不会覆盖当前的配置文件。
- WriteConfigAs - 将当前的 `viper` 配置写入给定的文件路径。将覆盖给定的文件(如果它存在的话)。
- SafeWriteConfigAs - 将当前的 `viper` 配置写入给定的文件路径。不会覆盖给定的文件(如果它存在的话)。

根据经验，标记为 `safe` 的所有方法都不会覆盖任何文件，而是直接创建（如果不存在），而默认行为是创建或截断。

一个小示例：

```go
viper.WriteConfig() // 将当前配置写入“viper.AddConfigPath()”和“viper.SetConfigName”设置的预定义路径
viper.SafeWriteConfig()
viper.WriteConfigAs("/path/to/my/.config")
viper.SafeWriteConfigAs("/path/to/my/.config") // 因为该配置文件写入过，所以会报错
viper.SafeWriteConfigAs("/path/to/my/.other_config")
```

### 监控并重新读取配置文件

Viper 支持在运行时实时读取配置文件的功能。

需要重新启动服务器以使配置生效的日子已经一去不复返了，viper 驱动的应用程序可以在运行时读取配置文件的更新，而不会错过任何消息。

只需告诉 viper 实例 watchConfig。可选地，你可以为 Viper 提供一个回调函数，以便在每次发生更改时运行。

**确保在调用`WatchConfig()`之前添加了所有的配置路径。**

```go
viper.WatchConfig()
viper.OnConfigChange(func(e fsnotify.Event) {
  // 配置文件发生变更之后会调用的回调函数
	fmt.Println("Config file changed:", e.Name)
})
```

### 从 io.Reader 读取配置

Viper 预先定义了许多配置源，如文件、环境变量、标志和远程 K/V 存储，但你不受其约束。你还可以实现自己所需的配置源并将其提供给 viper。

```go
viper.SetConfigType("yaml") // 或者 viper.SetConfigType("YAML")

// 任何需要将此配置添加到程序中的方法。
var yamlExample = []byte(`
Hacker: true
name: steve
hobbies:
- skateboarding
- snowboarding
- go
clothing:
  jacket: leather
  trousers: denim
age: 35
eyes : brown
beard: true
`)

viper.ReadConfig(bytes.NewBuffer(yamlExample))

viper.Get("name") // 这里会得到 "steve"
```

### 覆盖设置

这些可能来自命令行标志，也可能来自你自己的应用程序逻辑。

```go
viper.Set("Verbose", true)
viper.Set("LogFile", LogFile)
```

### 注册和使用别名

别名允许多个键引用单个值

```go
viper.RegisterAlias("loud", "Verbose")  // 注册别名（此处loud和Verbose建立了别名）

viper.Set("verbose", true) // 结果与下一行相同
viper.Set("loud", true)   // 结果与前一行相同

viper.GetBool("loud") // true
viper.GetBool("verbose") // true
```

### 使用环境变量

Viper 完全支持环境变量。这使`Twelve-Factor App`开箱即用。有五种方法可以帮助与 ENV 协作:

- `AutomaticEnv()`
- `BindEnv(string...) : error`
- `SetEnvPrefix(string)`
- `SetEnvKeyReplacer(string...) *strings.Replacer`
- `AllowEmptyEnv(bool)`

*使用ENV变量时，务必要意识到Viper将ENV变量视为区分大小写。*

Viper 提供了一种机制来确保 ENV 变量是惟一的。通过使用`SetEnvPrefix`，你可以告诉 Viper 在读取环境变量时使用前缀。`BindEnv`和`AutomaticEnv`都将使用这个前缀。

`BindEnv`使用一个或两个参数。第一个参数是键名称，第二个是环境变量的名称。环境变量的名称区分大小写。如果没有提供 ENV 变量名，那么 Viper 将自动假设 ENV 变量与以下格式匹配：前缀+ “_” +键名全部大写。当你显式提供 ENV 变量名（第二个参数）时，它 **不会** 自动添加前缀。例如，如果第二个参数是“id”，Viper 将查找环境变量“ID”。

在使用 ENV 变量时，需要注意的一件重要事情是，每次访问该值时都将读取它。Viper 在调用`BindEnv`时不固定该值。

`AutomaticEnv`是一个强大的助手，尤其是与`SetEnvPrefix`结合使用时。调用时，Viper 会在发出`viper.Get`请求时随时检查环境变量。它将应用以下规则。它将检查环境变量的名称是否与键匹配（如果设置了`EnvPrefix`）。

`SetEnvKeyReplacer`允许你使用`strings.Replacer`对象在一定程度上重写 Env 键。如果你希望在`Get()`调用中使用`-`或者其他什么符号，但是环境变量里使用`_`分隔符，那么这个功能是非常有用的。可以在`viper_test.go`中找到它的使用示例。

或者，你可以使用带有`NewWithOptions`工厂函数的`EnvKeyReplacer`。与`SetEnvKeyReplacer`不同，它接受`StringReplacer`接口，允许你编写自定义字符串替换逻辑。

默认情况下，空环境变量被认为是未设置的，并将返回到下一个配置源。若要将空环境变量视为已设置，请使用`AllowEmptyEnv`方法。

#### Env 示例：

```go
SetEnvPrefix("spf") // 将自动转为大写
BindEnv("id")

os.Setenv("SPF_ID", "13") // 通常是在应用程序之外完成的

id := Get("id") // 13
```

### 使用Flags

Viper 具有绑定到标志的能力。具体来说，Viper 支持 [Cobra](https://github.com/spf13/cobra) 库中使用的 `Pflag`。

与 `BindEnv` 类似，该值不是在调用绑定方法时设置的，而是在访问该方法时设置的。这意味着你可以根据需要尽早进行绑定，即使在 `init()` 函数中也是如此。

对于单个标志，`BindPFlag()` 方法提供此功能。

例如：

```go
serverCmd.Flags().Int("port", 1138, "Port to run Application server on")
viper.BindPFlag("port", serverCmd.Flags().Lookup("port"))
```

你还可以绑定一组现有的 pflags （pflag.FlagSet）：

举个例子：

```go
pflag.Int("flagname", 1234, "help message for flagname")

pflag.Parse()
viper.BindPFlags(pflag.CommandLine)

i := viper.GetInt("flagname") // 从viper而不是从pflag检索值
```

在 Viper 中使用 pflag 并不阻碍其他包中使用标准库中的 flag 包。pflag 包可以通过导入这些 flags 来处理 flag 包定义的 flags。这是通过调用 pflag 包提供的便利函数`AddGoFlagSet()`来实现的。

例如：

```go
package main

import (
	"flag"
	"github.com/spf13/pflag"
)

func main() {

	// 使用标准库 "flag" 包
	flag.Int("flagname", 1234, "help message for flagname")

	pflag.CommandLine.AddGoFlagSet(flag.CommandLine)
	pflag.Parse()
	viper.BindPFlags(pflag.CommandLine)

	i := viper.GetInt("flagname") // 从 viper 检索值

	...
}
```

#### flag 接口

如果你不使用 `Pflag`，Viper 提供了两个 Go 接口来绑定其他 flag 系统。

`FlagValue` 表示单个 flag。这是一个关于如何实现这个接口的非常简单的例子：

```go
type myFlag struct {}
func (f myFlag) HasChanged() bool { return false }
func (f myFlag) Name() string { return "my-flag-name" }
func (f myFlag) ValueString() string { return "my-flag-value" }
func (f myFlag) ValueType() string { return "string" }
```

一旦你的 flag 实现了这个接口，你可以很方便地告诉 Viper 绑定它：

```go
viper.BindFlagValue("my-flag-name", myFlag{})
```

`FlagValueSet`代表一组 flags 。这是一个关于如何实现这个接口的非常简单的例子:

```go
type myFlagSet struct {
	flags []myFlag
}

func (f myFlagSet) VisitAll(fn func(FlagValue)) {
	for _, flag := range flags {
		fn(flag)
	}
}
```

一旦你的 flag set 实现了这个接口，你就可以很方便地告诉 Viper 绑定它：

```go
fSet := myFlagSet{
	flags: []myFlag{myFlag{}, myFlag{}},
}
viper.BindFlagValues("my-flags", fSet)
```

### 远程 Key/Value 存储支持

在 Viper 中启用远程支持，需要在代码中匿名导入`viper/remote` 这个包。

```
import _ "github.com/spf13/viper/remote"
```

Viper 将读取从 Key/Value 存储（例如 etcd 或 Consul）中的路径检索到的配置字符串（如 `JSON`、`TOML`、`YAML`、`HCL`、`envfile` 和 `Java properties` 格式）。这些值的优先级高于默认值，但是会被从磁盘、flag 或环境变量检索到的配置值覆盖。（译注：也就是说 Viper 加载配置值的优先级为：磁盘上的配置文件>命令行标志位>环境变量>远程 Key/Value 存储 > 默认值。）

Viper 使用 [crypt](https://github.com/bketelsen/crypt) 从 K/V 存储中检索配置，这意味着如果你有正确的 gpg 密匙，你可以将配置值加密存储并自动解密。加密是可选的。

你可以将远程配置与本地配置结合使用，也可以独立使用。

`crypt`有一个命令行助手，你可以使用它将配置放入 K/V 存储中。`crypt` 默认使用在 [http://127.0.0.1:4001](http://127.0.0.1:4001/) 的 etcd。

```bash
$ go get github.com/bketelsen/crypt/bin/crypt
$ crypt set -plaintext /config/hugo.json /Users/hugo/settings/config.json
```

确认值已经设置：

```bash
$ crypt get -plaintext /config/hugo.json
```

有关如何设置加密值或如何使用 Consul 的示例，请参见`crypt`文档。

### 远程 Key/Value 存储示例-未加密

#### etcd

```go
viper.AddRemoteProvider("etcd", "http://127.0.0.1:4001","/config/hugo.json")
viper.SetConfigType("json") // 因为在字节流中没有文件扩展名，所以这里需要设置下类型。支持的扩展名有 "json", "toml", "yaml", "yml", "properties", "props", "prop", "env", "dotenv"
err := viper.ReadRemoteConfig()
```

#### Consul

你需要 Consul Key/Value 存储中设置一个 Key 保存包含所需配置的 JSON 值。例如，创建一个 key`MY_CONSUL_KEY`将下面的值存入 Consul key/value 存储：

```json
{
    "port": 8080,
    "hostname": "liwenzhou.com"
}
viper.AddRemoteProvider("consul", "localhost:8500", "MY_CONSUL_KEY")
viper.SetConfigType("json") // 需要显示设置成json
err := viper.ReadRemoteConfig()

fmt.Println(viper.Get("port")) // 8080
fmt.Println(viper.Get("hostname")) // liwenzhou.com
```

#### Firestore

```go
viper.AddRemoteProvider("firestore", "google-cloud-project-id", "collection/document")
viper.SetConfigType("json") // 配置的格式: "json", "toml", "yaml", "yml"
err := viper.ReadRemoteConfig()
```

当然，你也可以使用`SecureRemoteProvider`。

### 远程 Key/Value 存储示例-加密

```go
viper.AddSecureRemoteProvider("etcd","http://127.0.0.1:4001","/config/hugo.json","/etc/secrets/mykeyring.gpg")
viper.SetConfigType("json") // 因为在字节流中没有文件扩展名，所以这里需要设置下类型。支持的扩展名有 "json", "toml", "yaml", "yml", "properties", "props", "prop", "env", "dotenv"
err := viper.ReadRemoteConfig()
```

### 监控 etcd 中的更改-未加密

```go
// 或者你可以创建一个新的viper实例
var runtime_viper = viper.New()

runtime_viper.AddRemoteProvider("etcd", "http://127.0.0.1:4001", "/config/hugo.yml")
runtime_viper.SetConfigType("yaml") // 因为在字节流中没有文件扩展名，所以这里需要设置下类型。支持的扩展名有 "json", "toml", "yaml", "yml", "properties", "props", "prop", "env", "dotenv"

// 第一次从远程读取配置
err := runtime_viper.ReadRemoteConfig()

// 反序列化
runtime_viper.Unmarshal(&runtime_conf)

// 开启一个单独的goroutine一直监控远端的变更
go func(){
	for {
	    time.Sleep(time.Second * 5) // 每次请求后延迟一下

	    // 目前只测试了etcd支持
	    err := runtime_viper.WatchRemoteConfig()
	    if err != nil {
	        log.Errorf("unable to read remote config: %v", err)
	        continue
	    }

	    // 将新配置反序列化到我们运行时的配置结构体中。你还可以借助channel实现一个通知系统更改的信号
	    runtime_viper.Unmarshal(&runtime_conf)
	}
}()
```

## 访问配置

viper 可以帮我们读取各个地方的配置，那读到配置之后，要怎么用呢？

### 直接访问

```css
{
  "mysql":{
    "db":"test"
  },
  "host":{
      "address":"localhost"
      "ports":[
          "8080",
          "8081"
      ]
  }
}
```

对于多层级配置 key，可以用逗号隔号,如：

```go
viper.Get("mysql.db")

viper.GetString("user.db")

viper.Get("host.address") // 输出：localhost
```

数组，可以用序列号访问，如：

```go
viper.Get("host.posts.1") // 输出: 8081
```

也可以使用`sub`函数解析某个 key 的下级配置,如：

```go
hostViper := viper.Sub("host")
fmt.Println(hostViper.Get("address"))
fmt.Println(hostViper.Get("posts.1"))
```

viper 提供了以下访问配置的的函数：

- Get(key string) : interface{}
- GetBool(key string) : bool
- GetFloat64(key string) : float64
- GetInt(key string) : int
- GetIntSlice(key string) : []int
- GetString(key string) : string
- GetStringMap(key string) : map[string]interface{}
- GetStringMapString(key string) : map[string]string
- GetStringSlice(key string) : []string
- GetTime(key string) : time.Time
- GetDuration(key string) : time.Duration

### 序列化

读取了配置之后，除了使用上面列举出来的函数访问配置，还可以将配置序列化到 struct 或 map 之中，这样可以更加方便访问配置。

示例代码

配置文件：config.yaml

```yaml
host: localhost
username: test
password: test
port: 3306
charset: utf8
dbName: test
```

解析代码：

```go
type MySQL struct {
    Host     string
    DbName   string
    Port     string
    Username string
    Password string
    Charset  string
}

func main() {

    viper.SetConfigName("config")
    viper.SetConfigType("yaml")
    viper.AddConfigPath(".")
    viper.ReadInConfig()
    var mysql MySQL

    viper.Unmarshal(&mysql)//序列化

    fmt.Println(mysql.Username)
    fmt.Println(mysql.Host)
}
```

对于多层级的配置，viper 也支持序列化到一个复杂的 struct 中，如：

我们将 config.yaml 改为如下结构：

```yaml
mysql: 
  host: localhost
  username: test
  password: test
  port: 3306
  charset: utf8
  dbName: test
redis: 
  host: localhost
  port: 6379
```

示例程序

```go
type MySQL struct {
    Host     string
    DbName   string
    Username string
    Password string
    Charset  string
}

type Redis struct {
    Host string
    Port string
}

type Config struct {
    MySQL MySQL
    Redis Redis
}

func main() {

    viper.SetConfigName("config")
    viper.SetConfigType("yaml")
    viper.AddConfigPath(".")
    viper.ReadInConfig()
    var config Config

    viper.Unmarshal(&config)

    fmt.Println(config.MySQL.Username)
    fmt.Println(config.Redis.Host)
}
```

## 其他技巧

### 判断配置key是否存在

```go
if viper.IsSet("user"){
    fmt.Println("key user is not exists")
}
```

### 打印所有配置

```go
m := viper.AllSettings()
fmt.Println(m)
```