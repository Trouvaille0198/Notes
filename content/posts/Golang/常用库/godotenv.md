---
title: "Go godotenv 库"
date: 2023-06-30
draft: false
author: "MelonCholi"
tags: [Go 库]
categories: [Golang]
---

# godotenv

> https://github.com/joho/godotenv

twelve-factor 应用提倡将配置存储在环境变量中。任何从开发环境切换到生产环境时需要修改的东西都从代码抽取到环境变量里。 但是在实际开发中，如果同一台机器运行多个项目，设置环境变量容易冲突，不实用。

godotenv 库**从 .env 文件中读取配置**， 然后存储到程序的环境变量中。在代码中可以使用读取非常方便。

godotenv 源于一个 Ruby 的开源项目 dotenv。

安装库（library）：

```sh
go get github.com/joho/godotenv
```

安装命令：

```sh
go install github.com/joho/godotenv/cmd/godotenv@latest
# or
go get github.com/joho/godotenv/cmd/godotenv
```

## 快速入门

Add your application configuration to your `.env` file in the root of your project:

```.env
S3_BUCKET=YOURS3BUCKET
SECRET_KEY=YOURSECRETKEYGOESHERE
```

Then in your Go app you can do something like

```go
package main

import (
    "log"
    "os"

    "github.com/joho/godotenv"
)

func main() {
  err := godotenv.Load()
  if err != nil {
    log.Fatal("Error loading .env file")
  }

  s3Bucket := os.Getenv("S3_BUCKET")
  secretKey := os.Getenv("SECRET_KEY")

  // now do something with s3 or whatever
}
```

:star: If you're even lazier than that, you can just take advantage of the autoload package which will read in `.env` on import

```go
import _ "github.com/joho/godotenv/autoload"
```

While `.env` in the project root is the default, you don't have to be constrained, both examples below are 100% legit

```go
godotenv.Load("somerandomfile")
godotenv.Load("filenumberone.env", "filenumbertwo.env")
```

as a final aside, if you don't want godotenv munging your env you can just get a map back instead

```go
var myEnv map[string]string
myEnv, err := godotenv.Read()

s3Bucket := myEnv["S3_BUCKET"]
```

... or from an `io.Reader` instead of a local file

```go
reader := getRemoteFile() // io.Reader
myEnv, err := godotenv.Parse(reader)
```

... or from a `string` if you so desire

```go
content := getRemoteFileContent() // string
myEnv, err := godotenv.Unmarshal(content)
```

## 多环境处理

Existing envs take precedence of envs that are loaded later.

先 load 的 env 优先级高于后 load

The [convention](https://github.com/bkeepers/dotenv#what-other-env-files-can-i-use) (惯例) for managing multiple environments (i.e. development, test, production) is to create an env named `{YOURAPP}_ENV` and load envs in this order:

```go
env := os.Getenv("FOO_ENV") // like test, development, production
if "" == env {
  env = "development"
}

godotenv.Load(".env." + env + ".local")
if env != "test" {
  godotenv.Load(".env.local")
}
godotenv.Load(".env." + env)
godotenv.Load() // The Original .env
```

### 命令行模式

Assuming you've installed the command as above and you've got `$GOPATH/bin` in your `$PATH`

```sh
godotenv -f /some/path/to/.env some_command with some args
```

If you don't specify `-f` it will fall back on the default of loading `.env` in `PWD`

By default, it won't override existing environment variables; you can do that with the `-o` flag.

### Writing Env Files

Godotenv can also write a map representing the environment to a correctly-formatted and escaped file

```go
env, err := godotenv.Unmarshal("KEY=value")
err := godotenv.Write(env, "./.env")
```

... or to a string

```go
env, err := godotenv.Unmarshal("KEY=value")
content, err := godotenv.Marshal(env)
```