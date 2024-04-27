---
draft: true
---

# 实验四 文件操作与管理

## 实验目的与要求

### 目的

随着社会信息量的极大增长，要求计算机处理的信息与日俱增，涉及到社会生活的各个方面。因此，文件管理是操作系统的一个极为重要的组成部分。

学生应独立地用高级语言编写和调试一个简单的文件系统，模拟文件管理的工作过程。从而对各种文件操作命令的实质内容和执行过程有比较深入的了解，掌握它们的实施方法，加深理解课堂上讲授过的知识。 

### 要求

1. 设计一个 n 个用户的文件系统，每个用户最多可保存 m 个文件。
2. 限制用户在一次运行中只能打开 l 个文件。
3. 系统应能检查打入命令的正确性，出错要能显示出错原因。
4. 对文件必须设置保护措施，如只能执行，允许读、允许写等。在每次打开文件时，根据本次打开的要求，再次设置保护级别，即可有二级保护。
5. 对文件的操作至少应有下述几条命令： 
    - creat    建立文件。
    - delete    删除文件。 
    - open   打开文件。  
    - close    关闭文件。  
    - read      读文件。
    - write     写文件。

## 实验环境

- 操作系统：windows 11
- 编程语言：GoLang 1.17.5
- IDE：JetBrain GoLand 2021.3.1

## 实验内容及其设计与实现

### 设计思路

实验的文件系统应有如下特点

- 文件系统应拥有多用户模式
- 文件的打开数量应有限制
- 文件的读写应被保护码所限制；文件在打开时应用有用户额外设置的二级保护码
- 文件的修改信息最终在退出后应保存于外存；程序异常退出不应保存修改结果

### 数据结构

针对单个文件的管理，本实验设计了 `UserFileDir` 用户文件目录来记录一个文件的基本信息

```go
// UserFileDir 用户文件目录
type UserFileDir struct {
	Name    string `json:"name"`
	ProCode string `json:"proCode"` // 保护码
	Len     int    `json:"len"`
}
```

> 结构体的设计倾向于 json 格式，这方便了文件的保存

针对单个用户的文件管理，本实验设计了 `MainFileDir` 文件主目录来存放一个用户的文件列表

```go
// MainFileDir 主文件目录
type MainFileDir struct {
	Owner        string         `json:"owner"`
	UserFileDirs []*UserFileDir `json:"userFileDirs"`
}
```

可以看到 `MainFileDir` 中记录着指向用户文件的指针数组

针对多个用户的文件管理，本实验设计了 `FileSystem` 文件系统来保存多个用户的信息

```go
type FileSystem struct {
    // 记录当前用户的信息
	UserName         string           // 用户名
	OwnerMainFileDir *MainFileDir     // 用户的mfd
	AccessFileDirs   []*AccessFileDir // 正在运行的文件目录
	// 记录一些全局信息
	MainFileDirs []*MainFileDir // 所有mfd 用于程序退出时更新外存内容
	FilePath     string         // 外存地址
}
```

由于一次程序运行时的所有操作皆在内存中进行，这保证了当程序异常退出时，修改结果将不会保存到外存中去。

程序开始时，需要新建一个 `FileSystem` 实例并等待用户登录，这通过 `NewFileSystem()` 来实现。

```go
// NewFileSystem 新建文件管理系统 读取用户与用户文件
func NewFileSystem(filePath string) (*FileSystem, error) {
	// 读取用户和文件信息
    fh, err := os.Open(filePath)
	jsonData, err := ioutil.ReadAll(fh)
	...
    
	// 解析json数据到MFD中
	err = json.Unmarshal(jsonData, &mainFileDirs)
	...
    
	// 获取来自标准输入的用户名 并判断用户名是否注册
	var userName string
	...

	return ...
}
```

一次进程将只对一个用户的文件进行操作。

### 操作实现

所有操作都提供了类命令行语法，便于执行。

#### 查看文件

```shell
case SHOW:
	if mode == "-o" {
		f.ShowOpeningFiles()
	} else {
		f.ShowFiles()
	}
```

打印文件的基本信息

<img src="C:\Users\Tyeah\AppData\Roaming\Typora\typora-user-images\image-20220216083617790.png" alt="image-20220216083617790" style="zoom:50%;" />

打印处于打开状态的文件信息

<img src="C:\Users\Tyeah\AppData\Roaming\Typora\typora-user-images\image-20220216083740116.png" alt="image-20220216083740116" style="zoom:50%;" />

#### 创建

```go
case CREATE:
	err = f.Create()
	if err != nil {
    	fmt.Println(err)
	}
```

用户拥有的最大文件数量被设置为 10 个，在此被检测。

```go
if len(f.OwnerMainFileDir.UserFileDirs) > 10 {
		return errors.New("the amount of files is up to 10, cannot create new file")
	}
```

<img src="C:\Users\Tyeah\AppData\Roaming\Typora\typora-user-images\image-20220216084354361.png" alt="image-20220216084354361" style="zoom:50%;" />

#### 删除

```go
case DELETE:
	err = f.Delete()
	if err != nil {
    	fmt.Println(err)
	}
```

删除仅仅删除指针，外存的删除在程序正常退出时执行

需要注意的是，如果删除的文件处于打开状态，那么 `FileSystem` 中的 `AccessFileDirs` 中的相关内容也要被删除

```go
// 文件可能被打开 故要遍历一遍afd
	for i, afd := range f.AccessFileDirs {
		if afd.FileDir.Name == name {
			f.AccessFileDirs = append(f.AccessFileDirs[:i], f.AccessFileDirs[i+1:]...)
			break
		}
	}
```

<img src="C:\Users\Tyeah\AppData\Roaming\Typora\typora-user-images\image-20220216084424237.png" alt="image-20220216084424237" style="zoom:50%;" />

#### 打开

```go
case OPEN:
	err = f.Open()
	if err != nil {
    	fmt.Println(err)
	}
```

打开操作将

- 检查已打开文件的数量，超过 5 则不允许打开

- 在 `FileSystem` 中 `AccessFileDirs` 添加被打开文件 ufd 的指针
- 等待用户提供二级保护码
- 返回打开文件的编号 `Number`

<img src="C:\Users\Tyeah\AppData\Roaming\Typora\typora-user-images\image-20220216084940805.png" alt="image-20220216084940805" style="zoom:50%;" />

#### 关闭

```go
case CLOSE:
	err = f.Close()
	if err != nil {
    	fmt.Println(err)
	}
```

成功关闭

<img src="C:\Users\Tyeah\AppData\Roaming\Typora\typora-user-images\image-20220216085037329.png" alt="image-20220216085037329" style="zoom:50%;" />

失败关闭

<img src="C:\Users\Tyeah\AppData\Roaming\Typora\typora-user-images\image-20220216085059333.png" alt="image-20220216085059333" style="zoom:50%;" />

#### 读

```go
case READ:
	err = f.Read()
	if err != nil {
    	fmt.Println(err)
	}
```

文件读取的限制条件

- 文件处于打开状态
- 文件二级保护码的允许读标志为 1

<img src="C:\Users\Tyeah\AppData\Roaming\Typora\typora-user-images\image-20220216085243222.png" alt="image-20220216085243222" style="zoom:50%;" />

#### 写

```go
case WRITE:
	err = f.Write()
	if err != nil {
    	fmt.Println(err)
	}
```

文件写入的限制条件与读取类似

<img src="C:\Users\Tyeah\AppData\Roaming\Typora\typora-user-images\image-20220216085319255.png" alt="image-20220216085319255" style="zoom:50%;" />

## 收获与体会

本次实验设计了一个多用户文件系统。通过学习和实践，我对文件管理的原理有了进一步的理解与体会。文件系统的实现相对简单，但是对异常处理的要求很高，我也花了一定的功夫让各个命令互不影响地独立运行，让所有可能出现的命令排列都能完美执行。Golang 优秀的异常处理机制在很大程度上帮助了我，所有的 `err` 都可以上抛到顶层被检测，这样的设计虽然在某种意义上增加了代码的臃肿程度，但是换取了较高的可读性和较低的维护成本，利大于弊，这样的实践也使我对这门语言有了更深刻的理解。	