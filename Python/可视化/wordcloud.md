# 概述

wordcloud 是优秀的词云展示第三方库，以词语为基本单位，通过图形可视化的方式，更加直观和艺术的展示文本

示例

```python
from matplotlib import pyplot as plt
from wordcloud import WordCloud
 
string = 'Importance of relative word frequencies for font-size. With relative_scaling=0, only word-ranks are considered. With relative_scaling=1, a word that is twice as frequent will have twice the size. If you want to consider the word frequencies and not only their rank, relative_scaling around .5 often looks good.'
font = r'C:\Windows\Fonts\FZSTK.TTF'
wc = WordCloud(font_path=font, #如果是中文必须要添加这个，否则会显示成框框
               background_color='white',
               width=1000,
               height=800,
               ).generate(string)
wc.to_file('ss.png') #保存图片
plt.imshow(wc)  #用plt显示图片
plt.axis('off') #不显示坐标轴
plt.show() #显示图片
```

![image-20210130210417201](http://lvshuhuai.cn/image-20210130210417201.png)

```python
filename = r'D:\Repo\Jupyter\Crawler\Result\心灵奇旅短评.txt'
with open(filename,encoding='UTF-8') as file_project:
    text = file_project.read()
cut = jieba.cut(text)   #text为你需要分词的字符串/句子
chinese = ' '.join(cut)  #将分开的词用空格连接

font = r'C:\Windows\Fonts\msyhbd.ttc'
img = Image.open(r'D:\Repo\Jupyter\Data\22.png') #打开图片
img_array = np.array(img) #将图片装换为数组
wc = WordCloud(
    font_path=font,
    background_color='white',
    width=10000,
    height=8000,
    mask=img_array,
)
wc.generate_from_text(chinese)#绘制图片
plt.imshow(wc)
plt.axis('off')
plt.figure()
plt.show()  #显示图片
wc.to_file(r'new.png')  #保存图片
```

<img src="http://lvshuhuai.cn/image-20210130212211268.png" alt="image-20210130212211268" style="zoom:67%;" />

# 对象

## WordCloud

```python
from wordcloud import WordCloud
```

***WordCloud()***

- 词云对象，Word cloud object for generating and drawing

### 参数

- *font_path*：字体路径，string，Font path to the font that will be used (OTF or TTF). 

- *width*：int (default=400)，Width of the canvas
- *height*：int (default=200)，Height of the canvas.
- *background_color*：color value (default=”black”)，Background color for the word cloud image.
- *mask*：nd-array or None (default=None)，传入转换为数组后的图片作为底片，必须白底

### 方法

*.generate(text)*：向 WordCloud 对象中加载文本 txt，Generate wordcloud from text.

*.to_file(filename)*：将词云输出为图像文件，.png 或 .jpg 格式，Export to image file.

*.to_array()*：将词云转换成 numpy array 对象，Convert to numpy array.