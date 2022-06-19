#一级标题
##二级标题  

## 主要内容
> #### Markdown*是什么*？
> #### *谁*创造了它？
> #### *为什么*要使用它？
> #### *怎么*使用？
> #### *谁*在用？
> #### 尝试一下

## 正文
### 1. Markdown*是什么*？
**Markdown**是一种轻量级**标记语言**，它以纯文本形式(*易读、易写、易更改*)编写文档，并最终以HTML格式发布。    
**Markdown**也可以理解为将以MARKDOWN语法编写的语言转换成HTML内容的工具。    

### 2. *谁*创造了它？
它由[**Aaron Swartz**](http://www.aaronsw.com/)和**John Gruber**共同设计，**Aaron Swartz**就是那位于去年（*2013年1月11日*）自杀,有着**开挂**一般人生经历的程序员。维基百科对他的[介绍](http://zh.wikipedia.org/wiki/%E4%BA%9A%E4%BC%A6%C2%B7%E6%96%AF%E6%B2%83%E8%8C%A8)是：**软件工程师、作家、政治组织者、互联网活动家、维基百科人**。    

他有着足以让你跪拜的人生经历：    
+ **14岁**参与RSS 1.0规格标准的制订。     
+ **2004**年入读**斯坦福**，之后退学。   
+ **2005**年创建[Infogami](http://infogami.org/)，之后与[Reddit](http://www.reddit.com/)合并成为其合伙人。   
+ **2010**年创立求进会（Demand Progress），积极参与禁止网络盗版法案（SOPA）活动，最终该提案被撤回。   
+ **2011**年7月19日，因被控从MIT和JSTOR下载480万篇学术论文并以免费形式上传于网络被捕。     
+ **2013**年1月自杀身亡。    

![Aaron Swartz](https://github.com/younghz/Markdown/raw/master/resource/Aaron_Swartz.jpg)

天才都有早逝的归途。

### 3. *为什么*要使用它？
+ 它是易读（看起来舒服）、易写（语法简单）、易更改**纯文本**。处处体现着**极简主义**的影子。
+ 兼容HTML，可以转换为HTML格式发布。
+ 跨平台使用。
+ 越来越多的网站支持Markdown。
+ 更方便清晰地组织你的电子邮件。（Markdown-here, Airmail）
+ 摆脱Word（我不是认真的）。

### 4. *怎么*使用？
如果不算**扩展**，Markdown的语法绝对**简单**到让你爱不释手。

Markdown语法主要分为如下几大部分：
**标题**，**段落**，**区块引用**，**代码区块**，**强调**，**列表**，**分割线**，**链接**，**图片**，**反斜杠 `\`**，**符号'`'**。

#### 4.1 标题
两种形式：  
1）使用`=`和`-`标记一级和二级标题。
> 一级标题   
> `=========`   
> 二级标题    
> `---------`

效果：
> 一级标题   
> =========   
> 二级标题
> ---------  

2）使用`#`，可表示1-6级标题。
> \# 一级标题   
> \## 二级标题   
> \### 三级标题   
> \#### 四级标题   
> \##### 五级标题   
> \###### 六级标题    

效果：
> # 一级标题   
> ## 二级标题   
> ### 三级标题   
> #### 四级标题   
> ##### 五级标题   
> ###### 六级标题

#### 4.2 段落
段落的前后要有空行，所谓的空行是指没有文字内容。若想在段内强制换行的方式是使用**两个以上**空格加上回车（引用中换行省略回车）。

#### 4.3 区块引用
在段落的每行或者只在第一行使用符号`>`,还可使用多个嵌套引用，如：
> \> 区块引用  
> \>> 嵌套引用  

效果：
> 区块引用  
>> 嵌套引用

#### 4.4 代码区块
代码区块的建立是在每行加上4个空格或者一个制表符（如同写代码一样）。如    
普通段落：
```c++
void main()    
{    
    printf("Hello, Markdown.");    
}    

代码区块：

    void main()
    {
        printf("Hello, Markdown.");
    }
```

**注意**:需要和普通段落之间存在空行。

#### 4.5 强调
在强调内容两侧分别加上`*`或者`_`，如：
> \*斜体\*，\_斜体\_    
> \*\*粗体\*\*，\_\_粗体\_\_

效果：
> *斜体*，_斜体_    
> **粗体**，__粗体__

#### 4.6 列表
使用`·`、`+`、或`-`标记无序列表，如：
> \-（+\*） 第一项
> \-（+\*） 第二项
> \- （+\*）第三项

**注意**：标记后面最少有一个_空格_或_制表符_。若不在引用区块中，必须和前方段落之间存在空行。

效果：
> + 第一项
> + 第二项
> + 第三项

有序列表的标记方式是将上述的符号换成数字,并辅以`.`，如：
> 1 . 第一项   
> 2 . 第二项    
> 3 . 第三项    

效果：
> 1. 第一项
> 2. 第二项
> 3. 第三项

#### 4.7 分割线
分割线最常使用就是三个或以上`*`，还可以使用`-`和`_`。

#### 4.8 链接
链接可以由两种形式生成：**行内式**和**参考式**。    
**行内式**：
> \[younghz的Markdown库\]\(https:://github.com/younghz/Markdown "Markdown"\)。

效果：
> [younghz的Markdown库](https:://github.com/younghz/Markdown "Markdown")。

**参考式**：
> \[younghz的Markdown库1\]\[1\]    
> \[younghz的Markdown库2\]\[2\]    
> \[1\]:https:://github.com/younghz/Markdown "Markdown"    
> \[2\]:https:://github.com/younghz/Markdown "Markdown"    

效果：
> [younghz的Markdown库1][1]    
> [younghz的Markdown库2][2]

[1]: https:://github.com/younghz/Markdown "Markdown"
[2]: https:://github.com/younghz/Markdown "Markdown"

**注意**：上述的`[1]:https:://github.com/younghz/Markdown "Markdown"`不出现在区块中。

#### 4.9 图片
添加图片的形式和链接相似，只需在链接的基础上前方加一个`！`。
#### 4.10 反斜杠`\`
相当于**反转义**作用。使符号成为普通符号。
#### 4.11 符号'`'
起到标记作用。如：
>\`ctrl+a\`

效果：
>`ctrl+a`    

#### 5. *谁*在用？
Markdown的使用者：
+ GitHub
+ 简书
+ Stack Overflow
+ Apollo
+ Moodle
+ Reddit
+ 等等

#### 6. 尝试一下
+ **Chrome**下的插件诸如`stackedit`与`markdown-here`等非常方便，也不用担心平台受限。
+ **在线**的dillinger.io评价也不错   
+ **Windowns**下的MarkdownPad也用过，不过免费版的体验不是很好。    
+ **Mac**下的Mou是国人贡献的，口碑很好。
+ **Linux**下的ReText不错。    

**当然，最终境界永远都是笔下是语法，心中格式化 :)。**

****
**注意**：不同的Markdown解释器或工具对相应语法（扩展语法）的解释效果不尽相同，具体可参见工具的使用说明。
虽然有人想出面搞一个所谓的标准化的Markdown，[没想到还惹怒了健在的创始人John Gruber]
(http://blog.codinghorror.com/standard-markdown-is-now-common-markdown/ )。
****
以上基本是所有traditonal markdown的语法。

### 其它：
列表的使用(非traditonal markdown)：

用`|`表示表格纵向边界，表头和表内容用`-`隔开，并可用`:`进行对齐设置，两边都有`:`则表示居中，若不加`:`则默认左对齐。

|代码库                              |链接                                |
|:------------------------------------:|------------------------------------|
|MarkDown                              |[https://github.com/younghz/Markdown](https://github.com/younghz/Markdown "Markdown")|
|MarkDownCopy                              |[https://github.com/younghz/Markdown](https://github.com/younghz/Markdown "Markdown")|


# 方法重写

- 如果子类对继承父类的某个属性或方法不满意。可以在子类中对其方法进行重新编写
- 子类的重写后的方法可以通过super().\*** ()来调用父类中被重写的反伽梵。


| A   | B   | C   | D   |
| --- | --- | --- | --- |
| 1   | 2   | 3   | 4   |
| 4   | 5   | 6   | 7   |



> This is  a indent and offset 
1. 实干第一，不干半点马克思主义都没有
![美景](https://pgw.udn.com.tw/gw/photo.php?u=https://uc.udn.com.tw/photo/2015/09/06/draft/1282436.jpg&x=0&y=0&sw=0&sh=0&sl=W&fw=800&exp=3600&w=930&nt=1)
 
 $\LaTeX$能使用就非常好极好的一个做笔记的软件
 
*Test 这是一个斜体* 

**Test 这个粗体**

`凿井者，起于三寸之坎，以就万仞之深`


## **大道至简，实干为要。反对空谈，崇尚实干、注重落实。**
- 世界上的事都是干出来的，不干，半点马克思主义也没有
- 星光不问赶路人，时光不负实干者
- 干劲不可松懈，击楫中流更奋进


[百度一下](http;//www.bai.com)

```python

print("hello python")

```
# 今天是2020年10月24日从此认真用markdown做笔记回顾知识、掌握知识

## 字符串的常用操作
### 字符串的大小写转换的操作方法
> python中字符串的操作有 *.title() .append() .upper() .lower() .swapcase()*大小写相互转化

### 字符串内容对齐的操作方法
>*center(), ljust(), rjust(), zfill()*

>format(x,'0.2f'), ' '中有很多格式^10.1f,<10.1f,>10.1f,(,) ,(0,.1f) ,e,0.2E,

```python
print("|","Ursula".ljust(20,"*"),"|")    #左对齐
print("|","Ursula".center(20,"*"),"|")   #居中对齐
print("|","Ursula".rjust(20,"*"),"|")    #右对齐
#运行结果
| Ursula************** |
| *******Ursula******* |
| **************Ursula |
```

##### 通过format()函数格式化实现左对齐、居中、右对齐
```python
print("|",format("Ursula","*>20"),"|")    #左对齐
print("|",format("Ursula","*^20"),"|")   #居中对齐
print("|",format("Ursula","*<20"),"|")    #右对齐
#运行结果
| **************Ursula  |
| *******Ursula*******  |
| Ursula*************** |
```
### 判断字符串操作的方法
> isidentifier(), issapce(), isalpha(),isdecimal(),isnumeric(),isalnum()

### 格式化字符串的两种方式
> - %作为占位符 ```'我的名字叫：%s,今年%d岁了'```
> - {}作为占位符 ``` '我的名字叫:{0},今年{1}岁了，我真的叫:{0}'.format(name, age)```

#### 字符串的驻留：驻留的集中情况，驻留的优点，强制驻留的方法


整数的进制有二进制、十进制、八进制、十六进制分别是：118,0b1110101,0o166,0x76

为了将整数转换为二进制、八进制或十六进制的文本串,可以分别使用 bin() ,
oct() 或 hex() 函数:

或者说用format(x,'b')函数分别是b,o,x
> 为了将 bytes 解析为整数,使用 int.from_bytes() 方法,

> 为了将一个大整数转换为一个字节字符串,使用 int.to_bytes() 方法,

>如果需要的话,你可以使用 int.bit_length() 方法来决定需要多少字节位来存储这个直

如果要执行其他的复数函数比如正弦、余弦或平方根,使用 cmath 模块。numpy也可以构造一个负数数组并在这个数组上执行各种操作。如果你想生成一个复数返回结果,你必须显示的使用 cmath 模块,或者在某个支持复数的库中声明复数类型的使用。

fractions 模块可以被用来执行包含分数的数学运算

random 模块有大量的函数用来产生随机数和随机选择元素。比如,要想从一个序
列中随机的抽取一个元素,可以使用** random.choice() random.sample(),random.shuffle()打乱序列中元素的顺序，random.randint()生成随机整数，生成0到1范围内均匀分布的浮点数使用random.random(), 获取N为随机位(二进制)的整数**

除了上述功能能的，random模块还包含基于均匀分布、高斯分布和其他分布的随机数生成函数。比如random.uniform()计算均匀分布随机数，random.gauss()计算正太分布随机数。

---

类型的转化有：**int()  str()  float()这三者之间可以相互转化。还有布尔类型取值为True/False **浮点数存储不精确解决方案是导入模块decimal

文件的格式 coding=utf-8, gbk

####  算术运算符有：标准算术运算符、取余运算符、幂运算符

比较运算符有 >,<,>=,<=,!=,==,   is, is not

布尔运算符 and ,or, not, in ,not in

位运算符 &, |,<<,>>

详细的信息可在[python运算符中看到](https://www.runoob.com/python/python-operators.html)
### 总结运算的优先级(),-> 算术运算符-> 位运算符->比较运算符->布尔运算符->赋值运算符


#### 计算机的流程控制有：顺序结构、选择结构(if语句)、循环结构(while语句和for in语句)

- Python一切皆对象，所有对象有一个布尔值使用内置函数bool()
- 下面的对象的布尔值False:False,数值0,None,空字符串，空列表，空元组，空字典，空集合

###### *条件表达时if...else的简写*
语法结构: x if 判断条件 else y

运算规则：如果判断条件的的布尔值为True，条件表达式的返回值为x，否则条件表达式的返回值为False

选择结构有：单分支结构、双分支结构、对分支结构、嵌套if、条家表达式
****
range()函数的使用

反复做同一件的事情的情况，称为循环。循环的分类有 
- while
- for -in

语法结构

while 条件表达式:
     条件执行体(循环体)
	 
- if 是判断一次，条件为True执行一行
- while 是判断N+1次，条件为True执行N次

**break语句：用于结束循环结构，通常与分支结构if一起使用**

**else语句有三种情况： if...: else: ,   while...:  else: , for...: else: ... 第一个if条件表达时不成立时执行. 后面两个是碰到break时执行else.**

>**break 退出当前循环结构**
>**continue是结束当前循环进行下一次循环**

>嵌套循环是是：

>>  外循环执行一次内层循环执行完整一轮

>>while与for-in相互嵌套

# 列表
### 创建
### 特点
>1. 列表元素按顺序有序排列

>2. 索引映射唯一一个数据

>3. 列表可以存储重复数据

>4. 任意数据类型混存

>5. 根据需要动态分配和回收内存
 
### 列表查询操作
> index() 获取列表指定元素的索引 从0开始记.元素不存在则会抛出ValueError

> 获取列表中的单个元素:正向索引是从0到N-1. 负向索引是从-N到-1指定的索引不存在则抛出indexError

> 获取列表中的多个元素 用切片的方法

### 列表元素的增加操作 
>append()在末尾添加一个元素

>extennd()在末尾至少添加一个元素

>insert()在任意位置添加至少一个元素

### 列表元素的删除操作

>remove(), pop(), 切片，clear(), del 删除列表

### 列表元素的排序
>方法sort(), 内置函数sorted()

***
#### *字典和集合与类表的所学的内容有相似之处可比较总结学习*
***

# 集合
### 创建set()使用{}集合生成式
### 集合元素的判断操作 
> in 或not in
 
### 集合的遍历 for-in


### 集合元素的增加操作 
>add()一次添加一个元素

>update()一次至少添加一个元素


### 集合元素的删除操作

>remove()一次删除一个指定的元素，如果指定的元素不存抛出KeyError

> discard()一次删除一个指定的元素，如果指定的元素不存在不抛出KeyError

> pop()一次只删除一个任意元素

>clear()清空集合

### 集合是一个可变序列

| 数据结构    | 是否可变 | 是否重复               | 是否有序 | 定义符号    |
| ---         | ---      | ---                    | ---      | ---         |
| 列表(list)  | 可变     | 可重复                 | 有序     | []          |
| 元组(tuple) | 不可变   | 可重复                 | 有序     | ()          |
| 字典(dict)  | 可变     | key不可重复value可重复 | 无序     | {key:value} |
| 集合(set)   | 可变     | 不可重复               | 无序     | {}          |
***
# 函数 
> 1. 创建和调用
> 2. 参数的传递
> 3. 函数的返回值
> 4. 参数的定义
> 5. 变量的作用域
> 6. 递归函数

# python常见的异常类型
| 序号 | 异常类型          | 描述                              |
| ---  | ---               | ---                               |
| 1    | ZeroDivisionError | 除(或取模)零(所有数据类型)        |
| 2    | IndexError        | 序列中没有此索引(index)           |
| 3    | KeyError          | 映射中没有这个键                  |
| 4    | NameError         | 未声明/初始化对象那个（没有属性） |
| 5    | SyntaxError       | Python语法错误                    |
| 6    | ValueError        | 传入无效参数                      |


### *编程思想*

- 编程界的两大阵营
 
| 1      | 面向过程                                                                                                                                                           | 面向对象                               |
|---|---|---|
| 区别   | 事物比较简单，可以用线性思维去解决                                                                                                                                 | 事物比较复杂使用简单的线性思维无法解决 |
| 共同点 | 面向过程和面向对象都是解决实际问题的一种思维方式                                                                                                                   |                                        |
| 关系      | 二者相辅相成，并不是对立的解决复杂问题，通过面向对象方式便于我们从宏观上把握事物之间的复杂的关系，方便我们分析整个系统，具体到微观操作仍然使用面向过程方式来处理 |                                       |


# Python常用的内置模块
| 模块名   | 描述                                                   |
| ---      | ---                                                    |
| sys      | 与python解释器及其环境操作相关的标准库                 |
| time     | 提供与时间相关的各种函数的标准库                       |
| os       | 提供了访问操作系统的服务功能的标准库                   |
| calendar | 提供与日期相关的各种函数的标准库                       |
| urllib   | 用来读取来自网上的（服务器）的数据标准库               |
| json     | 用于使用JSON序列化和反序列化对象                       |
| re       | 用于字符串中执行正则表达式的匹配和替换                 |
| math     | 提供标准算术运算函数的标准库                           |
| decimal  | 进行精确控制运算精度有效数位和四舍五入操作的十进制运算 |
| logging  | 提供了灵活的记录事件错误警告和调试信息等日志信息的功能 |

