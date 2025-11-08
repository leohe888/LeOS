# 笔记

## 主引导扇区

编译主引导扇区代码的命令：

```shell
nasm -f bin boot.asm -o boot.bin
```

创建硬盘镜像的命令：

```shell
bximage -q -hd=16 -func=create -sectsize=512 -imgmode=flat master.img
```

将编译好的主引导扇区代码写入硬盘镜像的命令：

```shell
dd if=boot.bin of=master.img bs=512 count=1 conv=notrunc
```

- 配置 bochs：
  - Windows 系统：
    - display_library: win32, options="gui_debug"
    - ata0-master: type=disk, path="master.img", mode=flat
  - Ubuntu22.04：
    - display_library: x, options="gui_debug"
    - ata0-master: type=disk, path="master.img", mode=flat

- 启动 bochs 及其图形化调试器的命令：

  - `bochs -debugger`
