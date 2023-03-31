# FS4412开发板Debian系统镜像

#### 镜像介绍
使用debootstrap工具将Debian 11移植到FS4412开发板，主要用于项目实战授课和实训项目，支持二次定制。

#### 版本说明

* debian11-fs4412-X-base.img.xz：基础镜像，只包含最基础的软件包，用于二次开发定制，不建议直接使用。
* debian11-fs4412-X-dev.img.xz：开发环境镜像，在基础镜像中增加了C/C++本地编译工具链和常用开发工具。
* debian11-fs4412-2.1-opencv.img.xz：opencv相关项目镜像，在开发环境镜像中增加了opencv的相关函数库。

#### 下载地址
百度网盘：https://pan.baidu.com/s/1DIvD2-4iiR-w8IeIGD8SvA?pwd=gbi1 
提取码：gbi1

#### 镜像烧写

1. 准备一张容量4G以上的SD或Micro SD卡。
2. 下载烧写工具：[Etcher](https://www.balena.io/etcher)
3. 将SD卡插入读卡器，连接到开发电脑。
4. 使用烧写工具将下载的镜像文件烧写到SD卡中。
5. 将SD卡插入FS4412的卡槽中，并将开发板上的OM拨码开关设置为从SD卡启动。
6. 打开开发板电源，从调试串口可以看到系统启动信息。

#### Debian系统使用说明

1.  操作系统启动后，可以在串口2上使用`root`用户登录，登录密码为`hqyj`
2.  连接网线后，系统启动时会自动获取IP地址，可以使用`ip address`命令查看开发板IP地址。
3.  系统镜像中集成了SSH服务，可以使用SSH客户端远程登录，用户名和密码与串口登录相同。

#### 镜像定制

TODO
