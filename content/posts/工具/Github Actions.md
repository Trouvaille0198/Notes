---
title: "Github Actions"
date: 2022-05-12
draft: false
author: "MelonCholi"
tags: []
categories: [工具]
featuredImage: 
---

# Github Actions

## 介绍

Github Action 是 Github 推出的持续集成 (CI) 工具

```yml
# 定义 Workflow 的名字
name: Greeting from Mona

# 定义 Workflow 的触发器
on: push

# 定义 Workflow 的 job
jobs:
  # 定义 job 的 id
  my-job:
    # 定义 job 的 name
    name: My Job
    # 定义 job 的运行环境
    runs-on: ubuntu-latest
    # 定义 job 的运行 step 
    steps:
    # 定义 step 的名称
    - name: Print a greeting
      # 定义 step 的环境变量
      env:
        MY_VAR: Hi there! My name is
        FIRST_NAME: Mona
        MIDDLE_NAME: The
        LAST_NAME: Octocat
      # 运行指令：输出环境变量
      run: |
        echo $MY_VAR $FIRST_NAME $MIDDLE_NAME $LAST_NAME.
```

## Workflow

Workflow 是由一个或多个 job 组成的可配置的自动化过程。我们通过创建 YAML 文件来创建 Workflow 配置。

### 名字

> name

Workflow 的名称，Github 在存储库的 Action 页面上显示 Workflow 的名称。

如果我们省略 name，则 Github 会将其设置为工作流文件名。

```yml
name: Greeting from Mona
on: push
```

### 触发器

> on

触发 Workflow 执行的 event 名称

```yml
# 单个事件
on: push

# 多个事件
on: [push,pull_request]
```

详见：https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#about-workflow-events

#### 活动类型和筛选器

必须为所有事件附加冒号 (`:`)，包括没有配置的事件

```yaml
on:
  label:
    types:
      - created
  push:
    branches:
      - main
  page_build:
```

## job

job 是一次持续集成的运行，可以完成多个任务。一个 Workflow 由一个或多个 jobs 构成

默认情况下，作业没有依赖关系，并且彼此并行运行。 当一个作业依赖于另一个作业时，它将等待从属作业完成，然后才能运行。

### 定义

> jobs.<job_id>

```yml
jobs:
  my_first_job: # job id
    name: My first job
  my_second_job:
    name: My second job
```

上面的 my_first_job 和 my_second_job 就是 job_id

job 通过 id 被定义。

### 命名

> jobs.<job_id>.name

name 会显示在 Github 上

### 依赖

> jobs.<job_id>.needs

needs 可以标识 job 是否依赖于别的 job

如果某一 job 失败，则会跳过所有需要该 job 的 job。

```yml
jobs:
  job1:
  job2:
    needs: job1
  job3:
    needs: [job1, job2]
```

### 输出

> jobs.<jobs_id>.outputs

outputs 用于和 needs 打配合，outputs 输出 → needs 输入

```yml
jobs:
  job1:
    runs-on: ubuntu-latest
    # Map a step output to a job output
    outputs:
      output1: ${{ steps.step1.outputs.test }}
      output2: ${{ steps.step2.outputs.test }}
    steps:
    - id: step1
      run: echo "::set-output name=test::hello"
    - id: step2
      run: echo "::set-output name=test::world"
      
  job2:
    runs-on: ubuntu-latest
    needs: job1
    steps:
    - run: echo ${{needs.job1.outputs.output1}} ${{needs.job1.outputs.output2}}
```

### 运行环境

> jobs.<job_id>.runs-on

runs-on 指定运行 job 的运行环境，Github 上可用的运行器为：

- windows-2019
- ubuntu-20.04
- ubuntu-18.04
- ubuntu-16.04
- macos-10.15

```yml
jobs:
  job1:
    runs-on: macos-10.15
  job2:
    runs-on: windows-2019
```

> 一般都写 ubuntu-latest

### 环境变量

> jobs.<jobs_id>.env

```yml
jobs:
  job1:
    env:
      FIRST_NAME: Mona
```

### job 间共享数据

> artifact

如果 job 生成您要与同一 workflow 中的另一个 job 共享的文件，或者您要保存这些文件供以后参考，可以将它们作为 artifact 存储在 GitHub 中。

artifact 是创建并测试代码时所创建的文件，它可以是二进制或包文件、测试结果、屏幕截图或日志文件。 

artifact 可被另一个 job 使用。 在运行中调用的所有 action 和 workflow 都具有对该 artifact 的写入权限。

例如，你可以创建一个文件，然后将其作为构件上传。

```yaml
jobs:
  example-job:
    name: Save output
    steps:
      - shell: bash
        run: |
          expr 1 + 1 > output.log
      - name: Upload output file
        uses: actions/upload-artifact@v3
        with:
          name: output-log-file
          path: output.log
```

要从另一个 workflow 运行下载构件，您可以使用 `actions/download-artifact`  action 。 例如，您可以下载名为 `output-log-file` 的构件。（猜想：相同仓库下的一个 workflow 应该可以下载到另一个 workflow 上传的 artifact）

```yaml
jobs:
  example-job:
    steps:
      - name: Download a single artifact
        uses: actions/download-artifact@v3
        with:
          name: output-log-file
```

> :star: 要从同一 workflow 运行中下载构件，下载 job 应指定 `needs: upload-job-name`，使其在上传 job 完成之前不会开始。

## step

每个 job 由多个 step 构成，它会从上至下依次执行。

step 可以运行

1. **commands**：命令行命令
2. **setup tasks**：环境配置命令（比如安装个 Node 环境、安装个 Python 环境）
3. **action**：一段 action

每个 step 都在自己的运行器环境中运行，并且可以访问工作空间和文件系统

step 之间不会保留对环境变量的更改

```yml
steps:
    # 定义 step 的名称
- name: Print a greeting
      # 定义 step 的环境变量
  env:
    MY_VAR: Hi there! My name is
    FIRST_NAME: Mona
    MIDDLE_NAME: The
    LAST_NAME: Octocat
  # 运行指令：输出环境变量
  run: |
    echo $MY_VAR $FIRST_NAME $MIDDLE_NAME $LAST_NAME.
```

### 使用 action

> jobs.<job_id>.steps.uses

check-out 仓库中最新的代码到 Workflow 的工作区：

```yml
steps:
  - uses: actions/checkout@v2
```

如果是 node 项目，可以安装 Node.js 与 NPM：

```yml
steps:
- uses: actions/checkout@v2
- uses: actions/setup-node@v2-beta
  with:
    node-version: '12'
```

> with

action 的配置参数

### 运行命令行命令

> jobs.<job_id>.steps.run

上文说到，steps 可以运行：action 和 command-line programs。

run 命令在默认状态下会启动一个没有登录的 shell 来作为命令输入器。

#### 运行多命令

每个 run 命令都会启动一个新的 shell，所以我们执行多行连续命令的时候需要写在同一个 run 下：

- **单行命令**

```yml
- name: Install Dependencies
  run: npm install
```

- **多行命令**

```yml
- name: Clean install dependencies and build
  run： |
    npm ci
    npm run build
```

#### 指定命令运行的位置

> jobs.<job_id>.steps.working-directory

working-directory 可以用来指定 command 的运行位置

```yml
- name: Clean temp directory
  run: rm -rf *
  working-directory: ./temp
```

### 指定 shell 的类型

> jobs.<job_id>.steps.shell

shell 可以用来来指定特定的 shell

```yml
steps:
  - name: Display the path
    run: echo $PATH
    shell: bash
```

![img](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/v2-9283bfe170157cf550cbc86c36fa28c5_b.jpg)

## 表达式

> expressions

详见 https://docs.github.com/cn/actions/learn-github-actions/expressions

你可以使用表达式程序化设置 workflow 文件中的环境变量和访问上下文。

表达式可以是文字值、上下文引用或函数的任意组合。 您可以使用运算符组合文字、上下文引用和函数。

表达式通常在 workflow 文件中与条件性 `if` 关键词一起用来确定 step 是否应该运行。 当 `if` 条件为 `true` 时， step 将会运行。

使用特定语法指示 GitHub 对表达式求值，而不是将其视为字符串。

```
${{ <expression> }}
```

> 在 `if` 条件下使用表达式时，可以省略表达式语法 (`${{ }}`)，因为 GitHub 会自动将 `if` 条件作为表达式求值

### 文字

使用 `boolean`、`null`、`number` 或 `string` 数据类型。

| 数据类型 | 文字值                                                       |
| :------- | :----------------------------------------------------------- |
| `布尔值` | `true` 或 `false`                                            |
| `null`   | `null`                                                       |
| `number` | JSON 支持的任何数字格式。                                    |
| `字符串` | 您不需要将字符串括在 `${{` 和 `}}` 中。 如果这样做，则必须在字符串两边使用单引号 (`'`)。 要使用单引号，请使用额外的单引号来转义 (`''`)。 用双引号 (`"`) 会引发错误。 |

```yaml
env:
  myNull: ${{ null }}
  myBoolean: ${{ false }}
  myIntegerNumber: ${{ 711 }}
  myFloatNumber: ${{ -9.2 }}
  myHexNumber: ${{ 0xff }}
  myExponentialNumber: ${{ -2.99-e2 }}
  myString: Mona the Octocat
  myStringInBraces: ${{ 'It''s open source!' }}
```

### 运算符

| 运算符 | 描述         |
| :----- | :----------- |
| `( )`  | 逻辑分组     |
| `[ ]`  | 索引         |
| `.`    | 属性取消引用 |
| `!`    | 非           |
| `<`    | 小于         |
| `<=`   | 小于或等于   |
| `>`    | 大于         |
| `>=`   | 大于或等于   |
| `==`   | 等于         |
| `!=`   | 不等于       |
| `&&`   | 和           |
| `||`   | 或           |

等式比较条件宽松

- 如果类型不匹配，会强制转换类型为数字：

    | 类型   | 结果                                                         |
    | :----- | :----------------------------------------------------------- |
    | Null   | `0`                                                          |
    | 布尔值 | `true` 返回 `1` `false` 返回 `0`                             |
    | 字符串 | 从任何合法 JSON 数字格式剖析，否则为 `NaN`。 注：空字符串返回 `0`。 |
    | 数组   | `NaN`                                                        |
    | 对象   | `NaN`                                                        |

- 一个 `NaN` 与另一个 `NaN` 的比较不会产生 `true`。

- GitHub 在比较字符串时**忽略大小写**。

- 对象和数组仅在为同一实例时才视为相等。（不懂）

### 函数

GitHub 提供一组内置的函数，可用于表达式。 有些函数抛出值到字符串以进行比较。 GitHub 使用这些转换将数据类型转换为字符串：

| 类型   | 结果                         |
| :----- | :--------------------------- |
| Null   | `''`                         |
| 布尔值 | `'true'` 或 `'false'`        |
| 数字   | 十进制格式，对大数字使用指数 |
| 数组   | 数组不转换为字符串           |
| 对象   | 对象不转换为字符串           |

#### contains

```
contains( search, item )
```

- 如果 `search` 包含 `item`，则返回 `true`。 

- 如果 `search` 为数组，`item` 为数组中的元素时返回 `true`。 
- 如果 `search` 为字符串，`item` 为 `search` 的子字符串时返回 `true`。 

此函数不区分大小写。 抛出值到字符串。

**如：**

`contains(github.event.issue.labels.*.name, 'bug')`

返回与事件相关的议题（是一个数组）是否带有标签 "bug"。

`contains('Hello world', 'llo')`

返回 `true`.

#### startsWith

```
startsWith( searchString, searchValue )
```

当 `searchString` 以 `searchValue` 开头时返回 `true`。 

此函数不区分大小写。 抛出值到字符串。

**如：**

`startsWith('Hello world', 'He')`

返回 `true`.

#### endsWith

```
endsWith( searchString, searchValue )
```

当 `searchString` 以 `searchValue` 结尾时返回 `true`。 

此函数不区分大小写。 抛出值到字符串。

**如：**

`endsWith('Hello world', 'ld')` 返回 `true`.

#### format

```
format( string, replaceValue0, replaceValue1, ..., replaceValueN)
```

将 `string` 中的值替换为变量 `replaceValueN`。 

`string` 中的变量使用 `{N}` 语法指定，其中 `N` 为整数。 

必须指定至少一个 `replaceValue` 和 `string`。 可以使用变量 (`replaceValueN`) 数没有上限。

使用双小括号逸出大括号（？

**如：**

`format('Hello {0} {1} {2}', 'Mona', 'the', 'Octocat')`

返回 'Hello Mona the Octocat'.

`format('{{Hello {0} {1} {2}!}}', 'Mona', 'the', 'Octocat')`

返回 '{Hello Mona the Octocat!}'.

### 状态检查函数

您可以使用以下状态检查函数作为 `if` 条件中的表达式。

除非您包含其中一个函数，否则 `success()` 的默认状态检查将会应用。 

#### success

当前面的 step 没有失败或取消时返回 `true`。

```yaml
steps:
  ...
  - name: The job has succeeded
    if: ${{ success() }}
```

#### always

导致该 step 总是执行，并返回 `true`，即使取消也一样。 

 job 或 step 在重大故障阻止任务运行时不会运行。 例如，如果获取来源失败。

```yaml
if: ${{ always() }}
```

#### cancelled

在 workflow 取消时返回 `true`。

```yaml
if: ${{ cancelled() }}
```

#### failure

在 job 的任何之前一步失败时返回 `true`。 如果您有相依 job 链，`failure()` 在任何上层节点 job 失败时返回 `true`。



```yaml
steps:
  ...
  - name: The job has failed
    if: ${{ failure() }}
```

#### 显式评估状态

您可以直接评估执行 step 的 job 或复合 action 的状态，而不是使用上述方法之一：

#####  workflow  step 示例

```yaml
steps:
  ...
  - name: The job has failed
    if: ${{ job.status == 'failure' }}
```

这与在 job  step 中使用 `if: failure()` 相同。

##### 复合 action  step 的示例

```yaml
steps:
  ...
  - name: The composite action has failed
    if: ${{ github.action_status == 'failure' }}
```

这与在复合 action  step 中使用 `if: failure()` 相同。

## 上下文

> context

详见 https://docs.github.com/en/actions/learn-github-actions/contexts

上下文是一种访问 workflow 运行、运行器环境、 job 及 step 相关信息的方式。 每个上下文都是一个包含属性的对象，属性可以是字符串或其他对象。

使用表达式语法访问上下文：`${{ <context> }}`

| 上下文名称 | 描述                                                    |
| :--------- | :------------------------------------------------------ |
| `github`   | workflow 运行的相关信息                                 |
| `env`      | 包含 workflow、job 或 step 中设置的环境变量             |
| `job`      | 有关当前运行的 job  的信息                              |
| `steps`    | 有关当前 job 中已运行的 step 的信息                     |
| `runner`   | 运行当前 job 的运行程序相关信息                         |
| `secrets`  | 包含可用于 workflow 运行的**机密**的名称和值            |
| `strategy` | 有关当前 job 的 matrix **执行策略**的信息               |
| `matrix`   | 包含在 workflow 中定义的应用于当前 job 的**矩阵**属性。 |
| `needs`    | 包含定义为当前 job **依赖项**的所有 job 的输出          |
| `inputs`   | 包含可重用 workflow 的**输入**                          |

作为表达式的一部分，您可以使用以下两种语法之一访问上下文信息。

- 索引语法：`github['sha']`
- 属性解除参考语法：`github.sha`

### 一些小栗子

将上下文信息打印到日志， 需要 `toJSON` 函数才能将 JSON 对象打印到日志中。

```yml
name: Context testing
on: push

jobs:
  dump_contexts_to_log:
    runs-on: ubuntu-latest
    steps:
      - name: Dump GitHub context
        id: github_context_step
        run: echo '${{ toJSON(github) }}'
      - name: Dump job context
        run: echo '${{ toJSON(job) }}'
      - name: Dump steps context
        run: echo '${{ toJSON(steps) }}'
      - name: Dump runner context
        run: echo '${{ toJSON(runner) }}'
      - name: Dump strategy context
        run: echo '${{ toJSON(strategy) }}'
      - name: Dump matrix context
        run: echo '${{ toJSON(matrix) }}'
```

拿到触发 workflow 的事件名

```yaml
name: Run CI
on: [push, pull_request]

jobs:
  normal_ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run normal CI
        run: ./run-tests

  pull_request_ci:
    runs-on: ubuntu-latest
    if: ${{ github.event_name == 'pull_request' }}
    steps:
      - uses: actions/checkout@v3
      - name: Run PR CI
        run: ./run-additional-pr-ci
```

`env` 上下文

```yaml
name: Hi Mascot
on: push
env:
  mascot: Mona
  super_duper_var: totally_awesome

jobs:
  windows_job:
    runs-on: windows-latest
    steps:
      - run: echo 'Hi ${{ env.mascot }}'  # Hi Mona
      - run: echo 'Hi ${{ env.mascot }}'  # Hi Octocat
        env:
          mascot: Octocat
  linux_job:
    runs-on: ubuntu-latest
    env:
      mascot: Tux
    steps:
      - run: echo 'Hi ${{ env.mascot }}'  # Hi Tux
```

拿到上一个 step 的 output

```yml
name: Generate random failure
on: push
jobs:
  randomly-failing-job:
    runs-on: ubuntu-latest
    steps:
      - id: checkout
        uses: actions/checkout@v3
      - name: Generate 0 or 1
        id: generate_number
        run:  echo "::set-output name=random_number::$(($RANDOM % 2))"
      - name: Pass or fail
        run: |
          if [[ ${{ steps.generate_number.outputs.random_number }} == 0 ]]; then exit 0; else exit 1; fi
```

此示例工作流程有三个 job：

1. 执行生成的 `build` 作业
2. 需要 `build` 作业的 `deploy` 作业
3. 以及需要 `build` 和 `deploy` 作业并且仅工作流程中出现失败时运行的 `debug` 作业。 

`deploy` 作业还使用 `needs` 上下文来访问 `build` 作业的输出。

```yaml
name: Build and deploy
on: push

jobs:
  build:
    runs-on: ubuntu-latest
    outputs:
      build_id: ${{ steps.build_step.outputs.build_id }}
    steps:
      - uses: actions/checkout@v3
      - name: Build
        id: build_step
        run: |
          ./build
          echo "::set-output name=build_id::$BUILD_ID" 
  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: ./deploy --build ${{ needs.build.outputs.build_id }}
  debug:
    needs: [build, deploy]
    runs-on: ubuntu-latest
    if: ${{ failure() }}
    steps:
      - uses: actions/checkout@v3
      - run: ./debug
```

此可重用工作流程示例使用 `inputs` 上下文来获取从调用方工作流传递到可重用工作流的 `build_id` 的值和 `deploy_target` 输入。

```yaml
name: Reusable deploy workflow
on:
  workflow_call:
    inputs:
      build_id:
        required: true
        type: number
      deploy_target:
        required: true
        type: string
      perform_deploy:
        required: true
        type: boolean

jobs:
  deploy:
    runs-on: ubuntu-latest
    if: ${{ inputs.perform_deploy == 'true' }}
    steps:
      - name: Deploy build to target
        run: deploy --build ${{ inputs.build_id }} --target ${{ inputs.deploy_target }}
```

## 环境变量

> Environment variables

您可以使用环境变量来存储要在工作流程中引用的信息。 您可以在工作流程步骤或操作中引用环境变量，这些变量将在运行工作流程的运行器计算机上插值。 在操作或工作流程步骤中运行的命令可以创建、读取和修改环境变量。

您可以设置自己的自定义环境变量，可以使用 GitHub 自动设置的默认环境变量，还可以使用在运行器上的工作环境中设置的任何其他环境变量。 环境变量区分大小写。

要设置自定义环境变量，必须在工作流程文件中定义它。 自定义环境变量的作用域仅限于在其中定义它的元素。 您可以定义作用域如下的环境变量：

- 整个 workflow，通过使用 [`env`](https://docs.github.com/cn/actions/using-workflows/workflow-syntax-for-github-actions#env) 工作流程文件的顶级来定义。
- 工作流程中 job 的内容，通过使用 [`jobs..env`](https://docs.github.com/cn/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idenv) 来定义。
- 作业中的特定 step，通过使用 [`jobs..steps[*\].env`](https://docs.github.com/cn/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idstepsenv) 来定义。

```yaml
name: Greeting on variable day

on:
  workflow_dispatch

env:
  DAY_OF_WEEK: Monday

jobs:
  greeting_job:
    runs-on: ubuntu-latest
    env:
      Greeting: Hello
    steps:
      - name: "Say Hello Mona it's Monday"
        run: echo "$Greeting $First_Name. Today is $DAY_OF_WEEK!"
        env:
          First_Name: Mona
```

注意：

- 设置自定义环境变量时，不能使用任何默认环境变量名称。 

### 使用上下文访问环境变量值

除了环境变量之外，GitHub Actions 还允许您使用上下文设置和读取值。 环境变量和上下文旨在用于工作流程中的不同点。

环境变量始终在虚拟机运行器上插值。 但是，工作流程的某些部分由 GitHub Actions 处理，不会发送到运行器。 不能在工作流程文件的这些部分中使用环境变量。 相反，您可以使用上下文。 

例如，`if` 条件（确定作业或步骤是否发送到运行器）始终由 GitHub Actions 处理。 可以在 `if` 条件语句中使用上下文访问环境变量的值。

```yaml
env:
  DAY_OF_WEEK: Monday

jobs:
  greeting_job:
    runs-on: ubuntu-latest
    env:
      Greeting: Hello
    steps:
      - name: "Say Hello Mona it's Monday"
        if: ${{ env.DAY_OF_WEEK == 'Monday' }}
        run: echo "$Greeting $First_Name. Today is $DAY_OF_WEEK!"
        env:
          First_Name: Mona
```

您通常使用 `env` 或 `github` 上下文来访问工作流程部分中的环境变量值，这些值在作业发送给运行器之前处理。

| 上下文   | 用例                                         | 示例                       |
| :------- | :------------------------------------------- | :------------------------- |
| `env`    | 引用工作流中定义的自定义环境变量。           | `${{ env.MY_VARIABLE }}`   |
| `github` | 引用有关工作流程运行的信息和触发运行的事件。 | `${{ github.repository }}` |

**使用上下文访问环境变量更有泛用性**

### 默认的环境变量

详见：https://docs.github.com/cn/actions/learn-github-actions/environment-variables#default-environment-variables

GitHub 设置的默认环境变量可用于工作流程中的每个步骤。

强烈建议操作使用环境变量访问文件系统，而非使用硬编码的文件路径。 GitHub 设置供操作用于所有运行器环境中的环境变量。

| 环境变量            | 描述                                                         |
| :------------------ | :----------------------------------------------------------- |
| `CI`                | 始终设置为 `true`。                                          |
| `GITHUB_ACTOR`      | 发起工作流程的个人或应用程序的名称。 例如 `octocat`。        |
| `GITHUB_BASE_REF`   | 工作流程运行中拉取请求的基本引用或目标分支的名称。 这仅在触发工作流运行的事件 `pull_request` 或 `pull_request_target` 时才会设置。 例如 `main`。 |
| `GITHUB_ENV`        | 运行器上从工作流程命令到设置环境变量的文件路径。 此文件对于当前步骤是唯一的，并且会针对作业中的每个步骤进行更改。 例如，`/home/runner/work/_temp/_runner_file_commands/set_env_87406d6e-4979-4d42-98e1-3dab1f48b13a`。 更多信息请参阅“[GitHub Actions 的工作流程命令](https://docs.github.com/cn/actions/using-workflows/workflow-commands-for-github-actions#setting-an-environment-variable)”。 |
| `GITHUB_EVENT_NAME` | 触发工作流程的事件的名称。 例如，`workflow_dispatch`。       |
| `GITHUB_JOB`        | 当前作业的 [job_id](https://docs.github.com/cn/actions/reference/workflow-syntax-for-github-actions#jobsjob_id)。 例如，`greeting_job`。 |
| `GITHUB_PATH`       | 运行器上从工作流程命令到设置系统 `PATH` 变量的文件路径。 此文件对于当前步骤是唯一的，并且会针对作业中的每个步骤进行更改。 例如 `/home/runner/work/_temp/_runner_file_commands/add_path_899b9445-ad4a-400c-aa89-249f18632cf5`。 更多信息请参阅“[GitHub Actions 的工作流程命令](https://docs.github.com/cn/actions/using-workflows/workflow-commands-for-github-actions#adding-a-system-path)”。 |
| `GITHUB_REF_NAME`   | 触发工作流程的分支或标记名                                   |
| `GITHUB_REPOSITORY` | 所有者和存储库名称。 例如 `octocat/Hello-World`。            |
| `GITHUB_WORKFLOW`   | 工作流程的名称。 例如 `My test workflow`。 如果工作流程文件未指定`名称`，则此变量的值是存储库中工作流程文件的完整路径。 |

## 矩阵

> matrix

一般定义在 job 中

有时候，我们的代码可能编译环境有多个。比如 electron 的程序，我们需要在 macos 上编译 dmg 压缩包，在 windows 上编译 exe 可执行文件

这种时候，我们使用矩阵就可以啦~

比如下面的代码，我们使用了矩阵指定了：2 个 action 系统，3 个 node 版本。

这时候下面这段代码就会执行 6 次：

```yml
runs-on: ${{ matrix.os }}
strategy:
  matrix:
    os: [ubuntu-16.04, ubuntu-18.04]
    node: [6, 8, 10]
steps:
  - uses: actions/setup-node@v1
    with:
      node-version: ${{ matrix.node }}
```

## 一些通用的属性

> 相对于 workflow, job, step 来讲

### if

#### in job

> jobs.<job_id>.if

**示例：只在特定的仓库下运行**

```yml
name: example-workflow
on: [push]
jobs:
  production-deploy:
    if: github.repository == 'octo-org/octo-repo-prod'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '14'
      - run: npm install -g bats
```



#### in step

> jobs.<job_id>.steps[*].if

**示例：使用上下文**

此步骤仅在事件类型为 `pull_request` 并且事件操作为 `unassigned` 时运行。

```yaml
steps:
 - name: My first step
   if: ${{ github.event_name == 'pull_request' && github.event.action == 'unassigned' }}
   run: echo This event is a pull request that had an assignee removed.
```

**示例：使用状态检查功能**

`my backup step` 仅在作业的上一步失败时运行。

```yaml
steps:
  - name: My first step
    uses: octo-org/action-name@main
  - name: My backup step
    if: ${{ failure() }}
    uses: actions/heroku@1.0.0
```

**示例：使用机密**

无法直接在 `if:` 条件中引用机密。 而应考虑将机密设置为作业级环境变量，然后引用环境变量以有条件地运行作业中的步骤。

如果尚未设置机密，则引用该机密的表达式（例如示例中的 `${{ secrets.SuperSecret }}`）的返回值将为空字符串。

```yaml
name: Run a step if a secret has been set
on: push
jobs:
  my-jobname:
    runs-on: ubuntu-latest
    env:
      super_secret: ${{ secrets.SuperSecret }}
    steps:
      - if: ${{ env.super_secret != '' }}
        run: echo 'This step will only run if the secret has a value set.'
      - if: ${{ env.super_secret == '' }}
        run: echo 'This step will only run if the secret does not have a value set.'
```

## on 详解

详见：https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows

## action

### 添加 action

#### 从相同仓库添加

通过 ‌`{owner}/{repo}@{ref}` 或 `./path/to/dir` 语法引用 action 。

示例 repo 文件结构：

```
|-- hello-world (repository)
|   |__ .github
|       └── workflows
|           └── my-first-workflow.yml
|       └── actions
|           |__ hello-world-action
|               └── action.yml
```

示例 workflow 文件：

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      # This step checks out a copy of your repository.
      - uses: actions/checkout@v3
      # This step references the directory that contains the action.
      - uses: ./.github/actions/hello-world-action
```

#### 从不同仓库添加 action 

一般是从 marketplace 中找到相关用法，直接粘贴

使用 `{owner}/{repo}@{ref}` 语法引用该 action 。

该 action 必须存储在公共（public）仓库。

```yaml
jobs:
  my_first_job:
    steps:
      - name: My first step
        uses: actions/setup-node@v3
```

#### 引用 Docker Hub 上的容器

通过 `docker://{image}:{tag}` 语法引用 action 。

为保护代码和数据，强烈建议先验证 Docker Hub 中 Docker 容器图像的完整性后再将其用于 workflow 。

```yaml
jobs:
  my_first_job:
    steps:
      - name: My first step
        uses: docker://alpine:3.8
```

### 一些有用的 action

#### checkout

check-out 仓库中最新的代码到 Workflow 的工作区：

```yml
steps:
  - uses: actions/checkout@v2
```

#### node 和 npm

如果是 node 项目，可以安装 Node.js 与 NPM：

```yml
steps:
- uses: actions/checkout@v2
- uses: actions/setup-node@v2-beta
  with:
    node-version: '12'
```

#### artifact

**上传**

```yml
jobs:
  example-job:
    name: Save output
    steps:
      - shell: bash
        run: |
          expr 1 + 1 > output.log
      - name: Upload output file
        uses: actions/upload-artifact@v3
        with:
          name: output-log-file
          path: output.log
          retention-days: 5 # 保留时间
```

**下载**

```yml
jobs:
  example-job:
    steps:
      - name: Download a single artifact
        uses: actions/download-artifact@v3
        with:
          name: output-log-file
```

不指定 name 时，默认下载所有 artifact

#### Python

#### Go
