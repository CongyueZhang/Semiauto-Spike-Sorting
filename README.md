一个半自动化的spike sorting软件
@[TOC](目录)
# 必读
请严格遵守【文件命名规则】，若文件中含有高电平Trigger信号，请以`_`下划线加上刺激后缀，并保证文件名中仅有一个`_`。
# 界面
![image](http://github.com/CongyueZhang/Semiauto-Spike-Sorting/blob/master/images/interface.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjY1MjQyMg==,size_16,color_FFFFFF,t_70)

① Data Path文本输入框：在此处输入期望处理的数据的路径
② Load按键：按下后加加载①中路径下的数据
③ Channel n下拉框：按下②后，读取到的数据通道将会显示在下拉框内
④ View Channel n按键：按下后，将③中选中的Channel中的数据显示在⑬中。
	（注：若该通道从未进行处理过，会先进行自动峰电位分类处理）
⑤ Select Cluster按键：按下后，可在⑬中用鼠标拉出红色矩形
⑥ Add new Cluster按键：按下后，会将⑤的红色矩形选中的峰电位添加到新的Cluster中
⑦ Add to Cluster x按键：按下后，会将⑤的红色矩形选中的峰电位添加到⑧中选中的Cluster中
⑧ Cluster x复选框：可单选可多选（按住ctrl后可多选），⑦、⑨和⑩中的一些功能会只对选中的Cluster x进行处理。
⑨ Delete Cluster x按键：按下后，会删除⑧中选中的Cluster
⑩ Function选择框：单选，可以选择期望运行的功能
⑪ Run Function按键：按下后会执行⑩中选择的功能
⑫ 标题：会在此处显示⑬中出现的峰电位的数量
⑬ 图像显示框：峰电位会在此显示

# 数据的读取
## 操作
将数据路径粘贴在`Data Path`文本框中，点击`Load`按键，即可将路径下的原始数据（.abf文件）或往期处理结果（.mat文件）（批量）读取进来。
## 文件命名规则
### .abf文件
目前.abf内记录的内容分为三种情况：
 - gapfree记录
 - 刺激记录
	 - US
	 - ES

对于`刺激记录`，请以`_`分隔符，在原文件名后加上刺激类型后缀。
**注：** 

 - 刺激类型后缀只需要**包含**US或ES即可，例如：US 0，US^180，US node等 都可以。 刺激后缀的内容其后将会显示在某些功能图像上。
 - 除非是加刺激后缀，否则请不要在文件名中出现`_`下划线
 - gapfree文件不需要加后缀（不过即使加了_gapree后缀也不会报错）
![image](http://github.com/CongyueZhang/Semiauto-Spike-Sorting/blob/master/images/name.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjY1MjQyMg==,size_16,color_FFFFFF,t_70)
![刺激后缀显示](http://github.com/CongyueZhang/Semiauto-Spike-Sorting/images/preprocessing.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjY1MjQyMg==,size_16,color_FFFFFF,t_70)
### .mat文件
该软件处理完数据后，会自动在相应路径生成`data.mat`文件，该文件名称与内容请不要更改。
![image](http://github.com/CongyueZhang/Semiauto-Spike-Sorting/blob/master/images/DataFile.png)
# 自动处理过程
点击`Load`按钮读取数据后，`Channel n`下拉框中会出现已有的通道，选中期望处理的通道后，点击`View Channel n`按钮，若该通道的数据从未被处理过，该程序将会对该通道的数据进行自动处理（滤波、峰电位检测、特征提取、聚类）。
![Load数据后的界面](http://github.com/CongyueZhang/Semiauto-Spike-Sorting/blob/master/images/ChannelNDropDown.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjY1MjQyMg==,size_16,color_FFFFFF,t_70)
处理后的结果会被保存下来，若该通道的数据**已被**处理过，则不会进行重复自动处理，会直接显示出以往的处理结果。
# 手动调整过程
## 修改
![自动处理结束后](http://github.com/CongyueZhang/Semiauto-Spike-Sorting/tree/master/images/AfterRunning.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjY1MjQyMg==,size_16,color_FFFFFF,t_70)

 1. 首先，找到期望修改的Cluster。例如：图中蓝色峰电位聚类似乎有问题，则可从右上角标签中读取到该聚类为Cluster 1。
 2. 在`Cluster x多选框`中选中Cluster 1，在`Function单选框`中选中`Show x`，点击`Run Funcition`按键，此时右侧图像中只显示出选中的Cluster 1。
![在这里插入图片描述](http://github.com/CongyueZhang/Semiauto-Spike-Sorting/blob/master/images/ShowX.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjY1MjQyMg==,size_16,color_FFFFFF,t_70)
 3. 点击`Select Cluster`按键后，可用鼠标在右侧图框中画出矩形。调整矩形大小位置，使其只包括期望的峰电位。
 ![](http://github.com/CongyueZhang/Semiauto-Spike-Sorting/blob/master/images/SelectX.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjY1MjQyMg==,size_16,color_FFFFFF,t_70) 
 4. 接下来有两个选择：
 	① 点击`Add new Cluster`按键将选中的峰电位添加到新的聚类
 	②点击`Add to Cluster x`按键将其添加到`Cluster x选择框`中选中的Cluster中（如添加到Unsorted Spikes）
 	
	按下其上任何一个按键后，红色矩形框及其选中的峰电位会在当前图中消失

注：若某一Cluster中所有峰电位都依次被添加到了其他Cluster（即该Cluster中没有了峰电位），则该Cluster会自动被删除。
## 删除
在`Cluster x选择框`中选中期望的删除的Cluster x后，点击`Delete Cluster x`，即可将选中的Cluster x删除，里面的峰电位会被归到`Unsorted Spikes`中。
## 合并
假设期望合并Cluster a与Cluster b
 1. 在`Cluster x选择框`中选中Cluster a
 2. 执行`Show x`功能
 3. 点击`Select Cluster`按键，将该聚类中所有峰电位都选中
 4. 在`Cluster x选择框`中选择Cluster b，然后点击`Add to Cluster  x`按键

之后，Cluster a中所有峰电位会被添加到Cluster b 中，且Cluster a会自动被删除，即实现了合并功能。

# 附加功能
附加功能有：

 - Mark x in data：会在总信号中，将选中的Cluster x中的峰电位，以其Cluster对应的颜色标出
 - Mark all in data：在总信号中，以红色标出所有的峰电位。
 - View(only) x in data：在记录时间中，**只显示**出Cluster x（可多选），而不显示噪声与其他峰电位。
 - x's frequency：显示出Cluster x的放电频率（Cluster x可多选）
 - all's frequency：显示出峰电位的总放电频率
# 存储
处理文件时，该软件会自动在数据路径中新建`Result`文件夹
![在这里插入图片描述](http://github.com/CongyueZhang/Semiauto-Spike-Sorting/blob/master/images/ResultFile.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjY1MjQyMg==,size_16,color_FFFFFF,t_70)
`Result`文件夹中含有`Image`与`Data`文件
![在这里插入图片描述](http://github.com/CongyueZhang/Semiauto-Spike-Sorting/blob/master/images/inResult.png)
## Image文件夹
`Image`文件夹中含有（多个）通道文件夹。处理过程中，生成的各种功能图片会自动保存到对应通道的路径，且覆盖以往同名称的图片。（例如，前后执行过两次观看Cluster 5放电频率的功能图，那么，只有后一次的功能图会被保存下来）
![通道文件夹](http://github.com/CongyueZhang/Semiauto-Spike-Sorting/blob/master/images/ch0File.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjY1MjQyMg==,size_16,color_FFFFFF,t_70)
![功能图片](http://github.com/CongyueZhang/Semiauto-Spike-Sorting/blob/master/images/inCh0File.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjY1MjQyMg==,size_16,color_FFFFFF,t_70)
## Data文件夹
在处理结束，软件关闭的时候，会自动将本次处理后的数据，保存在Data文件夹中。此后可直接Load此data.mat文件进行查看与处理。处理后会以相同的方式在该路径下生成新的Result等文件夹。
![Data文件夹](http://github.com/CongyueZhang/Semiauto-Spike-Sorting/blob/master/images/DataFile.png)