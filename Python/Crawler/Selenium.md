# 一、 基本操作

Selenium是一个自动化测试工具，利用它可以驱动浏览器执行特定的动作，如点击、下拉等操作，同时还可以获取浏览器当前呈现的页面的源代码，做到可见即可爬。对于一些JavaScript动态渲染的页面来说，此种抓取方式非常有效。

## 1.1 导入

```python
from selenium import webdriver # 浏览器对象
from selenium.webdriver.common.by import By # find_element()
from selenium.webdriver.common.keys import Keys # 导入 Keys 对象
from selenium.webdriver.support import expected_conditions as EC # 显示等待条件
from selenium.webdriver.support.wait import WebDriverWait # 显示等待
```

## 1.2 声明浏览器对象

```python
browser = webdriver.Chrome()
browser = webdriver.Firefox()
browser = webdriver.Edge()
browser = webdriver.PhantomJS()
browser = webdriver.Safari()
```

## 1.3 其他操作

```python
browser.get('https://www.taobao.com') 	# 访问 url
print(browser.current_url) 				# 返回当前 url
print(browser.get_cookies()) 			# 返回 cookies
print(browser.page_source)  			# 返回当前页面源码
browser.close() 						# 关闭当前标签页
browser.quit()                          # 关闭浏览器
```

## 1.4 Cookies 操作

### 1.4.1 获取 Cookies

***.get_cookies()***

- 返回现有 Cookies

### 1.4.2 删除 Cookies

***.delete_all_cookies()***

- 删除现有 Cookies

### 1.4.3 添加 Cookies

***.add_cookie(dic_cookies)***

- *dic_cookies*：字典形式的 Cookies

# 二、页面操作

页面操作以浏览器为对象

## 2.1 前进后退

***.forward() .back()***

```python
import time
from selenium import webdriver

browser = webdriver.Chrome()
browser.get('https://www.baidu.com/')
browser.get('https://www.taobao.com/')
browser.get('https://www.python.org/')
browser.back()
time.sleep(1)
browser.forward()
browser.close()
```

连续访问3个页面，然后调用 `back()` 方法回到第二个页面，接下来再调用 `forward()` 方法又可以前进到第三个页面。

## 2.2 标签页操作

### 2.2.1 打开新标签页

***.execute_script('window.open()')***

### 2.2.2 查看标签页 

***.window_handles***

- 返回标签页列表

### 2.2.3 切换标签页

***.switch_to_window(window_value)***

- *window_value*：标签页名

## 2.3 切换 Frame

***.switch_to_frame(window_value)***

网页中有一种节点叫作iframe，也就是子Frame，相当于页面的子页面，它的结构和外部网页的结构完全一致。Selenium打开页面后，它默认是在父级Frame里面操作，而此时如果页面中还有子Frame，它是不能获取到子Frame里面的节点的

```python
browser.switch_to.frame('iframeResult')

browser.switch_to.parent_frame()
```

## 2.4 延时等待

在 Selenium 中，`get()` 方法会在网页框架加载结束后结束执行，此时如果获取 `page_source`，可能并不是浏览器完全加载完成的页面，如果某些页面有额外的 Ajax 请求，我们在网页源代码中也不一定能成功获取到。所以，这里需要延时等待一定时间，确保节点已经加载出来

### 2.4.1 隐式等待

***.implicitly_wait(seconds)***

如果 Selenium 没有在 DOM 中找到节点，将继续等待，超出设定时间后，则抛出找不到节点的异常

隐式等待的效果其实并没有那么好，因为我们只规定了一个固定时间，而页面的加载时间会受到网络条件的影响

### 2.4.2 显式等待

先指定要查找的节点，然后指定一个**最长等待时间**。如果在规定时间内加载出来了这个节点，就返回查找的节点；如果到了规定时间依然没有加载出该节点，则抛出超时异常

#### 1） 生成器

***WebDriverWait(driver,timeout,poll_frequency=0.5,ignored_exceptions=None)***

- *driver*：浏览器驱动
- *timeout*：最长超时时间，默认以秒为单位
- *poll_frequency*：检测的间隔步长，默认为 0.5s
- *ignored_exceptions*：超时后的抛出的异常信息，默认抛出 NoSuchElementExeception 异常。

```python
wait = WebDriverWait(browser, 10) # 传入浏览器生成器和最长等待时间
```

#### 2） 直到函数

***until(method)* 和 *until_not(method)***

- 以显示等待为对象

- *method*：expected_conditions

```python
wait = WebDriverWait(browser, 10)
input = wait.until(EC.presence_of_element_located((By.ID, 'q')))
button = wait.until(EC.element_to_be_clickable((By.CSS_SELECTOR, '.btn-search')))
```

#### 3） 等待条件

（expected_conditions）

| 方法                                   | 说明                                                         |
| -------------------------------------- | ------------------------------------------------------------ |
| title_is                               | 判断当前页面的 title 是否完全等于（==）预期字符串，返回布尔值 |
| title_contains                         | 判断当前页面的 title 是否包含预期字符串，返回布尔值          |
| **presence_of_element_located**        | 判断某个元素是否被加到了 dom 树里，并不代表该元素一定可见    |
| visibility_of_element_located          | 判断元素是否可见（可见代表元素非隐藏，并且元素宽和高都不等于 0） |
| visibility_of                          | 同上一方法，只是上一方法参数为locator，这个方法参数是 定位后的元素 |
| presence_of_all_elements_located       | 判断是否至少有 1 个元素存在于 dom 树中。举例：如果页面上有 n 个元素的 class 都是’wp’，那么只要有 1 个元素存在，这个方法就返回 True |
| text_to_be_present_in_element          | 判断某个元素中的 text 是否 包含 了预期的字符串               |
| text_to_be_present_in_element_value    | 判断某个元素中的 value 属性是否包含 了预期的字符串           |
| frame_to_be_available_and_switch_to_it | 判断该 frame 是否可以 switch进去，如果可以的话，返回 True 并且 switch 进去，否则返回 False |
| invisibility_of_element_located        | 判断某个元素中是否不存在于dom树或不可见                      |
| element_to_be_clickable                | 判断某个元素中是否可见并且可点击                             |
| staleness_of                           | 等某个元素从 dom 树中移除，注意，这个方法也是返回 True或 False |
| element_to_be_selected                 | 判断某个元素是否被选中了,一般用在下拉列表                    |
| element_selection_state_to_be          | 判断某个元素的选中状态是否符合预期                           |
| element_located_selection_state_to_be  | 跟上面的方法作用一样，只是上面的方法传入定位到的 element，而这个方法传入 locator |
| alert_is_present                       | 判断页面上是否存在 alert                                     |

#### 4）异常

如果网络有问题，在设定时间内内没有成功加载，那就抛出 `TimeoutException` 异常

# 三、节点操作

节点操作均以节点为对象

## 3.1 查找结点

### 3.1.1 单个节点

返回元素节点，为 `WebElement `类型

#### 1）分类方法

***.find_element_by_XXX()***

```python
find_element_by_id('id_vaule') 				# 通过 id 定位元素
find_element_by_name('name_vaule') 			# 通过 name 定位元素
find_element_by_tag_name('tag_name_vaule') 	# 通过 tag_name 定位元素
find_element_by_class_name('class_name') 	# 通过 class_name 定位元素 
find_element_by_link_text('text_vaule') 	# 通过link标签（也就是a）的文本内容定位元素
find_element_by_partial_link_text('partial_text_vaule') 	# 通过link标签的部分文本内容定位元素
find_element_by_css_selector('css_selector') 				# 通过 css 选择器定位元素
find_element_by_xpath('xpath') 								# 通过 xpath 定位元素
```

例

```python
browser.find_element_by_id("coolestWidgetEvah")                          #按ID查找
browser.find_elements_by_xpath('//*[@id="q"]')                              #通过Xpath
browser.find_elements_by_class_name("cheese")                         #按类名查找
browser.find_elements_by_link_text("cheese")                              #按文本查找
browser.find_elements_by_partial_link_text("cheese")                  #按文本查找(模糊)
browser.find_elements_by_tag_name("iframe")                            #按标签查找
browser.find_elements_by_name("cheese")                                #按名称查找
```

#### 2）通用方法

***.find_element(By.XXX, value)***

```python
By.ID = "id"
By.XPATH = "xpath"
By.LINK_TEXT = "link text"
By.PARTIAL_LINK_TEXT = "partial link text"
By.NAME = "name"
By.TAG_NAME = "tag name"
By.CLASS_NAME = "class name"
By.CSS_SELECTOR = "css selector"
```

### 3.1.2 多个节点

如果要查找所有满足条件的节点，需要用 `find_elements()` 这样的方法。

返回节点列表，每个节点都是 `WebElement `类型。

## 3.2 获取节点信息

### 3.2.1 基本信息

- ***.get_attribute(value)***
  - 获取属性 Gets the given attribute or property of the element.
  - *value*：属性名

- ***.text***
  - 获取文本

- ***.id***
  - 获取 id，Internal ID used by selenium.
- ***.location***
  - 节点在页面中的相对位置，The location of the element in the renderable canvas.
- ***.size***
  - 获取节点大小（宽高），The size of the element.
- ***.tag_name***
  - 获取标签名称，This element’s `tagName` property.

### 3.2.2 判断操作

- ***is_displayed()***
  - 是否可见，Whether the element is visible to a user. 

- ***is_enabled()***
  - 是否可使用，Returns whether the element is enabled. 

- ***is_selected()*** 
  - 是否被选中，Returns whether the element is selected.Can be used to check if a checkbox or radio button is selected.

# 四、交互操作

Selenium 可以驱动浏览器来执行一些操作，也就是说可以让浏览器模拟执行一些动作

## 4.1 节点操作

以节点为对象的操作

- ***.send_keys(value)***
  - 选定元素进行输入，Simulates typing into the element.
  - *value*：输入的值，可以是字符串也可以是 `Keys` 类型

- ***.clear()***
  - 清空输入框 Clears the text if it’s a text entry element.

- ***.click()***
  - 点击元素，Clicks the element

- ***.submit()***
  - 提交，Submits a form.

- ***.screenshot(path)***
  - 节点截图，Saves a screenshot of the current element to a PNG image file. 
  - path：路径
  - usage： `element.screenshot(‘/Screenshots/foo.png’)`

## 4.2 动作链

还有另外一些操作，它们没有特定的执行对象，比如鼠标拖曳、键盘按键等，这些动作用动作链来执行

```python
actions = ActionChains(browser) # 声明动作链对象

actions.perform() # 执行操作
```

### 4.2.1 拖曳

- ***.drag_and_drop(source, target)***
  - 元素拖曳到另一个元素
  - source：起始节点
  - target：终止节点

- ***.drag_and_drop_by_offset(source, xoffset, yoffset)***

  - 元素按偏移量拖曳

  - source：The element to mouse down.
  - xoffset：X offset to move to.
  - yoffset：Y offset to move to.

### 4.2.2 点击

- ***.click(on_element=None)***
  - 点击元素，Clicks an element
  - *on_element*：The element to click. If None, clicks on current mouse position

- ***.click_and_hold()***
  - 按住元素，Holds down the left mouse button on an element.
- ***.release()***
  - 释放，Releasing a held mouse button on an element.

- ***.context_click()***
  - 右键单击元素，Performs a context-click (right click) on an element.

- ***.double_click()***
  - 双击元素，Double-clicks an element.

### 4.2.3 键盘操作

- ***.key_down(value)***

  - 按下不放，Sends a key press only, without releasing it.

    Should only be used with modifier keys (Control, Alt and Shift).

  - *value*：`Keys`对象，The modifier key to send. 
  - usage：`ActionChains(driver).key_down(Keys.CONTROL).send_keys('c').key_up(Keys.CONTROL).perform()`（pressing ctrl+c:）

- ***.key_up(value)***
  - 松开，Releases a modifier key.
  - *value*：`Keys` 对象，The modifier key to send. 

### 4.2.4 移动

- ***.move_to_element(to_element)***

  - 将光标移至元素中央，Moving the mouse to the middle of an element.
  - *to_element*：The WebElement to move to.

- ***.move_to_element_with_offset(to_element, xoffset, yoffset)***

  - 将光标移动指定偏移量，Move the mouse by an offset of the specified element.

    Offsets are relative to the top-left corner of the element.

  - *to_element*：The WebElement to move to.

  - *xoffset*：X offset to move to.

  - *yoffset*：Y offset to move to.

### 4.2.5 发送按键

- ***.send_keys(keys_to_send)***
  - 发送，Sends keys to current focused element.
  - *keys_to_send*：`Keys `对象，The keys to send. Modifier keys constants can be found in the ‘Keys’ class.
- ***.send_keys_to_element(element, keys_to_send)***
  - 发送到指定节点，Sends keys to an element.
  - *element*：The element to send keys.
  - *keys_to_send*：`Keys` 对象

## 4.6 执行 JavaScript

***browser.execute_script(JS_action)***

- JS_action：jS 指令

例

```python
browser = webdriver.Chrome()
browser.get('https://www.zhihu.com/explore')
browser.execute_script('window.scrollTo(0, document.body.scrollHeight)')
browser.execute_script('alert("To Bottom")')
```

## 4.7 Keys 对象

我们经常需要模拟键盘的输入，当输入普通的值时，在send_keys()方法中传入要输入的字符串就好了。

但是我们有时候会用到一些特殊的按键，这时候就需要用到我们的Keys类

例

```python
elem.send_keys(Keys.CONTROL, 'c')
```

按键

```python
ADD = u'\ue025'
ALT = u'\ue00a'
ARROW_DOWN = u'\ue015'
ARROW_LEFT = u'\ue012'
ARROW_RIGHT = u'\ue014'
ARROW_UP = u'\ue013'
BACKSPACE = u'\ue003'
BACK_SPACE = u'\ue003'
CANCEL = u'\ue001'
CLEAR = u'\ue005'
COMMAND = u'\ue03d'
CONTROL = u'\ue009'
DECIMAL = u'\ue028'
DELETE = u'\ue017'
DIVIDE = u'\ue029'
DOWN = u'\ue015'
END = u'\ue010'
ENTER = u'\ue007'
EQUALS = u'\ue019'
ESCAPE = u'\ue00c'
F1 = u'\ue031'
F10 = u'\ue03a'
F11 = u'\ue03b'
F12 = u'\ue03c'
F2 = u'\ue032'
F3 = u'\ue033'
F4 = u'\ue034'
F5 = u'\ue035'
F6 = u'\ue036'
F7 = u'\ue037'
F8 = u'\ue038'
F9 = u'\ue039'
HELP = u'\ue002'
HOME = u'\ue011'
INSERT = u'\ue016'
LEFT = u'\ue012'
LEFT_ALT = u'\ue00a'
LEFT_CONTROL = u'\ue009'
LEFT_SHIFT = u'\ue008'
META = u'\ue03d'
MULTIPLY = u'\ue024'
NULL = u'\ue000'
NUMPAD0 = u'\ue01a'
NUMPAD1 = u'\ue01b'
NUMPAD2 = u'\ue01c'
NUMPAD3 = u'\ue01d'
NUMPAD4 = u'\ue01e'
NUMPAD5 = u'\ue01f'
NUMPAD6 = u'\ue020'
NUMPAD7 = u'\ue021'
NUMPAD8 = u'\ue022'
NUMPAD9 = u'\ue023'
PAGE_DOWN = u'\ue00f'
PAGE_UP = u'\ue00e'
PAUSE = u'\ue00b'
RETURN = u'\ue006'
RIGHT = u'\ue014'
SEMICOLON = u'\ue018'
SEPARATOR = u'\ue026'
SHIFT = u'\ue008'
SPACE = u'\ue00d'
SUBTRACT = u'\ue027'
TAB = u'\ue004'
UP = u'\ue013'
```

# 五、常见操作

1. 设置浏览器类的 options 选项

```python
options = webdriver.ChromeOptions()
# 不加载图片,加快访问速度
options.add_experimental_option("prefs", {"profile.managed_default_content_settings.images": 2}) 
# 此步骤很重要，设置为开发者模式，防止被各大网站识别出来使用了Seleniu
options.add_experimental_option('excludeSwitches', ['enable-automation']) 

browser = webdriver.Chrome(options=options)
```



