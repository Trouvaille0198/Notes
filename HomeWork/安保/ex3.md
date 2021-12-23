# 实验三

1. **用频率分析破解单表代换密码。**

对密文进行单字频率分析

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/LOzWPwcyUNbolrH.png" alt="image-20211222133521698" style="zoom:50%;" />

双字频率分析

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/E6GpVPc1CDw4Xjq.png" alt="image-20211222133641514" style="zoom:50%;" />

三字频率分析

<img src="https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/E6GpVPc1CDw4Xjq.png" alt="image-20211222133741641" style="zoom:50%;" />

由此可以进行猜测

1. 三字频率最大可能是单词 “the”
2. 单字频率最大可能是 “e”
3. 单字频率第二第三可能是 “t” 和 “a”
4. 双字频率前三可能是 “th”，“he”，“in”

四种猜测可能性降序排列。

又发现，猜测 1 和猜测 4 可以互相验证，基本可以确定密文 “ytn” 对应明文 “the”，密文 “v” 对应明文 “a”

预览变化

![image-20211222152616869](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211222152616869.png)

猜测双字频率很高的 “mu” 对应 “in”

"er"、“re”、“ed” 也是使用频次很高的二元字母序列，已知密文 “n” 对应明文 “e”，所以这三个序列可以完美对应频次表中的 “nh”、“nq”、“hn”；得：

- 密文 “h” 对应 “r”
- 密文 “q” 对应 “d”

接下来分析叠字的频率：

<img src="https://s2.loli.net/2021/12/22/zCKM7N9oHmyOIcX.png" alt="image-20211222140146777" style="zoom: 50%;" />

将结果与常用叠字作比较

![image-20211222140355452](https://s2.loli.net/2021/12/22/rdNnq7pCh9sc3LI.png)

可以肯定的是：“nn” 对应 “ee”，“yy” 对应 “tt”，因为这些字母均与之前的猜想互相印证

前文中**密文 “q” 对应 “d”** 的猜测需要做出更改，因为 “dd” 并不是常用的叠字；“q” 更有可能对应 “s”，因为 “es” 也是常用的二字序列之一。

又做出猜测：“ii” 对应 “ll”、“xx” 对应 “oo”（“x” 频率很高，“o” 在常用单字里频率也很高 ）

预览变化（以大写字母表示已经做过代换的字母）

![image-20211222153233897](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211222153233897.png)

发现一些常用词，如 “the”、“this”、“on”，已经显示出来了。

分析结果，我们可以发现一些规律：

1. 多次出现了 “Ob” 单词，且其后多跟着 “the” 和 “this”；又有单词 ”ObTEN“；猜测对应 “of”，则密文 ”b“ 对应明文 ”f“

    ![image-20211222153306734](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211222153306734.png)

2. 出现 “NEfER” 字眼，猜测为 “never”，则密文 “f” 对应 “v” 
3. 出现 “lITH”、“lILL”、“lERE”、“lHEN” 字眼，猜测密文 “l” 对应 “w”

4. 出现 “gETlEEN” 字眼，若 “l” 对应 “w”，则单词明显是 “between”，则密文 “g” 对应 “b” 

预览这些猜想：

![image-20211222153328077](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211222153328077.png)

又可以发现一些规律

- 出现 “FIrHT” 字眼，又有 “mur” (已经可以写成 “INr”) 为高频三字序列，猜测密文 “r” 对应 “g”
- 出现 “FvVORITE” 字眼，猜测为 “favorite”，则密文 “v” 对应 “a”（同时 “v” 作为单字在密文中也相当高频）
- 出现 “ALTHOzGH”、“BzT”、“ABOzT” 字眼，猜测密文 “z” 对应 “u”
- 出现 “ANp”、“pOLLARS”、“AWARpS”、“AppRESS” 字眼，猜测密文 “p” 对应 “d”
- 出现 “HOLLdWOOD”、“ONLd”、“EVERd”、“dEARS”、“Bd” 字眼，猜测密文 “d” 对应 “y“

- 出现 “aONTINUES”、“ADVANaE”、“WHIaH” 字眼，猜测密文 “a” 对应 “c“

- 出现 “Ue”、“HAeeENS”、“eEOeLE” 字眼，猜测密文 “e” 对应 “p”
- 出现 “DREAc”、“CEREcONY”、“ACADEcY” 字眼，猜测密文 “c” 对应 “m”
- 出现 “oUST”、“oUBILANT” 字眼，且 “o” 频次很低，猜测对应 “j”
- 出现 “THANsS”、“BLACs”、“LIsELY” 字眼，猜测密文 “s” 对应 “k”
- “w” 仅出现在 “PRIwE” 中，猜测为频率很低的 “z”
- “j” 出现在 “jUALLY”、“jUESTION” 中，猜测为频率很低的 “q”
- “k” 出现在 “SEkUAL”、“EkPERTS” 中，猜测为频率很低的 “x”

自此，26 个字母的破解全部完成，密钥如下：

![image-20211222155007579](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211222155007579.png)

破解出的原文如下：

```
the oscars turn  on sunday which seems about right after this long strange
awards trip the bagger feels like a nonagenarian too

the awards race was bookended by the demise of harvey weinstein at its outset
and the apparent implosion of his film company at the end and it was shaped by
the emergence of metoo times up blackgown politics armcandy activism and
a national conversation as brief and mad as a fever dream about whether there
ought to be a president winfrey the season didnt just seem extra long it was
extra long because the oscars were moved to the first weekend in march to
avoid conflicting with the closing ceremony of the winter olympics thanks
pyeongchang

one big question surrounding this years academy awards is how or if the
ceremony will address metoo especially after the golden globes which became
a jubilant comingout party for times up the movement spearheaded by 
powerful hollywood women who helped raise millions of dollars to fight sexual
harassment around the country

signaling their support golden globes attendees swathed themselves in black
sported lapel pins and sounded off about sexist power imbalances from the red
carpet and the stage on the air e was called out about pay inequity after
its former anchor catt sadler quit once she learned that she was making far
less than a male cohost and during the ceremony natalie portman took a blunt
and satisfying dig at the allmale roster of nominated directors how could
that be topped

as it turns out at least in terms of the oscars it probably wont be

women involved in times up said that although the globes signified the
initiatives launch they never intended it to be just an awards season
campaign or one that became associated only with redcarpet actions instead
a spokeswoman said the group is working behind closed doors and has since
amassed  million for its legal defense fund which after the globes was
flooded with thousands of donations of  or less from people in some 
countries


no call to wear black gowns went out in advance of the oscars though the
movement will almost certainly be referenced before and during the ceremony 
especially since vocal metoo supporters like ashley judd laura dern and
nicole kidman are scheduled presenters

another feature of this season no one really knows who is going to win best
picture arguably this happens a lot of the time inarguably the nailbiter
narrative only serves the awards hype machine but often the people forecasting
the race socalled oscarologists can make only educated guesses

the way the academy tabulates the big winner doesnt help in every other
category the nominee with the most votes wins but in the best picture
category voters are asked to list their top movies in preferential order if a
movie gets more than  percent of the firstplace votes it wins when no
movie manages that the one with the fewest firstplace votes is eliminated and
its votes are redistributed to the movies that garnered the eliminated ballots
secondplace votes and this continues until a winner emerges

it is all terribly confusing but apparently the consensus favorite comes out
ahead in the end this means that endofseason awards chatter invariably
involves tortured speculation about which film would most likely be voters
second or third favorite and then equally tortured conclusions about which
film might prevail

in  it was a tossup between boyhood and the eventual winner birdman
in  with lots of experts betting on the revenant or the big short the
prize went to spotlight last year nearly all the forecasters declared la
la land the presumptive winner and for two and a half minutes they were
correct before an envelope snafu was revealed and the rightful winner
moonlight was crowned

this year awards watchers are unequally divided between three billboards
outside ebbing missouri the favorite and the shape of water which is
the baggers prediction with a few forecasting a hail mary win for get out

but all of those films have historical oscarvoting patterns against them the
shape of water has  nominations more than any other film and was also
named the years best by the producers and directors guilds yet it was not
nominated for a screen actors guild award for best ensemble and no film has
won best picture without previously landing at least the actors nomination
since braveheart in  this year the best ensemble sag ended up going to
three billboards which is significant because actors make up the academys
largest branch that film while divisive also won the best drama golden globe
and the bafta but its filmmaker martin mcdonagh was not nominated for best
director and apart from argo movies that land best picture without also
earning best director nominations are few and far between
```

