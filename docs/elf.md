# ELF

ELF - Executable and Linkable Format - 可执行与可链接格式

- 主要类型：
  - Relocatable file - 可重定位文件
  - Executable file - 可执行文件
  - Shared object file - 共享目标文件
  - Core dump file - 核心转储文件

- 组成部分：

    ```text
    +-----------------------------+
    | ELF Header                 | ← 文件头（说明类型、入口点等）
    +-----------------------------+
    | Program Header Table        | ← 运行时段信息（加载器用）
    +-----------------------------+
    | Section 1 (.text)           | ← 代码段
    +-----------------------------+
    | Section 2 (.data)           | ← 数据段
    +-----------------------------+
    | Section 3 (.bss)            | ← 未初始化全局变量
    +-----------------------------+
    | Section 4 (.symtab, .strtab)| ← 符号表、字符串表
    +-----------------------------+
    | Section Header Table        | ← 节表（记录每节的位置）
    +-----------------------------+
    ```
