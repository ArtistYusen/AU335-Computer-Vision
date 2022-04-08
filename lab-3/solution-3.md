## 问题包-3

### 问题1

> 点$(u,v)$到直线$(a,b,c)$的距离

证明：

线$(a,b,c)$法向量为$(a,b)$，故可设点$(u,v)$做垂线垂足为$(u+at，v+bt)$，其中$t\in \R$。
代入线方程有$a(u+at)+b(v+bt)+c=0$，移项得
$$
t=-\frac{au+bv+c}{a^2+b^2}
$$
又由于$a^2+b^2=1$因此$(u,v)$到$(a,b,c)$的距离为
$$
d=\sqrt{a^2+b^2}\cdot|t|=|au+bv+c|
$$
证毕。

### 问题2

> 以高斯混合模型求解为例简述EM算法的基本原理和流程

1. 初始化均值$\mu_k$，协方差矩阵$\Sigma_k$和第$k$个高斯模型的权重系数$p_k$。从而估计对数似然估计的初始值
   记$\theta=\{p_1,p_2,\cdots,p_N,\mu_1,\mu_2,\cdots,\mu_N,\Sigma_1,\Sigma_2,\cdots,\Sigma_N\}$，
   则初始值为$\theta^0=\{p^0_1,p^0_2,\cdots,p^0_N,\mu^0_1,\mu^0_2,\cdots,\mu^0_N,\Sigma^0_1,\Sigma^0_2,\cdots,\Sigma^0_N\}$
   由于**直接对对数似然函数求导无法获得参数的解析解**，EM算法中采用E-step与M-step进行迭代求解

2. **E-step**（期望步）
   定义$Q$函数
   $$
   Q(\theta,\theta^{(t)})=\int_p\ln \mathcal{P}(X,Z|\theta)\cdot \mathcal{P}(Z|X,\theta^{(t)}){\rm d}Z
   $$
   利用统计学知识，做变换可得
   $$
   Q(\theta,\theta^{(t)})=\Sigma_{z_1,z_2,\cdots,z_N} \ln\Pi_{i=1}^N \mathcal{P}(x_i,z_i|\theta)\cdot \Pi_{i=1}^N \mathcal{P}(z_i|x_i,\theta^{(t)})\\
   =\Sigma_{z_1,z_2,\cdots,z_N} \Sigma_{i=1}^N\ln \mathcal{P}(x_i,z_i|\theta)\cdot \Pi_{i=1}^N \mathcal{P}(z_i|x_i,\theta^{(t)})\\
   =\Sigma_{i=1}^{N}\Sigma_{z_i}\ln p_{i}\mathcal{N}(x_i|\mu_i,\Sigma_{i})\frac{p_{i}\mathcal{N}(x_i|\mu_i,\Sigma_i)}{\Sigma_{k=1}^Kp_k\mathcal{N}(x_i|\mu_k,\Sigma_k)}
   $$
   
3. **M-step**（最大化步）
   令
   $$
   \theta^{(t+1)}=\max_\theta Q(\theta,\theta^{(t)})
   $$
   不妨先求$p^{(t+1)}=(p_1^{(t+1)},p_2^{(t+1)},\cdots,p_K^{(t+1)})$。
   $$
   \begin{cases}
   \max_p \sum_{k=1}^K\sum_{i=1}^N\log p_k\cdot P(z_i=c_k|x_i,\theta^{(t)})\\
   \sum_{k=1}^K p_k=1(归一化条件)
   \end{cases}
   $$
   使用拉格朗日乘子法，
   $$
   L(p,\lambda)=\max_p \sum_{k=1}^K\sum_{i=1}^N\log p_k\cdot P(z_i=c_k|x_i,\theta^{(t)})+\lambda(\sum_{k=1}^K p_k-1)
   $$
   对$L$函数求导并令导数为$0$
   $$
   \frac{\partial L}{\partial p_k}=\sum_{i=1}^N\frac{1}{p_k}\cdot P(z_i=c_i|x_i,\theta^{(t)})+\lambda=0\Rightarrow \lambda=-N
   $$
   因此，
   $$
   p_k^{(t+1)}=\frac{1}{N}\sum_{i=1}^NP(z_i=c_k|x_i,\theta^{(t)})
   $$
   同理可得
   $$
   \mu_k^{(t+1)}=\frac{\sum_{n=1}^N\frac{p_k^i \mathcal{N}(x_i|\mu_k,\Sigma_k)}{\sum_{k=1}^Kp_k^i \mathcal{N}(x_i|\mu_k,\Sigma_k)}x_n}{\sum_{i=1}^NP(z_i=c_k|x_i,\theta^{(t)})}\\
   \Sigma_k^{(t+1)}=\frac{\sum_{n=1}^N\frac{p_k^i \mathcal{N}(x_i|\mu_k,\Sigma_k)}{\sum_{k=1}^Kp_k^i \mathcal{N}(x_i|\mu_k,\Sigma_k)}(x_n-\mu_k^i)^2}{\sum_{i=1}^NP(z_i=c_k|x_i,\theta^{(t)})}\\
   $$
   然后不断迭代，直至获得满意的GMM参数（即$\theta$的估计）
   
4. 评估对数似然并检查收敛性

### 问题3

> 用伪代码写出Mean-shift的算法流程（以图像分割为例），并分析影响算法性能的主要因素

伪代码：
Input：输入图像（RGB像素点）
Output：输出图像（经过图像分割后的RGB像素点）	

1. 确定初始点，进行聚类
1. 选择合适的核函数
1. 计算每个样本的均值漂移向量
1. 对每个样本点以均值漂移向量进行平移
1. 重复3..4，直至样本点收敛
1. 收敛到同一点的样本认为属于同一类聚簇，并做标记（如上色）
1. 从未被分类的点中随机选取初始点，重复1..6

![image-20220406222803871](D:\yszheng\Pictures\Typora\image-20220406222803871.png)

影响算法性能的主要因素：

- **特征提取算法**

- **核函数的选择**

- **window size的选择**

  若窗口过小，则收敛点过多，可能造成过分割，且收敛过程缓慢

  若窗口过大，图像分割不精确，可能会丢失部分聚簇
  
- **类别合并的阈值**

### 问题4

> 找一张包含线条的图像，用霍夫变换进行线检测，并统计线条的数目。尝试不同的参数设置，并给出结果比较

查找到如下图像

![p4-img](D:\yszheng\Pictures\Typora\p4-img-16493034329208.png)

使用如下代码进行Hough变换，进行线检测，并统计线条的数目

```matlab
clf;
tiledlayout(2,2)
RGB = imread('gantrycrane.png');
I = im2gray(RGB);
BW = edge(I,'canny');
[H,T,R] = hough(BW,'RhoResolution',2,'Theta',-90:0.5:89);

nexttile
imshow(RGB);
title('原始图像');

nexttile
imshow(imadjust(rescale(H)),'XData',T,'YData',R,...
      'InitialMagnification','fit');
title('Hough变换图像');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal;
colormap(gca,hot);

nexttile
imshow(imadjust(rescale(H)),'XData',T,'YData',R,...
      'InitialMagnification','fit');
title('ρ-θ空间交点');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal;
colormap(gca,hot);
hold on
P  = houghpeaks(H,20,'threshold',ceil(.5*max(H(:))));
x = T(P(:,2)); y = R(P(:,1));
plot(x,y,'s','color','white');
hold off

nexttile
lines = houghlines(BW,T,R,P,'FillGap',5,'MinLength',7);
imshow(RGB), hold on
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','magenta');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   len = norm(lines(k).point1 - lines(k).point2);
   if (len > max_len)
      max_len = len;
      xy_long = xy;
   end
end
plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','blue');
title('原图标注')

sprintf(['线条数为' num2str(length(lines))])
```

结果如图（其中最长的线使用蓝色标出，统计得线条数为88）

![solution4-img-1](D:\yszheng\Pictures\Typora\solution4-img-1.png)

尝试使用不同的参数，部分结果如下

![solution4-img-2](D:\yszheng\Pictures\Typora\solution4-img-2-16493815353921.png)

由此可见，使用不同的参数会使得线条数目检测结果不同。其中，

- $\rho$步长$rhoresolution$对检测线条数的影响较复杂，与具体图像有关。一般而言，增大$rhoresolution$，直线先稀疏后稠密。
- $\theta$范围越大，直线越稠密。
- $\theta$步长越大，每次检索的角度跨度越大，直线越稀疏。
- 线条交点数目置信阈值$threshold$的影响较显著，$threshold$越大，检测到的线条数越少。
- $houghpeaks$中的$numpeaks$越大，选取的峰值数目越大，直线越稠密。
- $houghline$中的$fillgap$越大，合并直线阈值越大，直线越稠密。
- $houghline$中的$minlength$越大，被识别为直线的最小长度越大，直线越稀疏。

### 问题5

> 用线拟合的方式，对下图中的各文字行，插入删除线

<img src="D:\yszheng\Pictures\Typora\img.png" alt="img" style="zoom:33%;" />

以下使用两种思路对文本插入删除线。

**第一种思路**为先对图像进行形态学膨胀和腐蚀操作，再进行hough变化进行线检测。由于部分行高度较大，会被检测多次，最后需对检测得到的线段做合并处理，结果如下

<img src="D:\yszheng\Pictures\Typora\solution5-img-1-16493359570681.png" alt="solution5-img-1" style="zoom: 67%;" />

**第二种思路**为计算每行及其对应列的像素点分布，从而判断出存在文字的矩形框范围，进而对各文字行插入删除线，结果如下

![solution5-img](D:\yszheng\Pictures\Typora\solution5-img-16487718609291.png)

代码如下

```matlab
im = imread('p5-img.png');
imGray = im2gray(im);
imBlur = imgaussfilt(imGray,8);   
Threshold = graythresh(imBlur);
imBW = imbinarize(imBlur,Threshold);
imBW = ~imBW;
imshow(imBW)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 方法一 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 膨胀操作
se = strel('rectangle',[10,100]);
im_dilate = imdilate(imBW,se);
imshow(im_dilate)
% 腐蚀操作
se = strel('line',1,0);
im_erode = imerode(im_dilate,se);
imshow(im_erode)

% hough变换
[H,T,R] = hough(im_erode,'RhoResolution',1,'Theta',-90);
P  = houghpeaks(H,20,'threshold',ceil(.1*max(H(:))));
lines = houghlines(im_erode,T,R,P,'FillGap',2,'MinLength',300);

% 检索合并
lines(3).point1(2) = (lines(3).point1(2)+lines(4).point1(2))/2;
lines(3).point2(2) = lines(3).point1(2);
lines(4) = [];

figure,imshow(im),hold on
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','magenta');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
end
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 方法二 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
whiteCountPerRow = sum(imBW,2);
regions = whiteCountPerRow > 100;
startIdx = find(diff(regions)==1);
endIdx = find(diff(regions)==-1);
Ydel = (startIdx+endIdx)/2;

st = zeros(length(Ydel),1);
ed = zeros(length(Ydel),1);
for i=1:length(Ydel)
    whiteCountPerCol = sum(imBW(startIdx(i):endIdx(i),:),1);
    regions = whiteCountPerCol > 5;
    stIdx = find(diff(regions)==1);
    edIdx = find(diff(regions)==-1);
    st(i) = stIdx(1);
    ed(i) = edIdx(end);
end

imshow(im)
hold on
for i=1:length(Ydel)
    plot(st(i):ed(i),Ydel(i)*ones(size(st(i):ed(i))),'red',"LineWidth",3)
end
```

