# pygtrans

官方文档：https://pygtrans.readthedocs.io/zh_CN/latest/index.html

## 快速开始

```python
from pygtrans import Translate


class Translator:
    def __init__(self):
        self.translator = Translate()

    def translate(self, text: str, target_lang: str = 'zh-CN')->str:
        return self.translator.translate(text, target=target_lang).translatedText

    def detect(self, text: str):
        return self.translator.detect(text)

```

