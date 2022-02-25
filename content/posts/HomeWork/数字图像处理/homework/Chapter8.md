# 第八章

![image-20211031163705599](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211031163705599.png)

(a) 直方图均衡过后，每个灰度级概率趋于相等，使用变长编码毫无优势。

(b) 直方图均衡后，像素点之间仍然存在空间相关性，所以有空间冗余；同时也允许包含时间冗余。

****

![image-20211031171349148](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211031171349148.png)

(a) $C=\frac{8}{5.3}=1.509$

(b) 不能

(c) 在哈夫曼编码之前消除图像中的空间冗余

****

![image-20211031171950452](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211031171950452.png)

a3a6a6a2a5a2a2a2a4

****

![image-20211031164716841](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211031164716841.png)

1.544 Mbps 的传输率在 6s 内可以传输
$$
(1.544\times 10^6)\times 6=9.264\times 10^6
$$
比特信息，所以可得压缩比为
$$
C=\frac{4096\times 4096\times 12}{9.264\times 10^6}=21.73
$$
JPEG 变换编码可以实现此压缩。

要在 5-6s 内做一次细化，1min 内完成，相当于要做 10-12 次细化。不妨假设做 12 次细化，每次细化针对 12bit 其一，那每个比特的压缩率为
$$
C=\frac{4096\times 4096\times 1}{9.264\times 10^6}=1.81
$$
压缩比必须小于 2。

为了体验每幅图像之间的差异，可以在压缩图像每个像素每个比特位置与原始图像进行异或操作，值为 1 则代表此比特位置与原始值不同。

![image-20211031171056431](https://markdown-1303167219.cos.ap-shanghai.myqcloud.com/image-20211031171056431.png)