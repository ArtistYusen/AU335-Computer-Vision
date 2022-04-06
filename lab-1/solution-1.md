## 问题2

- 透视投影

<img src="D:\yszheng\Pictures\Typora\问题2-透视投影.jpg" alt="问题2-透视投影" style="zoom: 25%;" />

- 正交投影

<img src="D:\yszheng\Pictures\Typora\问题2-正交投影.jpg" alt="问题2-正交投影" style="zoom:25%;" />

## 问题3

由于X轴与x轴平行，故x轴只有缩放变换（缩放因子为$\alpha$）
$$
x-x_0=\alpha X\Rightarrow x=\alpha X+x_0
$$
对于y轴，如图，考虑线段PQ

<img src="D:\yszheng\Pictures\Typora\image-20220314220957272.png" alt="image-20220314220957272" style="zoom: 25%;" />
$$
\alpha Y=\alpha Z\tan\theta+\frac{y-y_0}{\cos\theta}\Rightarrow y=\alpha(\cos\theta\ Y-\sin\theta\ Z)+y_0
$$

## 问题4

$$
\partial Z/\partial y=-1/\sin\theta{\rm \ （对问题3中证明的第二个方程求偏导可得）}\\
\partial Z/\partial {\rm \bf{t}}=\nabla Z\times{\rm \bf{t}}=-n_y\ \partial Z/\partial x+n_x\ \partial Z/\partial y =0,\ {\rm \bf{t}}=(-n_y,n_x)\\
\partial^2 Z/\partial x^2=0\\
\partial^2 Z/\partial y^2=0\\
\partial^2 Z/\partial x\partial y=0
$$

## 问题5

- 代码补全
  ```matlab
  % 166
  Aij(:,:,c) = [-1 0 1; -2 0 2; -1 0 1]*-dy+[-1 -2 -1; 0 0 0; 1 2 1]*dx;
  % 180
  Aij(:,:,c) = 0.1*[0 -1 0; 0 2 0; 0 -1 0];
  ```

- 运行结果

![问题5-运行结果图片](D:\yszheng\Pictures\Typora\问题5-运行结果图片.png)
