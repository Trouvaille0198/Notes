# 一、概念

JavaScript 是一种运行在浏览器中的解释型的编程语言
# 二、基本操作
## 2.1 变量的声明与赋值
```JavaScript
//var是一个JS关键字
var age;
//赋值
age = 3;
//变量的初始化=声明+赋值
var age = 18;
//一次声明多个变量
var game = "Overwatch",
    hero = "Genji",
    ultimate = "龍神の剣を喰らえ";
```
允许不声明，直接赋值
尽量不要用 name 作为变量名
声明变量本质——向内存申请空间
## 2.2 数据类型
1. JS 是一种弱类型语言（或动态语言），不用提前声明变量类型

2. 相同变量可以用作不同数据类型

3. JS 中有六种数据类型，包括五种基本数据类型（Number, String, Boolean, Undefined, Null），和一种复杂数据类型（Object）

5. 字符串的拼接——字符串 + 任何类型 = 新的字符串
6. 使用 var 声明了变量，但未给变量初始化值，那么这个变量的值就是undefined

### 2.2.1 Number

JavaScript 不区分整数和浮点数，统一用 Number 表示，以下都是合法的 Number 类型：

```javascript
123; 		// 整数 123
0.456; 		// 浮点数 0.456
1.2345e3; 	// 科学计数法表示 1.2345x1000，等同于 1234.5
-99; 		// 负数
NaN; 		// NaN表示Not a Number，当无法计算结果时用NaN表示
Infinity; 	// Infinity表 示无限大，当数值超过了 JavaScript 的 Number 所能表示的最大值时，就表示为 Infinity
```

说明

- 二进制前加 0b，八进制前加 0，十六进制前加 0x
- 最大值和最小值，Number.MAX_VALUE 和 Number.MIN_VALUE
- 其他特殊值
  - Infinity，无穷大；
  - -Infinity，无穷小；
  - NaN，代表一个非数值

### 2.2.2 字符串

字符串是以单引号 ' 或双引号 " 括起来的任意文本，比如 `'abc'`，`"xyz"` 等等。请注意，`''` 或 `""`本身只是一种表示方式，不是字符串的一部分

需要特别注意的是，字符串是不可变的，如果对字符串的某个索引赋值，不会有任何错误，但是，也没有任何效果

```javascript
var s = 'Test';
s[0] = 'X';
alert(s); // s仍然为'Test'
```

#### 1）多行字符串

由于多行字符串用`\n`写起来比较费事，所以最新的ES6标准新增了一种多行字符串的表示方法，用反引号 *`\* ... \*`* 表示：

```javascript
`这是一个
多行
字符串`;
```

#### 2）模板字符串

如果有很多变量需要连接，用 `+ `号就比较麻烦。ES6 新增了一种模板字符串，表示方法和上面的多行字符串一样，但是它会自动替换字符串中的变量：

```javascript
var name = '小明';
var age = 20;
var message = `你好, ${name}, 你今年${age}岁了!`;
alert(message);
```

#### 3）操作字符串

获取长度

```javascript
var s = 'Hello, world!';
s.length; // 13
```

把一个字符串全部变为大写

```javascript
var s = 'Hello';
s.toUpperCase(); // 返回'HELLO'
```

把一个字符串全部变为小写

```javascript
var s = 'Hello';
var lower = s.toLowerCase(); // 返回'hello'并赋值给变量lower
lower; // 'hello'
```

搜索指定字符串出现的位置

```javascript
var s = 'hello, world';
s.indexOf('world'); // 返回7
s.indexOf('World'); // 没有找到指定的子串，返回-1
```

返回指定索引区间的子串

```javascript
var s = 'hello, world'
s.substring(0, 5); // 从索引0开始到5（不包括5），返回'hello'
s.substring(7); // 从索引7开始到结束，返回'world'
```

### 2.2.3 布尔值

布尔值和布尔代数的表示完全一致，一个布尔值只有`true`、`false`两种值

```javascript
true; // 这是一个true值
false; // 这是一个false值
2 > 1; // 这是一个true值
2 >= 3; // 这是一个false值
```

JavaScript 在设计时，有两种比较运算符：

第一种是 `==` 比较，它会自动转换数据类型再比较，很多时候，会得到非常诡异的结果；

第二种是 `===` 比较，它不会自动转换数据类型，如果数据类型不一致，返回 `false`，如果一致，再比较。

由于 JavaScript 这个设计缺陷，不要使用 `==` 比较，始终坚持使用 `===` 比较。

另一个例外是 `NaN` 这个特殊的 Number 与所有其他值都不相等，包括它自己：

```javascript
NaN === NaN; // false
```

唯一能判断 `NaN` 的方法是通过 `isNaN()` 函数：

```javascript
isNaN(NaN); // true
```

最后要注意浮点数的相等比较：

```javascript
1 / 3 === (1 - 2 / 3); // false
```

这不是JavaScript的设计缺陷。浮点数在运算过程中会产生误差，因为计算机无法精确表示无限循环小数。要比较两个浮点数是否相等，只能计算它们之差的绝对值，看是否小于某个阈值：

```javascript
Math.abs(1 / 3 - (1 - 2 / 3)) < 0.0000001; // true
```

### 2.2.4 null 和 undefined

`null` 表示一个“空”的值，它和 `0` 以及空字符串 `''` 不同，`0` 是一个数值，`''` 表示长度为 0 的字符串，而 `null` 表示“空”。

在其他语言中，也有类似 JavaScript 的 `null` 的表示，例如 Java 也用 `null`，Swift 用 `nil`，Python 用 `None` 表示。但是，在JavaScript 中，还有一个和 `null` 类似的 `undefined`，它表示“未定义”。

JavaScript 的设计者希望用 `null` 表示一个空的值，而 `undefined` 表示值未定义。事实证明，这并没有什么卵用，区分两者的意义不大。大多数情况下，我们都应该用 `null`。`undefined` 仅仅在判断函数参数是否传递的情况下有用。

### 2.2.5 数组

数组是一组按顺序排列的集合，集合的每个值称为元素。JavaScript 的数组可以包括任意数据类型。例如：

```javascript
var arr = [1, 2, 3.14, 'Hello', null, true];
```

上述数组包含 6 个元素。数组用 `[]` 表示，元素之间用 `,` 分隔。

另一种创建数组的方法是通过 `Array()` 函数实现：

```javascript
var arr = new Array(1, 2, 3); // 创建了数组[1, 2, 3]
```

然而，出于代码的可读性考虑，强烈建议直接使用 `[]`。

数组的元素可以通过索引来访问。请注意，索引的起始值为 `0`：

```javascript
var arr = [1, 2, 3.14, 'Hello', null, true];
arr[0]; // 返回索引为0的元素，即1
arr[5]; // 返回索引为5的元素，即true
arr[6]; // 索引超出了范围，返回undefined
```

#### 1）获取长度 length 属性

要取得`Array`的长度，直接访问`length`属性：

```javascript
var arr = [1, 2, 3.14, 'Hello', null, true];
arr.length; // 6
```

*请注意*，直接给`Array`的`length`赋一个新的值会导致`Array`大小的变化：

```javascript
var arr = [1, 2, 3];
arr.length; // 3
arr.length = 6;
arr; // arr变为[1, 2, 3, undefined, undefined, undefined]
arr.length = 2;
arr; // arr变为[1, 2]
```

`Array`可以通过索引把对应的元素修改为新的值

请注意，如果通过索引赋值时，索引超过了范围，同样会引起`Array`大小的变化：

```javascript
var arr = [1, 2, 3];
arr[5] = 'x';
arr; // arr变为[1, 2, 3, undefined, undefined, 'x']
```

大多数其他编程语言不允许直接改变数组的大小，越界访问索引会报错。然而，JavaScript 的 `Array`却不会有任何错误。在编写代码时，不建议直接修改 `Array` 的大小，访问索引时要确保索引不会越界。

#### 2）搜索元素位置 .indexOf()

与 String 类似，`Array` 也可以通过 `indexOf()` 来搜索一个指定的元素的位置：

```javascript
var arr = [10, 20, '30', 'xyz'];
arr.indexOf(10); 	// 元素10的索引为0
arr.indexOf(20); 	// 元素20的索引为1
arr.indexOf(30); 	// 元素30没有找到，返回-1
arr.indexOf('30'); 	// 元素'30'的索引为2
```

注意了，数字 `30` 和字符串 `'30'` 是不同的元素。

#### 3）获取切片 .slice()

`slice()` 就是对应String的 `substring()` 版本，它截取 `Array `的部分元素，然后返回一个新的 `Array`：

```javascript
var arr = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
arr.slice(0, 3); // 从索引0开始，到索引3结束，但不包括索引3: ['A', 'B', 'C']
arr.slice(3); // 从索引3开始到结束: ['D', 'E', 'F', 'G']
```

注意到 `slice()` 的起止参数包括开始索引，不包括结束索引。

如果不给 `slice()` 传递任何参数，它就会从头到尾截取所有元素。利用这一点，我们可以很容易地复制一个 `Array`：

```javascript
var arr = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
var aCopy = arr.slice();
aCopy; // ['A', 'B', 'C', 'D', 'E', 'F', 'G']
aCopy === arr; // false
```

#### 4）尾部添加和删除 .push() 和 .pop()

`push()` 向 `Array` 的末尾添加若干元素，`pop()` 则把 `Array` 的最后一个元素删除掉：

```javascript
var arr = [1, 2];
arr.push('A', 'B'); // 返回Array新的长度: 4
arr; // [1, 2, 'A', 'B']
arr.pop(); // pop()返回'B'
arr; // [1, 2, 'A']
arr.pop(); arr.pop(); arr.pop(); // 连续pop 3次
arr; // []
arr.pop(); // 空数组继续pop不会报错，而是返回undefined
arr; // []
```

#### 5）头部添加和删除 .unshift() 和 .shift()

如果要往 `Array` 的头部添加若干元素，使用 `unshift()` 方法，`shift()` 方法则把 `Array` 的第一个元素删掉：

```javascript
var arr = [1, 2];
arr.unshift('A', 'B'); // 返回Array新的长度: 4
arr; // ['A', 'B', 1, 2]
arr.shift(); // 'A'
arr; // ['B', 1, 2]
arr.shift(); arr.shift(); arr.shift(); // 连续shift 3次
arr; // []
arr.shift(); // 空数组继续shift不会报错，而是返回undefined
arr; // []
```

#### 6）排序 .sort()

`sort()` 可以对当前 `Array` 进行排序，它会直接修改当前 `Array` 的元素位置，直接调用时，按照默认顺序排序：

```javascript
var arr = ['B', 'C', 'A'];
arr.sort();
arr; // ['A', 'B', 'C']
```

#### 7）添加兼删除 .splice()

`splice()` 方法是修改 `Array` 的“万能方法”

它可以从指定的索引开始删除若干元素，然后再从该位置添加若干元素：

```javascript
var arr = ['Microsoft', 'Apple', 'Yahoo', 'AOL', 'Excite', 'Oracle'];
// 从索引2开始删除3个元素,然后再添加两个元素:
arr.splice(2, 3, 'Google', 'Facebook'); // 返回删除的元素 ['Yahoo', 'AOL', 'Excite']
arr; // ['Microsoft', 'Apple', 'Google', 'Facebook', 'Oracle']
// 只删除,不添加:
arr.splice(2, 2); // ['Google', 'Facebook']
arr; // ['Microsoft', 'Apple', 'Oracle']
// 只添加,不删除:
arr.splice(2, 0, 'Google', 'Facebook'); // 返回[],因为没有删除任何元素
arr; // ['Microsoft', 'Apple', 'Google', 'Facebook', 'Oracle']
```

#### 8）连接 .concat()

`concat()` 方法把当前的 `Array` 和另一个 `Array` 连接起来，并返回一个新的 `Array`：

```javascript
var arr = ['A', 'B', 'C'];
var added = arr.concat([1, 2, 3]);
added; 	// ['A', 'B', 'C', 1, 2, 3]
arr; 	// ['A', 'B', 'C']
```

*请注意*，`concat()` 方法并没有修改当前 `Array`，而是返回了一个新的 `Array`。

实际上，`concat()` 方法可以接收任意个元素和 `Array`，并且自动把 `Array` 拆开，然后全部添加到新的 `Array` 里：

```javascript
var arr = ['A', 'B', 'C'];
arr.concat(1, 2, [3, 4]); // ['A', 'B', 'C', 1, 2, 3, 4]
```

#### 9）转换字符串 .join()

`join()` 方法是一个非常实用的方法，它把当前 `Array` 的每个元素都用指定的字符串连接起来，然后返回连接后的字符串：

```javascript
var arr = ['A', 'B', 'C', 1, 2, 3];
arr.join('-'); // 'A-B-C-1-2-3'
```

如果 `Array` 的元素不是字符串，将自动转换为字符串后再连接。

#### 10）检测是否为数组

1. 通用的检测方法

```javascript
function isArray(obj){
    return Object.prototype.toString.call(obj)=='[object Array]';
}
```

2. jquery 的判断写法

```javascript
var result=$.isArray(obj);
```

3. instanceof 操作符

```javascript
var ary = [1,23,4];
console.log(ary instanceof Array)	//true;
```

### 2.2.6 对象 Object

JavaScript 的对象是一组由键-值组成的无序集合，例如：

```javascript
var person = {
    name: 'Bob',
    age: 20,
    tags: ['js', 'web', 'mobile'],
    city: 'Beijing',
    hasCar: true,
    zipcode: null
};
```

JavaScript 对象的键都是字符串类型，值可以是任意数据类型。上述 `person` 对象一共定义了 6 个键值对，其中每个键又称为对象的属性，例如，`person` 的 `name` 属性为 `'Bob'`，`zipcode` 属性为 `null`。

要获取一个对象的属性，我们用 `对象变量.属性名` 的方式：

```javascript
person.name; 	// 'Bob'
person.zipcode; // null
```

实际上 JavaScript 对象的所有属性都是字符串，不过属性对应的值可以是任意数据类型。

JavaScript 规定，访问不存在的属性不报错，而是返回`undefined`

由于 JavaScript 的对象是动态类型，你可以自由地给一个对象添加或删除属性：

```javascript
var xiaoming = {
    name: '小明'
};
xiaoming.age; // undefined
xiaoming.age = 18; // 新增一个age属性
xiaoming.age; // 18
delete xiaoming.age; // 删除age属性
xiaoming.age; // undefined
delete xiaoming['name']; // 删除name属性
xiaoming.name; // undefined
delete xiaoming.school; // 删除一个不存在的school属性也不会报错
```

如果我们要检测`xiaoming`是否拥有某一属性，可以用`in`操作符：

```javascript
var xiaoming = {
    name: '小明',
    birth: 1990,
    school: 'No.1 Middle School',
    height: 1.70,
    weight: 65,
    score: null
};
'name' in xiaoming; // true
'grade' in xiaoming; // false
```

不过要小心，如果`in`判断一个属性存在，这个属性不一定是`xiaoming`的，它可能是`xiaoming`继承得到的：

```javascript
'toString' in xiaoming; // true
```

因为 `toString` 定义在 `object` 对象中，而所有对象最终都会在原型链上指向 `object`，所以 `xiaoming` 也拥有 `toString` 属性。

要判断一个属性是否是 `xiaoming` 自身拥有的，而不是继承得到的，可以用 `hasOwnProperty()` 方法：

```javascript
var xiaoming = {
    name: '小明'
};
xiaoming.hasOwnProperty('name'); // true
xiaoming.hasOwnProperty('toString'); // false
```

### 2.2.7 变量

变量的概念基本上和初中代数的方程变量是一致的，只是在计算机程序中，变量不仅可以是数字，还可以是任意数据类型。

变量在 JavaScript 中就是用一个变量名表示，变量名是大小写英文、数字、`$` 和 `_`的组合，且不能用数字开头。变量名也不能是JavaScript 的关键字，如 `if`、`while` 等。申明一个变量用 `var` 语句，比如：

```javascript
var a; 				// 申明了变量a，此时a的值为undefined
var $b = 1; 		// 申明了变量$b，同时给$b赋值，此时$b的值为1
var s_007 = '007'; 	// s_007是一个字符串
var Answer = true; 	// Answer是一个布尔值true
var t = null; 		// t的值是null
```

变量名也可以用中文，但是，请不要给自己找麻烦。

在 JavaScript 中，使用等号 `=` 对变量进行赋值。可以把任意数据类型赋值给变量，同一个变量可以反复赋值，而且可以是不同类型的变量，但是要注意只能用  `var` 申明一次，例如：

```javascript
var a = 123; // a的值是整数123
a = 'ABC'; // a变为字符串
```

这种变量本身类型不固定的语言称之为动态语言，与之对应的是静态语言。静态语言在定义变量时必须指定变量类型，如果赋值的时候类型不匹配，就会报错。和静态语言相比，动态语言更灵活，就是这个原因。

### 2.2.8 数据类型转换

1. 转换为字符串
   - `var.toString()`  返回一个字符串型
   - `String(var)`    返回一个字符串型
   - `var + ‘“”`       直接用”+“拼接字符串（隐式转换）

2. 转换为数字型
   - `parseInt(string)` 返回整数，摈弃小数部分，摈弃后缀非数字
   - `parseFloat(string)` 返回浮点数
   - `Number(string)`
   - 利用算术运算 - * /：`str * 1` or `str / 1` or `str - 0`

3. 转换为布尔型
   - `Boolean(var)` 返回布尔型，代表空、否定的值会被转换为false，如 '', 0, NaN, null, undefined

## 2.3 Map和Set

JavaScript的默认对象表示方式 `{}` 可以视为其他语言中的 `Map` 或 `Dictionary` 的数据结构，即一组键值对。

但是J avaScript 的对象有个小问题，就是键必须是字符串。但实际上 Number 或者其他数据类型作为键也是非常合理的。

### 2.3.1 Map

`Map` 是一组键值对的结构，具有极快的查找速度。

举个例子，假设要根据同学的名字查找对应的成绩，如果用 `Array` 实现，需要两个 `Array`：

```javascript
var names = ['Michael', 'Bob', 'Tracy'];
var scores = [95, 75, 85];
```

给定一个名字，要查找对应的成绩，就先要在names中找到对应的位置，再从scores取出对应的成绩，Array越长，耗时越长。

如果用Map实现，只需要一个“名字”-“成绩”的对照表，直接根据名字查找成绩，无论这个表有多大，查找速度都不会变慢。用 JavaScript 写一个 Map 如下：

```javascript
var m = new Map([['Michael', 95], ['Bob', 75], ['Tracy', 85]]);
m.get('Michael'); // 95
```

初始化 `Map` 需要一个二维数组，或者直接初始化一个空 `Map`。`Map` 具有以下方法：

```javascript
var m = new Map(); // 空Map
m.set('Adam', 67); // 添加新的key-value
m.set('Bob', 59);
m.has('Adam'); // 是否存在key 'Adam': true
m.get('Adam'); // 67
m.delete('Adam'); // 删除key 'Adam'
m.get('Adam'); // undefined
```

由于一个 key 只能对应一个 value，所以，多次对一个 key 放入 value，后面的值会把前面的值冲掉：

```javascript
var m = new Map();
m.set('Adam', 67);
m.set('Adam', 88);
m.get('Adam'); // 88
```

### 2.3.2 Set

`Set` 和 `Map`类似，也是一组 key 的集合，但不存储 value。由于 key 不能重复，所以，在 `Set` 中，没有重复的 key。

要创建一个 `Set`，需要提供一个`Array`作为输入，或者直接创建一个空 `Set`：

```javascript
var s1 = new Set(); // 空Set
var s2 = new Set([1, 2, 3]); // 含1, 2, 3
```

重复元素在 `Set` 中自动被过滤：

```javascript
var s = new Set([1, 2, 3, 3, '3']);
s; // Set {1, 2, 3, "3"}
```

通过 `add(key)` 方法可以添加元素到 `Set` 中，可以重复添加，但不会有效果：

```javascript
s.add(4);
s; // Set {1, 2, 3, 4}
s.add(4);
s; // 仍然是 Set {1, 2, 3, 4}
```

通过 `delete(key)` 方法可以删除元素：

```javascript
var s = new Set([1, 2, 3]);
s; // Set {1, 2, 3}
s.delete(3);
s; // Set {1, 2}
```