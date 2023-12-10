---
title: "Python typer库"
date: 2023-11-01
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# TODO: typer

> https://typer.tiangolo.com/

`click` 是 `Argparse` 的升级版，而 `typer` 则是 `click` 的升级版，其中最大的优势就是可以通过参数的类型识别来快速建立 CLI

## 初识

```py
import typer


def main(
    firstname: str,  # 简单的参数，默认等同于 firstname: str = typer.Argument(...)
    lastname: str = typer.Argument(
        ..., help="Lastname"
    ),  # ... 表示必选， 虽然 Argument 本身就是必选
    email: str = typer.Option(
        ...,
        "-e",
        "--email",  # Option 为可选参数， ... 表示这个可选参数为必选项, 后面可跟缩写和非缩写的参数名
        prompt="Please enter your email",
    ),  # prompt 为提示信息, 如果没有明确指定，则会弹出提示要求输入
    # 类型为int，所以可以指定最小值和最大值, clamp 表示超出了就按照最大值或最小值来处理
    age: int = typer.Option(None, "-a", "--age", min=1, max=100, clamp=True),
):
    """
    Say hello to someone.
    """
    # 上方为CLI的描述, 会自动放入帮助信息
    print(f"Hello {firstname} {lastname}")
    print(f"Your email is {email}")
    if age:
        print(f"Your age is {age}")

    if __name__ == "__main__":
        typer.run(main)  # 运行主函数
```

可以看到，当只需要一个主命令的时候，那么使用 `typer.run(main)` 会非常方便。

参数有两种 `typer.Argument`  和 `typer.Option`

输出结果：

```sh
> python .\1.py --help
Usage: 1.py [OPTIONS] FIRSTNAME LASTNAME

  Say hello to someone.

Arguments:
  FIRSTNAME  [required]

Options:
  -e, --email TEXT         [required]
  --install-completion     Install completion for the current shell.
  --show-completion        Show completion for the current shell, to copy it
                           or customize the installation.
  --help                   Show this message and exit.

> python .\1.py Fried Pei 
Please enter your email: 365433079@qq.com
Hello Fried Pei
Your email is 365433079@qq.com

> python .\1.py Fried Pei --age 28 --email 365433079@qq.com  
Hello Fried Pei
Your email is 365433079@qq.com
Your age is 28
```

## 当有多个子命令时

比如使用 `git` 的时候，既可以直接使用也可以 `git push --all` 这样的命令

```ruby
import typer

app = typer.Typer()  # 初始化app

# callback 为主命令
# invoke_without_command 当没有子命令时也可以执行
@app.callback(invoke_without_command=True)
def main(
    ctx: typer.Context,  # 上下文，放在第一个
    verbose: int = typer.Option(
        0, "--verbose", "-v", help='Verbosity level(1-3)',
        count=True, show_default=False),  # 进行计数， 并且不显示默认值
):
    if verbose:
        print("verbose level: {}".format(verbose))

    if ctx.invoked_subcommand is None:  # 当没有子命令时执行
        print("Run main process")


# command 为子命令
@app.command()
def push(
    ctx: typer.Context,
    all: bool = typer.Option(False, "--all", "-a", help="Push all")
):
    if all:
        print("push all")
        raise typer.Exit()  # 主动退出  还有一种 typer.Abort() 会有提示 Abort!

    print("push")


if __name__ == "__main__":
    app()  # 启动app, 去找 callback 装饰的函数
```

可以看使用 `app()` 最本质的做法是 `typer.Typer()`, 并且对主命令使用 `@callback`  对子命令使用`command`
另外 `typer.Context` 储存着上下文变量， `typer.Context.invoke_without_command` 为查看是否有子命令

输出为：

```sh
> python .\2.py --help    
Usage: 2.py [OPTIONS] COMMAND [ARGS]...

  -v, --verbose         Verbosity level(1-3)
  --install-completion  Install completion for the current shell.
  --show-completion     Show completion for the current shell, to copy it or
                        customize the installation.
  --help                Show this message and exit.

  push

> python .\2.py -vv
verbose level: 2
Run main process

> python .\2.py push --all
push all
```

## callback 参数调用函数

比如需要看 banner，或者 version 的时候，写在主函数里面难免有些臃肿，那么单独取一个回调会好很多

```ruby
import typer

app = typer.Typer()
state = {"verbose": False}


def dis_version(display: bool):
    if display:
        print('Version 0.0.1')
        raise typer.Exit() # 显示完后退出


@app.callback(invoke_without_command=True)
def main(ctx: typer.Context,
         verbose: bool = False,
         version: bool = typer.Option(
             False, "--version", "-v", help="Show version",
             callback=dis_version, is_eager=True),  # 调用 dis_version 函数， 并且优先级最高(is_eager)
         ):
    """
    Manage users in the awesome CLI app.
    """
    if verbose:
        typer.echo("Will write verbose output")
        state["verbose"] = True

    typer.confirm("Are you sure?", default=True, abort=True)  # 给出选项，abort选项表示 No 则直接中断

    if ctx.invoked_subcommand is None:
        print('main process')


if __name__ == "__main__":
    app()
```

## 当需要`--help`的短命令`-h`的时候

```python
import typer
app = typer.Typer()
CONTEXT_SETTINGS = dict(help_option_names=['-h', '--help'])@app.command(context_settings=CONTEXT_SETTINGS)def main(nom: str):    ...
复制代码
```

## get_app_dir 取配置文件夹路径

定义如下

```python
def get_app_dir(app_name, roaming=True, force_posix=False):    r"""Returns the config folder for the application.  The default behavior    is to return whatever is most appropriate for the operating system.
    To give you an idea, for an app called ``"Foo Bar"``, something like    the following folders could be returned:
    Mac OS X:      ``~/Library/Application Support/Foo Bar``    Mac OS X (POSIX):      ``~/.foo-bar``    Unix:      ``~/.config/foo-bar``    Unix (POSIX):      ``~/.foo-bar``    Win XP (roaming):      ``C:\Documents and Settings\<user>\Local Settings\Application Data\Foo Bar``    Win XP (not roaming):      ``C:\Documents and Settings\<user>\Application Data\Foo Bar``    Win 7 (roaming):      ``C:\Users\<user>\AppData\Roaming\Foo Bar``    Win 7 (not roaming):      ``C:\Users\<user>\AppData\Local\Foo Bar``
    .. versionadded:: 2.0
    :param app_name: the application name.  This should be properly capitalized                     and can contain whitespace.    :param roaming: controls if the folder should be roaming or not on Windows.                    Has no affect otherwise.    :param force_posix: if this is set to `True` then on any POSIX system the                        folder will be stored in the home folder with a leading                        dot instead of the XDG config home or darwin's                        application support folder.    """
复制代码
```

使用：

```python
import typer
APP_NAME = 'cmder'
def main():    app_dir = typer.get_app_dir(APP_NAME, force_posix=True)    config_path: Path = Path(app_dir) / "config.json"
复制代码
```

## 参数类型

### int

```ruby
def main(    id: int = typer.Argument(..., min=0, max=1000),    rank: int = typer.Option(0, max=10, clamp=True),    score: float = typer.Option(0, min=0, max=100, clamp=True),):
复制代码
def main(verbose: int = typer.Option(0, "--verbose", "-v", count=True)):
复制代码
```

- min 最小值
- max 最大值
- clamp 超出值后按最小/大处理
- count 计数

### bool

```ruby
def main(accept: Optional[bool] = typer.Option(None, "--accept/--reject", "-a/-A")):
复制代码
```

默认情况下给出的参考值是`--accept/--no-accept` 修改成`--accept/--reject` 和 短命令 `-a/-A`

### enum

只区枚举中的值

```ruby
from enum import Enum
import typer

class NeuralNetwork(str, Enum):    simple = "simple"    conv = "conv"    lstm = "lstm"

def main(network: NeuralNetwork = typer.Option(NeuralNetwork.simple, case_sensitive=False)):    typer.echo(f"Training neural network of type: {network.value}")

if __name__ == "__main__":    typer.run(main)
复制代码
```

- case_sensitive 大小写敏感

### path

可以直接对路径进行验证

```ruby
import typerfrom pathlib import Path

def main(    config: Path = typer.Option(        ...,        exists=True,        file_okay=True,        dir_okay=False,        writable=False,        readable=True,        resolve_path=True,    )):    text = config.read_text(encoding='utf-8')    typer.echo(f"Config file contents: {text}")

if __name__ == "__main__":    typer.run(main)
复制代码
```

- exists 是否存在
- file_okay 可以是文件
- dir_okay 可以是文件夹
- writable 是否可写
- readable 是否可读
- resolve_path 当为 True，则会转化成绝对路径

### file

可以直接返回一个`fi`

```python
def main(config: typer.FileText = typer.Option(..., mode="a")):    config.write('This is a single line\n')
复制代码
```

- mode 定义操作类型

## 测试

可以使用`pytest`来对`typer`进行测试

### 测试输出

```python
from typer.testing import CliRunner
from .main import app
runner = CliRunner()

def test_app():    result = runner.invoke(app, ["Camila", "--city", "Berlin"])    assert result.exit_code == 0    assert "Hello Camila" in result.stdout    assert "Let's have a coffee in Berlin" in result.stdout
复制代码
```

### 测试输入

```python
from typer.testing import CliRunner
from .main import app
runner = CliRunner()

def test_app():    result = runner.invoke(app, ["Camila"], input="camila@example.com\n")    assert result.exit_code == 0    assert "Hello Camila, your email is: camila@example.com" in result.stdout
复制代码
```

## 关于打包

- [这里](https://typer.tiangolo.com/tutorial/package/)是 typer 里面提供的打包方法
- [poetry 包管理使用方法](https://elinpf.github.io/2022/02/24/poetry-包管理使用方法/)
