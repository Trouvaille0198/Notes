# 概念

JavaScript 是一种运行在浏览器中的解释型的编程语言
# 基本操作
## 变量的声明与赋值
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
## 数据类型
1. JS 是一种弱类型语言（或动态语言），不用提前声明变量类型

2. 相同变量可以用作不同数据类型

3. JS 中有六种数据类型，包括五种基本数据类型（Number, String, Boolean, Undefined, Null），和一种复杂数据类型（Object）

5. 字符串的拼接——字符串 + 任何类型 = 新的字符串
6. 使用 var 声明了变量，但未给变量初始化值，那么这个变量的值就是 undefined

### Number

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

### 字符串 String

字符串是以单引号 `'` 或双引号 `"` 括起来的任意文本，比如 `'abc'`，`"xyz"` 等等。请注意，`''` 或 `""`本身只是一种表示方式，不是字符串的一部分

需要特别注意的是，字符串是**不可变**的，如果对字符串的某个索引赋值，不会有任何错误，但是，也没有任何效果

```javascript
var s = 'Test';
s[0] = 'X';
alert(s); // s仍然为'Test'
```

#### 多行字符串

由于多行字符串用 `\n` 写起来比较费事，所以最新的ES6标准新增了一种多行字符串的表示方法，用反引号 ` 表示：

```javascript
`这是一个
多行
字符串`;
```

#### 模板字符串

如果有很多变量需要连接，用 `+ `号就比较麻烦。ES6 新增了一种模板字符串，表示方法和上面的多行字符串一样，但是它会自动替换字符串中的变量：

```javascript
var name = '小明';
var age = 20;
var message = `你好, ${name}, 你今年${age}岁了!`;
alert(message);
```

#### 操作字符串

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

把字符串分割为字符串数组

```javascript
var s = 'How are you doing today?'
s.split(' '); // [How,are,you,doing,today?]
s.split(''); // [H,o,w, ,a,r,e, ,y,o,u, ,d,o,i,n,g, ,t,o,d,a,y,?]
```

### 布尔值 Bool

布尔值和布尔代数的表示完全一致，一个布尔值只有 `true`、`false` 两种值

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

这不是 JavaScript 的设计缺陷。浮点数在运算过程中会产生误差，因为计算机无法精确表示无限循环小数。

要比较两个浮点数是否相等，只能**计算它们之差的绝对值**，看是否小于某个阈值：

```javascript
Math.abs(1 / 3 - (1 - 2 / 3)) < 0.0000001; // true
```

### null 和 undefined

`null` 表示一个“空”的值，它和 `0` 以及空字符串 `''` 不同，`0` 是一个数值，`''` 表示长度为 0 的字符串，而 `null` 表示“空”。

在其他语言中，也有类似 JavaScript 的 `null` 的表示，例如 Java 也用 `null`，Swift 用 `nil`，Python 用 `None` 表示。但是，在JavaScript 中，还有一个和 `null` 类似的 `undefined`，它表示“未定义”。

JavaScript 的设计者希望用 `null` 表示一个空的值，而 `undefined` 表示值未定义。事实证明，这并没有什么卵用，区分两者的意义不大。大多数情况下，我们都应该用 `null`。`undefined` 仅仅在判断函数参数是否传递的情况下有用。

### 数组 Array

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

#### 获取长度 length 属性

要取得 `Array` 的长度，直接访问 `length` 属性：

```javascript
var arr = [1, 2, 3.14, 'Hello', null, true];
arr.length; // 6
```

*请注意*，直接给 `Array` 的 `length` 赋一个新的值会导致 `Array` 大小的变化：

```javascript
var arr = [1, 2, 3];
arr.length; // 3
arr.length = 6;
arr; // arr变为[1, 2, 3, undefined, undefined, undefined]
arr.length = 2;
arr; // arr变为[1, 2]
```

`Array` 可以通过索引把对应的元素修改为新的值

请注意，如果通过索引赋值时，索引超过了范围，同样会引起`Array`大小的变化：

```javascript
var arr = [1, 2, 3];
arr[5] = 'x';
arr; // arr变为[1, 2, 3, undefined, undefined, 'x']
```

大多数其他编程语言不允许直接改变数组的大小，越界访问索引会报错。然而，JavaScript 的 `Array` 却不会有任何错误。在编写代码时，不建议直接修改 `Array` 的大小，访问索引时要确保索引不会越界。

#### 搜索元素位置 .indexOf()

与 String 类似，`Array` 也可以通过 `indexOf()` 来搜索一个指定的元素的位置：

```javascript
var arr = [10, 20, '30', 'xyz'];
arr.indexOf(10); 	// 元素10的索引为0
arr.indexOf(20); 	// 元素20的索引为1
arr.indexOf(30); 	// 元素30没有找到，返回-1
arr.indexOf('30'); 	// 元素'30'的索引为2
```

注意了，数字 `30` 和字符串 `'30'` 是不同的元素。

#### 获取切片 .slice()

`slice()` 就是对应String的 `substring()` 版本，它截取 `Array ` 的部分元素，然后返回一个新的 `Array`：

```javascript
var arr = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
arr.slice(0, 3); // 从索引0开始，到索引3结束，但不包括索引3: ['A', 'B', 'C']
arr.slice(3); // 从索引3开始到结束: ['D', 'E', 'F', 'G']
```

注意到 `slice()` 的起止参数包括开始索引，不包括结束索引。

如果不给 `slice()` 传递任何参数，它就会从头到尾截取所有元素。

利用这一点，我们可以很容易地复制一个 `Array`：

```javascript
var arr = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
var aCopy = arr.slice();
aCopy; // ['A', 'B', 'C', 'D', 'E', 'F', 'G']
aCopy === arr; // false
```

#### 尾部添加和删除 .push() 和 .pop()

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

#### 头部添加和删除 .unshift() 和 .shift()

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

#### 排序 .sort()

`sort()` 可以对当前 `Array` 进行排序，它会直接修改当前 `Array` 的元素位置，直接调用时，按照默认顺序排序：

```javascript
var arr = ['B', 'C', 'A'];
arr.sort();
arr; // ['A', 'B', 'C']
```

#### 添加兼删除 .splice()

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

#### 连接 .concat()

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

#### 转换字符串 .join()

`join()` 方法是一个非常实用的方法，它把当前 `Array` 的每个元素都用指定的字符串连接起来，然后返回连接后的字符串：

```javascript
var arr = ['A', 'B', 'C', 1, 2, 3];
arr.join('-'); // 'A-B-C-1-2-3'
```

如果 `Array` 的元素不是字符串，将自动转换为字符串后再连接。

#### 检测是否为数组

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



### 对象 Object

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

不过要小心，如果 `in` 判断一个属性存在，这个属性不一定是 `xiaoming` 的，它可能是 `xiaoming` 继承得到的：

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

### 变量

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

### 数据类型转换

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

## Map 和 Set

JavaScript的默认对象表示方式 `{}` 可以视为其他语言中的 `Map` 或 `Dictionary` 的数据结构，即一组键值对。

但是J avaScript 的对象有个小问题，就是键必须是字符串。但实际上 Number 或者其他数据类型作为键也是非常合理的。

### Map

`Map` 是一组键值对的结构，具有极快的查找速度。

举个例子，假设要根据同学的名字查找对应的成绩，如果用 `Array` 实现，需要两个 `Array`：

```javascript
var names = ['Michael', 'Bob', 'Tracy'];
var scores = [95, 75, 85];
```

给定一个名字，要查找对应的成绩，就先要在names中找到对应的位置，再从 scores 取出对应的成绩，Array 越长，耗时越长。

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
m.get('Adam'); 		// 88
```

### Set

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

## iterable

遍历 `Array` 可以采用下标循环，遍历 `Map` 和 `Set` 就无法使用下标。为了统一集合类型，ES6标准引入了新的 `iterable` 类型，`Array`、`Map` 和 `Set`都属于 `iterable` 类型。

### for … of

具有 `iterable` 类型的集合可以通过新的 `for ... of` 循环来遍历。

`for ... of` 循环是ES6引入的新的语法，

```javascript
var a = ['A', 'B', 'C'];
var s = new Set(['A', 'B', 'C']);
var m = new Map([[1, 'x'], [2, 'y'], [3, 'z']]);
for (var x of a) { // 遍历Array
    console.log(x);
}
for (var x of s) { // 遍历Set
    console.log(x);
}
for (var x of m) { // 遍历Map
    console.log(x[0] + '=' + x[1]);
}
```

### forEach

更好的方式是直接使用 `iterable` 内置的 `forEach` 方法，它接收一个函数，每次迭代就自动回调该函数

```javascript
var a = ['A', 'B', 'C'];
a.forEach(function (element, index, array) {
    // element: 指向当前元素的值
    // index: 指向当前索引
    // array: 指向Array对象本身
    console.log(element + ', index = ' + index);
});
```

`Set` 与 `Array` 类似，但 `Set` 没有索引，因此回调函数的前两个参数都是元素本身：

```javascript
var s = new Set(['A', 'B', 'C']);
s.forEach(function (element, sameElement, set) {
    console.log(element);
});
```

`Map` 的回调函数参数依次为 `value`、`key` 和 `map` 本身：

```javascript
var m = new Map([[1, 'x'], [2, 'y'], [3, 'z']]);
m.forEach(function (value, key, map) {
    console.log(value);
});
```

如果对某些参数不感兴趣，由于 JavaScript 的函数调用不要求参数必须一致，因此可以忽略它们。例如，只需要获得 `Array` 的 `element`：

```javascript
var a = ['A', 'B', 'C'];
a.forEach(function (element) {
    console.log(element);
});
```

### for in 和 for of 辨析

for... in 

- 遍历对象时，得到 key
- 遍历数组时，得到下标

for... of

- 遍历数组时，得到值
- 不能遍历对象

# 函数

```javascript
//1、利用函数关键字
function 函数名() {
    //函数体
}

//2、函数表达式（匿名函数，只有变量名没有函数名）
var 变量名 = function () {
    //函数体
};
```

1. 如果没有`return`语句，函数执行完毕后也会返回结果，只是结果为`undefined`

2. 在第二种声明方式下，`function (x) { ... }` 是一个匿名函数，它没有函数名。但是，这个匿名函数赋值给了变量 `变量名`，所以，通过变量`变量名`就可以调用该函数。上述两种定义*完全等价*，注意第二种方式按照完整语法需要在函数体末尾加一个 `;`，表示赋值语句结束。
3. 由于 JavaScript 允许传入任意个参数而不影响调用，因此传入的参数比定义的参数多也没有问题，虽然函数内部并不需要这些参数
4. 传入的参数比定义的少也没有问题，返回 `NaN`

## arguements

JavaScript还有一个免费赠送的关键字 `arguments`，它只在函数内部起作用，并且永远指向当前函数的调用者传入的所有参数。`arguments` 类似`Array `但它不是一个 `Array`

```javascript
function foo(x) {
    console.log('x = ' + x); // 10
    for (var i=0; i<arguments.length; i++) {
        console.log('arg ' + i + ' = ' + arguments[i]); // 10, 20, 30
    }
}
foo(10, 20, 30);

//输出
x = 10
arg 0 = 10
arg 1 = 20
arg 2 = 30
```

利用  `arguments`，可以获得调用者传入的所有参数。也就是说，即使函数不定义任何参数，还是可以拿到参数的值

```javascript
function abs() {
    if (arguments.length === 0) {
        return 0;
    }
    var x = arguments[0];
    return x >= 0 ? x : -x;
}

abs(); // 0
abs(10); // 10
abs(-9); // 9
```

实际上 `arguments` 最常用于判断传入参数的个数。你可能会看到这样的写法：

```javascript
// foo(a[, b], c)
// 接收2~3个参数，b是可选参数，如果只传2个参数，b默认为null：
function foo(a, b, c) {
    if (arguments.length === 2) {
        // 实际拿到的参数是a和b，c为undefined
        c = b; // 把b赋给c
        b = null; // b变为默认值
    }
    // ...
}
```

要把中间的参数 `b` 变为“可选”参数，就只能通过 `arguments` 判断，然后重新调整参数并赋值。

## rest

```javascript
function foo(a, b, ...rest) {
    console.log('a = ' + a);
    console.log('b = ' + b);
    console.log(rest);
}

foo(1, 2, 3, 4, 5);
// 结果:
// a = 1
// b = 2
// Array [ 3, 4, 5 ]

foo(1);
// 结果:
// a = 1
// b = undefined
// Array []
```

rest 参数只能写在最后，前面用 `...` 标识，传入的参数先绑定`a`、`b`，多余的参数以数组形式交给变量 `rest`，所以，不再需要 `arguments` 我们就获取了全部参数。

如果传入的参数连正常定义的参数都没填满，也不要紧，rest 参数会接收一个空数组（注意不是 `undefined` ）

```javascript
function sum(...rest) {
    var result = 0;
    for (var i = 0; i < rest.length; i++) {
        result += rest[i];
    }
    return result;
}
```

## 变量作用域与解构赋值

1. 如果一个变量在函数体内部申明，则该变量的作用域为整个函数体，在函数体外不可引用该变量
2. 不同函数内部的同名变量互相独立，互不影响
3. 由于 JavaScript 的函数可以嵌套，此时，内部函数可以访问外部函数定义的变量，反过来则不行

```javascript
function foo() {
    var x = 1;
    function bar() {
        var y = x + 1; // bar可以访问foo的变量x!
    }
    var z = y + 1; // ReferenceError! foo不可以访问bar的变量y!
}
```

4. JavaScript 的函数在查找变量时从自身函数定义开始，从“内”向“外”查找。如果内部函数定义了与外部函数重名的变量，则内部函数的变量将“屏蔽”外部函数的变量

```javascript
function foo() {
    var x = 1;
    function bar() {
        var x = 'A';
        console.log('x in bar() = ' + x); // 'A'
    }
    console.log('x in foo() = ' + x); // 1
    bar();
}
```

## 变量提升

JavaScript 的函数定义有个特点，它会先扫描整个函数体的语句，把所有申明的变量“提升”到函数顶部

```javascript
function foo() {
    var x = 'Hello, ' + y;
    console.log(x);
    var y = 'Bob';
}
```

语句 `var x = 'Hello, ' + y;` 并不报错，原因是变量 `y` 在稍后申明了。但是 `console.log` 显示 `Hello, undefined`，说明变量 `y` 的值为 `undefined`。这正是因为 JavaScript 引擎自动提升了变量 `y` 的声明，但不会提升变量 `y` 的赋值。

由于 JavaScript 的这一怪异的“特性”，我们在函数内部定义变量时，请严格遵守“在函数内部首先申明所有变量”这一规则。最常见的做法是用一个 `var` 申明函数内部用到的所有变量

```javascript
function foo() {
    var
        x = 1, // x初始化为1
        y = x + 1, // y初始化为2
        z, i; // z和i为undefined
    // 其他语句:
    for (i=0; i<100; i++) {
        ...
    }
}
```

## 全局作用域

不在任何函数内定义的变量就具有全局作用域。实际上，JavaScript默认有一个全局对象`window`，全局作用域的变量实际上被绑定到 `window` 的一个属性：

例如，直接访问全局变量 `course` 和访问 `window.course` 是完全一样的。

顶层函数的定义也被视为一个全局变量，并绑定到 `window` 对象：

```javascript
var course = 'Learn JavaScript';
alert(course); // 'Learn JavaScript'
alert(window.course); // 'Learn JavaScript'

function foo() {
    alert('foo');
}

foo(); // 直接调用foo()
window.foo(); // 通过window.foo()调用
```

这说明 JavaScript 实际上只有一个全局作用域。任何变量（函数也视为变量），如果没有在当前函数作用域中找到，就会继续往上查找，最后如果在全局作用域中也没有找到，则报 `ReferenceError` 错误

## 名字空间

全局变量会绑定到 `window` 上，不同的 JavaScript 文件如果使用了相同的全局变量，或者定义了相同名字的顶层函数，都会造成命名冲突，并且很难被发现。

减少冲突的一个方法是把自己的所有变量和函数全部绑定到一个全局变量中

```javascript
// 唯一的全局变量MYAPP:
var MYAPP = {};

// 其他变量:
MYAPP.name = 'myapp';
MYAPP.version = 1.0;

// 其他函数:
MYAPP.foo = function () {
    return 'foo';
};
```

把自己的代码全部放入唯一的名字空间`MYAPP`中，会大大减少全局变量冲突的可能。

许多著名的JavaScript库都是这么干的：jQuery，YUI，underscore等等

## 局部作用域 

由于 JavaScript 的变量作用域实际上是函数内部，我们在 `for` 循环等语句块中是无法定义具有局部作用域的变量的：

```javascript
function foo() {
    for (var i=0; i<100; i++) {
        //
    }
    i += 100; // 仍然可以引用变量i
}
```

为了解决块级作用域，ES6引入了新的关键字 `let`，用 `let` 替代 `var` 可以**申明一个块级作用域的变量**：

```javascript
function foo() {
    var sum = 0;
    for (let i=0; i<100; i++) {
        sum += i;
    }
    // SyntaxError:
    i += 1;
}
```

==let 的具体作用==：https://typescript.bootcss.com/variable-declarations.html

## 常量

由于 `var` 和 `let` 申明的是变量，如果要申明一个常量，在 ES6 之前是不行的，我们通常用全部大写的变量来表示“这是一个常量，不要修改它的值”

```javascript
var PI = 3.14;
```

ES6标准引入了新的关键字 `const` 来定义常量，`const` 与 `let` 都具有块级作用域：

```javascript
'use strict';

const PI = 3.14;
PI = 3; // 某些浏览器不报错，但是无效果！
PI; // 3.14
```

## 解构赋值

从 ES6 开始，JavaScript 引入了解构赋值，可以同时对一组变量进行赋值。

```javascript
var [x, y, z] = ['hello', 'JavaScript', 'ES6'];
```

### 详解

如果数组本身还有嵌套，也可以通过下面的形式进行解构赋值，注意嵌套层次和位置要保持一致

```javascript
let [x, [y, z]] = ['hello', ['JavaScript', 'ES6']];
x; // 'hello'
y; // 'JavaScript'
z; // 'ES6'
```

解构赋值还可以忽略某些元素

```javascript
let [, , z] = ['hello', 'JavaScript', 'ES6']; // 忽略前两个元素，只对z赋值第三个元素
z; // 'ES6'
```

如果需要从一个对象中取出若干属性，也可以使用解构赋值，便于快速获取对象的指定属性

```javascript
var person = {
    name: '小明',
    age: 20,
    gender: 'male',
    passport: 'G-12345678',
    school: 'No.4 middle school',
    address: {
        city: 'Beijing',
        street: 'No.1 Road',
        zipcode: '100001'
    }
};
var {name, address: {city, zip}} = person;
name; // '小明'
city; // 'Beijing'
zip; // undefined, 因为属性名是zipcode而不是zip
// 注意: address不是变量，而是为了让city和zip获得嵌套的address对象的属性:
address; // Uncaught ReferenceError: address is not defined
```

如果要使用的变量名和属性名不一致，可以用下面的语法获取

```javascript
var person = {
    name: '小明',
    age: 20,
    gender: 'male',
    passport: 'G-12345678',
    school: 'No.4 middle school'
};

// 把passport属性赋值给变量id:
let {name, passport:id} = person;
name; // '小明'
id; // 'G-12345678'
// 注意: passport不是变量，而是为了让变量id获得passport属性:
passport; // Uncaught ReferenceError: passport is not defined
```

解构赋值还可以使用默认值，这样就避免了不存在的属性返回`undefined`的问题

```javascript
var person = {
    name: '小明',
    age: 20,
    gender: 'male',
    passport: 'G-12345678'
};

// 如果person对象没有single属性，默认赋值为true:
var {name, single=true} = person;
name; // '小明'
single; // true
```

有些时候，如果变量已经被声明了，再次赋值的时候，正确的写法也会报语法错误

```javascript
// 声明变量:
var x, y;
// 解构赋值:
{x, y} = { name: '小明', x: 100, y: 200};
// 语法错误: Uncaught SyntaxError: Unexpected token =
```

这是因为JavaScript引擎把 `{` 开头的语句当作了块处理，于是 `= `不再合法。解决方法是用小括号括起来：

```javascript
({x, y} = { name: '小明', x: 100, y: 200});
```

### 使用场景

解构赋值在很多时候可以大大简化代码。例如，交换两个变量`x`和`y`的值，可以这么写，不再需要临时变量：

```javascript
var x=1, y=2;
[x, y] = [y, x]快速获取当前页面的域名和路径：
```

```
var {hostname:domain, pathname:path} = location;
```

如果一个函数接收一个对象作为参数，那么，可以使用解构直接把对象的属性绑定到变量中。例如，下面的函数可以快速创建一个`Date`对象：

```javascript
function buildDate({year, month, day, hour=0, minute=0, second=0}) {
    return new Date(year + '-' + month + '-' + day + ' ' + hour + ':' + minute + ':' + second);
}
```

它的方便之处在于传入的对象只需要`year`、`month`和`day`这三个属性：

```javascript
buildDate({ year: 2017, month: 1, day: 1 });
// Sun Jan 01 2017 00:00:00 GMT+0800 (CST)
```

也可以传入`hour`、`minute`和`second`属性：

```javascript
buildDate({ year: 2017, month: 1, day: 1, hour: 20, minute: 15 });
// Sun Jan 01 2017 20:15:00 GMT+0800 (CST)
```

使用解构赋值可以减少代码量，但是，需要在支持ES6解构赋值特性的现代浏览器中才能正常运行。目前支持解构赋值的浏览器包括Chrome，Firefox，Edge等

## 方法

在一个对象中绑定函数，称为这个对象的方法

```javascript
var xiaoming = {
    name: '小明',
    birth: 1990,
    age: function () {
        var y = new Date().getFullYear();
        return y - this.birth;
    }
};

xiaoming.age; // function xiaoming.age()
xiaoming.age(); // 今年调用是25,明年调用就变成26了
```

在一个方法内部，`this` 是一个特殊变量，它始终指向当前对象，也就是 `xiaoming` 这个变量。所以，`this.birth` 可以拿到 `xiaoming` 的 `birth `属性。

### 函数嵌套中的 this 用法

用`var that = this;`，你就可以放心地在方法内部定义其他函数

```javascript
var xiaoming = {
    name: '小明',
    birth: 1990,
    age: function () {
        var that = this; // 在方法内部一开始就捕获this
        function getAgeFromBirth() {
            var y = new Date().getFullYear();
            return y - that.birth; // 用that而不是this
        }
        return getAgeFromBirth();
    }
};

xiaoming.age(); // 25
```

### apply

要指定函数的 `this` 指向哪个对象，可以用函数本身的 `apply` 方法，它接收两个参数，第一个参数就是需要绑定的 `this` 变量，第二个参数是 `Array`，表示函数本身的参数。

用 `apply` 修复 `getAge()` 调用

```javascript
function getAge() {
    var y = new Date().getFullYear();
    return y - this.birth;
}

var xiaoming = {
    name: '小明',
    birth: 1990,
    age: getAge
};

xiaoming.age(); // 25
getAge.apply(xiaoming, []); // 25, this指向xiaoming, 参数为空
```

另一个与 `apply()` 类似的方法是 `call()`，唯一区别是：

- `apply()` 把参数打包成 `Array` 再传入；
- `call()` 把参数按顺序传入。

比如调用 `Math.max(3, 5, 4)`，分别用 `apply()` 和 `call()` 实现如下：

```javascript
Math.max.apply(null, [3, 5, 4]); // 5
Math.max.call(null, 3, 5, 4); // 5
```

对普通函数调用，我们通常把 `this` 绑定为 `null`。

### 装饰器

利用 `apply()`，我们还可以动态改变函数的行为。

JavaScript的所有对象都是动态的，即使内置的函数，我们也可以重新指向新的函数。

例

现在假定我们想统计一下代码一共调用了多少次 `parseInt()`，可以把所有的调用都找出来，然后手动加上 `count += 1`，不过这样做太傻了。最佳方案是用我们自己的函数替换掉默认的 `parseInt()`：

```javascript
var count = 0;
var oldParseInt = parseInt; // 保存原函数

window.parseInt = function () {
    count += 1;
    return oldParseInt.apply(null, arguments); // 调用原函数
};
```

## 高阶函数

JavaScript 的函数其实都指向某个变量。既然变量可以指向函数，函数的参数能接收变量，那么一个函数就可以接收另一个函数作为参数，这种函数就称之为高阶函数

```javascript
function add(x, y, f) {
    return f(x) + f(y);
}
```

编写高阶函数，就是让函数的参数能够接收别的函数

### map

要把一个函数作用在一个数组上，就可以用 `map` 实现

`map() `方法定义在 JavaScript 的 `Array` 中

```javascript
function pow(x) {
    return x * x;
}
var arr = [1, 2, 3, 4, 5, 6, 7, 8, 9];
var results = arr.map(pow); 
console.log(results); // [1, 4, 9, 16, 25, 36, 49, 64, 81]
```

### reduce

Array 的 `reduce()` 把一个函数作用在这个 `Array` 的 `[x1, x2, x3...]` 上，这个函数必须接收两个参数，`reduce()` 把结果继续和序列的下一个元素做累积计算，其效果就是：

```javascript
[x1, x2, x3, x4].reduce(f) = f(f(f(x1, x2), x3), x4)
```

比方说对一个`Array`求和，就可以用`reduce`实现

```javascript
var arr = [1, 3, 5, 7, 9];
arr.reduce(function (x, y) {
    return x + y;
}); // 25
```

## 箭头函数

箭头函数包括一个参数列表（零个或多个参数，如果参数个数不是一个的话要用 `()` 包围起来），然后是标识 `=>`，函数体放在最后。

只有在函数体的表达式个数多于 1 个，或者函数体包含非表达式语句的时候才需要用 `{}` 包围。如果只有一个表达式，并且省略了包围的 `{}` 的话，则意味着表达式前面有一个隐含的 `return`。

```javascript
var f1 = () => 12; 
var f2 = x => x * 2; 
var f3 = (x,y) => { 
    var z = x * 2 + y; 
    y++; 
    x *= 3; 
    return (x + y + z) / 2; 
};
```

# 面向对象编程

JavaScript 不区分类和实例的概念，而是通过**原型**（prototype）来实现面向对象编程。

JavaScript 的原型链和 Java 的 Class 区别就在，它没有“Class”的概念，所有对象都是实例，所谓继承关系不过是把一个对象的原型指向另一个对象而已

## 创建对象

### 原型回溯

JavaScript 对每个创建的对象都会设置一个原型，指向它的原型对象。

当我们用 `obj.xxx` 访问一个对象的属性时，JavaScript 引擎先在当前对象上查找该属性，如果没有找到，就到其原型对象上找，如果还没有找到，就一直上溯到 `Object.prototype` 对象，最后，如果还没有找到，就只能返回 `undefined`

1. 创建一个 `Array` 对象：

```javascript
var arr = [1, 2, 3];
```

​	其原型链是：

```javascript
arr ----> Array.prototype ----> Object.prototype ----> null
```

2. 创建一个函数时：

```javascript
function foo() {
    return 0;
}
```

​	函数也是一个对象，它的原型链是：

```javascript
foo ----> Function.prototype ----> Object.prototype ----> null
```

如果原型链很长，那么访问一个对象的属性就会因为花更多的时间查找而变得更慢，因此要注意不要把原型链搞得太长

### 构造函数

例

```javascript
function Cat(name) {
    this.name = name;
    // this.say = function () {
    //     alert('miao~ ' + this.name);
    // }
}
Cat.prototype.say = function () {
    alert('miao~ ' + this.name);
}
var cat1 = new Cat('aa');
var cat2 = new Cat('bb');
cat1.say();
cat2.say();
```

#### 构造

除了直接用 `{ ... }` 创建一个对象外，JavaScript 还可以用一种构造函数的方法来创建对象。它的用法是，先定义一个构造函数

```javascript
function Student(name) {
    this.name = name;
    this.hello = function () {
        alert('Hello, ' + this.name + '!');
    }
}
```

按照约定，构造函数首字母应当大写，而普通函数首字母应当小写

#### 调用

用关键字 `new` 来调用这个函数，并返回一个对象

```javascript
var xiaoming = new Student('小明');
xiaoming.name; // '小明'
xiaoming.hello(); // Hello, 小明!
```

> 如果不写 `new`，这就是一个普通函数，它返回 `undefined`。但是，如果写了 `new`，它就变成了一个构造函数，它绑定的 `this` 指向新创建的对象，并默认返回 `this`，也就是说，不需要在最后写 `return this;`

#### constructor 属性

对象会从原型上获得了个 `constructor`属性，它指向构造函数本身

```javascript
xiaoming.constructor === Student.prototype.constructor === Student; 

Object.getPrototypeOf(xiaoming) === Student.prototype; // true

xiaoming instanceof Student; // true
```

![protos](http://image.trouvaille0198.top/l)

#### 共享函数

Javascript 规定，每一个构造函数都有一个 `prototype` 属性，指向另一个对象。这个对象的所有属性和方法，都会被构造函数的实例继承。

要让创建的对象共享一个函数，根据对象的属性查找原则，我们只要把这个函数移动到对象共同的原型上就可以了，在例子中也就是 `Student.prototype`

修改代码如下：

```javascript
function Student(name) {
    this.name = name;
}

Student.prototype.hello = function () {
    alert('Hello, ' + this.name + '!');
};
```

#### 封装

可以编写一个 `createStudent()` 函数，在内部封装所有的 `new` 操作。一个常用的编程模式像这样：

```javascript
function Student(props) {
    this.name = props.name || '匿名'; 	   // 默认值为'匿名'
    this.grade = props.grade || 1; 			// 默认值为1
}

Student.prototype.hello = function () {
    alert('Hello, ' + this.name + '!');
};

function createStudent(props) {
    return new Student(props || {})
}
```

这个 `createStudent()` 函数有几个巨大的优点：一是不需要 `new` 来调用，二是参数非常灵活，可以不传，也可以这么传：

```javascript
var xiaoming = createStudent({
    name: '小明'
});

xiaoming.grade; // 1
```

如果创建的对象有很多属性，我们只需要传递需要的某些属性，剩下的属性可以用默认值。由于参数是一个 Object，我们无需记忆参数的顺序。如果恰好从 `JSON` 拿到了一个对象，就可以直接创建出 `xiaoming`。

### 原型继承

在传统的基于Class的语言如Java、C++中，继承的本质是扩展一个已有的Class，并生成新的Subclass。

由于这类语言严格区分类和实例，继承实际上是类型的扩展。但是，JavaScript由于采用原型继承，我们无法直接扩展一个Class，因为根本不存在Class这种类型。

JS 的继承就你妈是一坨屎，暂且不学

### class 继承

新的关键字 `class` 从 ES6 开始正式被引入到 JavaScript 中。`class` 的目的就是让定义类更简单。

```javascript
class Student {
    constructor(name) {
        this.name = name;
    }

    hello() {
        alert('Hello, ' + this.name + '!');
    }
}
```

> 比较一下就可以发现，`class` 的定义包含了构造函数 `constructor` 和定义在原型对象上的函数 `hello()`（注意没有 `function` 关键字），这样就避免了 `Student.prototype.hello = function () {...}` 这样分散的代码。

用 `class `定义对象，继承可以直接通过 `extends` 来实现

```javascript
class PrimaryStudent extends Student {
    constructor(name, grade) {
        super(name); // 记得用super调用父类的构造方法!
        this.grade = grade;
    }

    myGrade() {
        alert('I am at grade ' + this.grade);
    }
}
```

