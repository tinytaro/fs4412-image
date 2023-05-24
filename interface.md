# 编译工具链

由于开发板上运行的是完整的debian操作系统，因此可以直接在开发板上使用本地编译工具链：

```bash
$ gcc hello.c -o hello
$ ./hello
hello, world
```

也可以在虚拟机的Ubuntu中安装交叉编译工具链：

```bash
$ sudo apt install gcc-arm-linux-gnueabihf
```

在Ubuntu中交叉编译：

```bash
$ arm-linux-gnueabihf-gcc hello.c -o hello
```

然后将编译好的程序上传到开发板或者复制到SD卡的FAT分区中，再运行。

# 读取温度传感器信息

可以通过sysfs文件系统读取底板上的DS18B20温度传感器信息

```bash
$ cat /sys/bus/w1/devices/28-*/temperature
28812
```

文件路径中的`*`号用来匹配传感器芯片ID，每个开发板不同。

读取出来的数字除以1000即为当前温度，单位是摄氏度。

# 读取电位器电压

可以通过sysfs文件系统读取底板上的电位器电压（ADC通道3）

```bash
$ cat /sys/bus/iio/devices/iio\:device0/in_voltage3_raw
1574
```

电压测量范围0~3.3V，精度12位，数值范围0-4095。

$V = \frac{V_{raw}}{4095}\times3300 mV $

# 控制和读取LED灯状态

LED2是心跳指示灯，CPU工作期间会定时闪烁。

LED3 - LED5可以通过程序控制，可以通过sysfs控制和读取LED灯状态。

```bash
# 打开LED3
$ echo 1 > /sys/class/leds/led3/brightness

# 关闭LED3
$ echo 0 > /sys/class/leds/led3/brightness

# 读取LED状态
$ cat /sys/class/leds/led3/brightness
1
```

# 读取按键状态

底板上有3个用户按键，power按键用于关机，音量+-按键的状态可以通过程序读取。

示例代码：

```C
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <linux/input.h>
#include <linux/input-event-codes.h>
#include <stdio.h>

int main()
{
    //打开按键设备
    int fd = open("/dev/input/event1", O_RDONLY);
    if (fd < 0)
    {
        perror("open");
        return 1;
    }

    while(1)
    {
        //阻塞读取按键事件
        struct input_event ev;
        read(fd, &ev, sizeof(ev));
        //只处理按键事件
        if (ev.type == EV_KEY)
        {
            //判断按键编码（不同按键编码不同）
            if (ev.code == KEY_UP)
            {
                //判断按键状态
                if (ev.value == 1)
                {
                    //按键按下
                    printf("key up pressed\n");
                }

                if (ev.value == 0)
                {
                    //按键抬起
                    printf("key up released\n");
                }
            }
        }
    }

    close(fd);
}
```

如果不想阻塞读取按键状态，可以使用`select`等多路复用方式监控设备文件。

# 获取陀螺仪和加速度计数据

可以通过sysfs读取底板上的MPU6050传感器信息：

```bash
# 获取XYZ方向加速度
$ cat /sys/bus/i2c/devices/5-0068/iio\:device1/in_accel_x_raw
498
$ cat /sys/bus/i2c/devices/5-0068/iio\:device1/in_accel_y_raw
-100
$ cat /sys/bus/i2c/devices/5-0068/iio\:device1/in_accel_z_raw
16932

# 获取XYZ方向角速度
$ cat /sys/bus/i2c/devices/5-0068/iio\:device1/in_anglvel_x_raw
-38
$ cat /sys/bus/i2c/devices/5-0068/iio\:device1/in_anglvel_y_raw
6
$ cat /sys/bus/i2c/devices/5-0068/iio\:device1/in_anglvel_z_raw
1
```

# 控制蜂鸣器

可以通过以下程序控制底板上的无源蜂鸣器：

```C
#include <stdint.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <linux/input.h>
#include <unistd.h>

//参数hz是蜂鸣器声音频率，设置为0停止蜂鸣器
void tone(int hz)
{
    int fd = open("/dev/input/event0", O_WRONLY);
    if (fd < 0)
    {
        perror("open");
        return;
    }
    struct input_event ev;
    ev.type = EV_SND;
    ev.code = SND_TONE;
    ev.value = hz;
    write(fd, &ev, sizeof(ev));
    close(fd);
}

int main()
{
        while(1)
        {
                tone(500);
                sleep(1);
                tone(0);
                sleep(1);
        }
        return 0;
}
```

