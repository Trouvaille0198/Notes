# faker

## 认识

faker 主要用来创建伪数据，使用 faker 包，无需再手动生成或者手写随机数来生成数据，只需要调用 faker 提供的方法，即可完成数据的生成。

## 创建

### 通过工厂函数来创建

```python
from faker import Factory

fake1 = Factory.create() # 通过工厂函数来创建

fake1.name() # 调用方法-随机生成一个姓名
```

### 通过构造函数来创建

```python
from faker import Faker # 主要使用的是Factory类，而导入Faker，会同时导入Factory

fake2 = Faker() # 通过构造函数来创建

fake2.address() # 调用方法-随机生成一个地址
```

### 本地化

```python
fake = Faker(locale='zh_CN')
```

faker 接受的本地化参数 `locale`，创建的对象会生成对应语言的数据，如果没有找到对应的语言，会使用默认的 "en_US"

#### 可选择的文化信息

ar_EG - Arabic (Egypt)

ar_PS - Arabic (Palestine)

ar_SA - Arabic (Saudi Arabia)

bg_BG - Bulgarian

cs_CZ - Czech

de_DE - German

dk_DK - Danish

el_GR - Greek

en_AU - English (Australia)

en_CA - English (Canada)

en_GB - English (Great Britain)

en_US - English (United States)

es_ES - Spanish (Spain)

es_MX - Spanish (Mexico)

et_EE - Estonian

fa_IR - Persian (Iran)

fi_FI - Finnish

fr_FR - French

hi_IN - Hindi

hr_HR - Croatian

hu_HU - Hungarian

it_IT - Italian

ja_JP - Japanese

ko_KR - Korean

lt_LT - Lithuanian

lv_LV - Latvian

ne_NP - Nepali

nl_NL - Dutch (Netherlands)

no_NO - Norwegian

pl_PL - Polish

pt_BR - Portuguese (Brazil)

pt_PT - Portuguese (Portugal)

ru_RU - Russian

sl_SI - Slovene

sv_SE - Swedish

tr_TR - Turkish

uk_UA - Ukrainian

zh_CN - Chinese (China)

zh_TW - Chinese (Taiwan)

#### 本地化特有属性

详见 https://www.cnblogs.com/hellangels333/p/9039784.html

## 属性

更多：https://www.cnblogs.com/pywen/p/14245369.html

```python
from faker import Faker

fake = Faker()
```

### 人名类

```python
fake.name() # 人名
fake.name_male() # 男子名
fake.name_femal() # 女子名

# 'Mallory Walker'
# Melissa Arias

fake.first_name() # 名
fake.last_name() # 姓
```

### 身份信息类

```python
fake.ssn() # 身份证号
# '220112193612070575'
# '391-38-4757'

fake.phone_number() # 手机号码
# '070-1015-0220'

fake.ipv4_private() # ip地址
# '10.112.246.54'

fake.profile() # 个人配置信息

'''{'job': '电脑操作员/打字员', 'company': '网新恒天传媒有限公司', 'ssn': '37132220000210765X', 'residence': '湖北省婷婷市永川马街Y座 292199', 'current_location': (Decimal('40.609137'), Decimal('14.068631')), 'blood_group': 'B-', 'website': ['https://minma.cn/', 'https://www.liu.cn/'], 'username': 'luoli', 'name': '钟帆', 'sex': 'F', 'address': '河北省巢湖市高坪邵街r座 998657', 'mail': 'min70@gmail.com', 'birthdate': datetime.date(1948, 6, 7)}'''

fake.job() # 工作名
# 公認会計士
# 售前/售后技术支持工程师
# Electrical engineer
# Herpetologist
# 电子技术研发工程师

fake.password() # 随机密码
# 5%8TIiwbL3
# SIf7xvOg%0
# trD2!1ZlM)
# ngPHeq1_!3
# @OpYOrqt1B
# I4P^(yaD!c

fake.uuid4() # 随机UUID
# bcc48179-b9e3-4da2-a8e9-95681650e56f
# 47ee89a8-f845-48af-8894-4d6a28cbfdc8
# 1f3b9a27-8870-48bd-9861-5d3fedc7f972
```

### 地区名称类

```python
fake.address() # 街道，好像是假的
# '千葉県新島村二つ室20丁目17番16号 雷門パレス775'
# '38987 Henry Lights Suite 406\nNataliefurt, PA 10973'
# '辽宁省关岭县清河淮安街D座 373511'

fake.company() # 公司名称
# '恒聪百汇科技有限公司'
# 'Cruz-Martin'
# '森運輸合同会社'

fake.city() # 城市，真实
# 'Stewartborough'
# '昭島市'
# 'East Jacob'
# '杭州市'

fake.city_suffix() # 各地城市后缀
# 'chester'
# 'burgh'

fake.country() # 国家，会以所选地区的语言来展示
# リビア国
# Korea
# Jersey
# 瓜德罗普岛

fake.current_country() # fake对象所在地区的国家
# Japan
# United States
# People's Republic of China

fake.country_code() # 国家编码
fake.current_country_code() # 对象所在国家编码
# SV
# NR
# RS
```

### 日期时间类

```python
fake.date(pattern='%Y-%m-%d', end_datetime=None) # 日期
# 1982-02-13
# 1989-10-24
# 2018-01-12
# 2005-04-27
```



## 进阶

### 使用复合对象

```python
from collections import OrderedDict

from faker import Faker

# Generate a name based on the provided weights
# en_US - 16.67% of the time (1 / (1 + 2 + 3))
# en_PH - 33.33% of the time (2 / (1 + 2 + 3))
# ja_JP - 50.00% of the time (3 / (1 + 2 + 3))
locales = OrderedDict(
    [
        ("en-US", 1),
        ("zh_CN", 2),
        ("ja_JP", 3),
    ]
)
fake = Faker(locales)

# usage
fake.phone_number()
fake['en-US'].name()
fake['ja_JP'].zipcode()
```

