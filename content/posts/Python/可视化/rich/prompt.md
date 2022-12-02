---
title: "Python rich 库 - Pretty Printing"
date: 2022-12-02
author: MelonCholi
draft: false
tags: [Python]
categories: [Python]
---

# Prompt

Rich 有许多 Prompt 类，它们用于要求用户输入信息并循环，直到收到有效的响应（它们都在内部使用 [Console API](https://rich.readthedocs.io/en/stable/console.html#input)）

```py
>>> from rich.prompt import Prompt
>>> name = Prompt.ask("Enter your name")
```

The prompt may be given as a string (which may contain [Console Markup](https://rich.readthedocs.io/en/stable/markup.html#console-markup) and emoji code) or as a [`Text`](https://rich.readthedocs.io/en/stable/reference/text.html#rich.text.Text) instance.

You can set a default value which will be returned if the user presses return without entering any text:

```py
>>> from rich.prompt import Prompt
>>> name = Prompt.ask("Enter your name", default="Paul Atreides")
```

If you supply a list of choices, the prompt will **loop** until the user enters one of the choices:

```py
>>> from rich.prompt import Prompt
>>> name = Prompt.ask("Enter your name", choices=["Paul", "Jessica", "Duncan"], default="Paul")
```

In addition to [`Prompt`](https://rich.readthedocs.io/en/stable/reference/prompt.html#rich.prompt.Prompt) which returns strings, you can also use [`IntPrompt`](https://rich.readthedocs.io/en/stable/reference/prompt.html#rich.prompt.IntPrompt) which asks the user for an integer, and [`FloatPrompt`](https://rich.readthedocs.io/en/stable/reference/prompt.html#rich.prompt.FloatPrompt) for floats.

The [`Confirm`](https://rich.readthedocs.io/en/stable/reference/prompt.html#rich.prompt.Confirm) class is a specialized prompt which may be used to ask the user a **simple yes / no question**. Here’s an example:

```py
>>> from rich.prompt import Confirm
>>> is_rich_great = Confirm.ask("Do you like rich?")
>>> assert is_rich_great
```

The Prompt class was designed to be customizable via inheritance. See [prompt.py](https://github.com/willmcgugan/rich/blob/master/rich/prompt.py) for examples.

To see some of the prompts in action, run the following command from the command line:

```py
python -m rich.prompt
```

