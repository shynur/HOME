# SEER Robotics Coding Standards

> Author: 谢骐 \<<shynur@outlook.com>\>  <br />
> Maintainer: 谢骐  <br />
> [Raw file](https://raw.githubusercontent.com/shynur/HOME/refs/heads/trunk/Documents/seer-coding-standards.md).

## 仓库管理
### 配置文件

编辑器配置文件（如 `.dir-locals.el`, `.vscode/settings.json`, `.editorconfig`），
代码格式化配置（如 `.clang-format`），和 `.gitignore` 等应纳入版本控制，保持开发环境一致。

以下是模板文件：

<details>
  <summary>
    <code>.dir-locals.el</code>
  </summary>

```lisp
((auto-mode-alist . (("/.git/COMMIT_EDITMSG\\'" . diff-mode)))
 (nil . ((mode . electric-quote-local)
         (make-backup-files . nil)

         (delete-trailing-whitespace . t)
         (eval . (when (derived-mode-p 'text-mode 'prog-mode 'conf-mode)
                   (add-hook 'before-save-hook
                             #'delete-trailing-whitespace
                             nil "local")))

         (require-final-newline . t)

         (eval . (line-number-mode -1))
         (mode . display-line-numbers)

         (mode . column-number)

         (indent-tabs-mode . nil)
         (tab-width . 4)

         (sentence-end-double-space . t)

         (eval . (electric-indent-local-mode -1))

         (treesit-font-lock-level . 4)

         (whitespace-style . (face tabs))
         (mode . whitespace)))
 (makefile-mode . ((indent-tabs-mode . t)))
 (c++-ts-mode . ((mode . electric-pair-local))))
```
</details>

<details>
  <summary>
    <code>.vscode/settings.json</code>
  </summary>

```json
{
    "editor.tabSize": 4,
    "editor.detectIndentation": false,
    "files.encoding": "utf8",
    "files.eol": "\n",
    "files.candidateGuessEncodings": [
        "utf8"
    ],
    "editor.formatOnSave": true,
    "files.associations": {
        ".clang-format": "yaml"
    }
}
```
</details>

<details>
  <summary>
    <code>.gitignore</code>
  </summary>

```gitignore
*~
\#*#
.#*
```
</details>

<br />

可以根据需要适当修改。

### Git 使用
#### Message 格式 [^2]

Git Message 的第一行概括修改的目的或解决的问题，例如

```bash
git commit -m '添加新的测试用例'
```

如果修改不多，可以到此为止。
但大部分情况下，你应该用 `git commit` 编辑长消息：
在第一行概要行写完之后，空一行，然后分点描述具体做了什么，每点以 `*` 打头。[^2]
例如，

```markdown
重构 Cyber RT transport 模块.

* 将 CyberRT 原本的共享内存从 System V API 切换到 POSIX API.

* 删除 Segment::Inited 检查, 因为新代码中实例一旦构造就必须是 inited.
  此更改涉及 transport/transmitter/shm_transmitter.cpp 中的代码.
```

如果是微不足道的改动，message 应该是以 `;` 打头的简短一行，例如 `git commit -m '; 格式化代码'`。

## 代码维护

### 目录管理

> 请为后来的维护者着想。

**每个目录下必须包含一份 README 说明文件！**
解释为什么要特地单独创建一个目录。
目录的结构是什么？简单说明所包含的文件有哪些用途。
可选地，指明与其它目录的依赖与被依赖关系。
例如 `rbk-v4/examples/Async/ReadMe.txt`：

```
RBK 异步库示例。

"core/asyncxx" 目录下每份 HPP 文件都包含一个异步组件类，及其测试类。
例如 "core/asyncxx/AsyncManualResetEvent.hpp" 包含类 AsyncManualResetEvent
和 TestAsyncManualResetEvent，后者的 test 方法就是测试入口，演示了如何机械式地
使用该组件。

"examples/Async" 目录下每份 CPP 文件都是对 测试类 的 test 方法的简单调用。
编译后的二进制的文件名和 测试类 同名。
```

### 文件管理
#### 编者信息

每新建一份文件，应在文件头部指明 author/maintainer。[^1]

如果文件是改编自开源项目，应保留原作者的 copyright 标语。
建议在 copyright 作者栏加上你自己的名字和相应年份。[^5]

#### 保存格式

**一律使用 UTF-8！**
MS-Windows 用户要特别注意不能使用 ‘UTF-8 with BOM’。

**所有换行符均为 UNIX 风格！**

保存时，要删除文件首尾多余的空行（除了最后一行，在此规定每份文件必须以换行符结束），以及每一行末尾的留白。[^4]

#### 命名约定

- shell 脚本：在 Linux 中执行的脚本，**必须** 以 `.bash` 作为扩展名。[^3]
- C++ 头文件：如果实现和声明放在一起，以 `.hpp` 作为扩展名。

### 许可证

使用第三方库的源码时，必须在库目录下包含第三方库的 LICENSE 文件。[^5]
（Git Submodule 则不需要。）

### 文档注释 [^6]

所有意在给他人使用的 API 必须有文档级别的注释；
反过来，只要有文档级别的注释，就认为该 API 是稳定可使用的。

因此，跟内部实现细节有关的函数或变量等实体，**绝不允许附带文档级注释！**
只给它们编写常规注释即可。

## Per-Language Standards
### C++
#### 代码风格

以下几点是 **硬性要求**：

- 左花括号不准换行

  ```cpp
  int f() {
      // 好
  }
  int g()
  {
      // 坏
  }
  ```

- 禁止谭浩强式写法

  ```cpp
  good_style(
    1, 2
    "aaaaaaaa",
    "bbbbbbbb"
  );
  bad_style(1, 2
      "aaaaaaaa",
      "bbbbbbbb");
  ```

- class 的 private 变量不允许以下划线结尾

  ```cpp
  class 好 {
      int x;
    public:
      auto get_x() const { return this->x; }
      void set_x(const int x) { this->x = x; }
  };
  class 坏 {
      int x_;
    public:
      auto get_x() const { return x_; }
      void set_x(const int x) { x_ = x; }
  };
  ```

  务必像 Python 一样，用 `this->` 显式指明成员变量。

以下是建议：

- 类名使用大驼峰，函数/方法名使用全小写+下划线，变量名使用小驼峰。好处是一眼就能看出是类型名还是函数还是变量。

#### include 指令

ISO C++ 建议使用类似 `#include <cstring>` 而非 `#include <string.h>` 的写法导入 C 标准库，我们严格遵循这一标准。

_______________________________________________________________________________

> 如果不遵循以下规范，则在分析或重构代码时会非常麻烦。

单个文件中直接用到的 class/function/variable 等实体，**必须保证声明该实体的头文件被当前文件 include 了！**
**绝不允许仅仅因为某 class 被当前文件所 include 的另一个头文件 include（即间接包含），就不在当前文件 include！**
例如，

```cpp
/********* 好 *********/         /********* 坏 *********/
// a.hpp                         // a.hpp
#pragma once                     struct A {};
struct A {};

// b.hpp                         // b.hpp
#include "a.hpp"                 #include "a.hpp"
struct B { A a; };               struct B { A a; };

// main.cpp
#include "a.hpp"                 // main.cpp
#include "b.hpp"                 #include "b.hpp"
int main() { A{}; B{}; }         int main() { A{}; B{}; }
```

**请确保几乎每份头文件都含有 `#pragma once` 指令**。

另外注意，`#include "xxx"` 指令之后，应该用注释说明你用到了该文件提供的哪些符号，例如

```cpp
#include "core/transport/ipc/ipc0cp.hpp"  // IPCReader, PoolAllocatorSync
```

如果只用到了一个名字，且与文件名同名，则可以省略，例如 `#include "core/asyncxx/AsyncManualResetEvent.hpp"` 只提供单独一个 class `AsyncManualResetEvent`。

修改文件时，记得同步更新这些注释。

#### 优化提示

C++ 擅长 AOT 优化，在编译/链接时实施尽可能多的代码分析，若有可能应当把计算提前到编译期。
除非特别在乎构建时间（对于几十万行的项目，根本不会多花多少时间），否则应当牺牲编译时间换取运行时性能。

LTO 是 C++ 优化的重要主题（特别是在 object 文件很多时效果更加明显），但往往会占用极大的内存空间，且链接极慢。
*我们可以通过把实现和声明放在同一份 HPP 文件中，达到和 LTO 相近的效果。*

对于 template，这是天然成立的。
对于，例如 普通的类/函数，可以用如下方法解决 ODR 冲突：

```cpp
struct [[gnu::weak]] SomeStruct { /* 具体定义 */ };
void some_func [[gnu::weak]] () { /* 具体定义 */ };
```

`[[gnu::weak]]` 是被 GCC 和 Clang 所支持的属性，属于事实标准。

这种做法的另一个好处是：翻阅代码时减少跳转，可以在同一份文件中查看，这能节约很多时间，保证思路不会被打断。

#### 如何导出对外 API

单独设置一个命名空间。
对于 RBK-v4，或许是 `rbk::api::v4`。

注意，API 分两种：
- 对内 API：意在供仓库内部使用；
- 对外 API：意在供其它项目使用。

#### 注释

**每份文件开头必须包含一段话，讲述该文件的用途。**
例如，

```c
/*
 *  MQ Deadline i/o scheduler - adaptation of the legacy deadline scheduler,
 *  for the blk-mq scheduling framework
 *
 *  Copyright (C) 2016 Jens Axboe <axboe@kernel.dk>
 */
```

**所有 API 必须附带 Doxygen 风格的注释。**
class 不光 public 方法和 public 变量要有 Doxygen 注释，class 本身也需要有。

_______________________________________________________________________________

[^1]: 特别是对开源软件进行修改时，这可以有效区分原作者和修改者、旧文件和新增文件，防止误删。

[^2]: 该规则摘自 GNU Coding Standards。因为可以使用他们现成的工具轻松筛选 Git Message，或生成 ChangeLog 文件。

[^3]: 注意区分 sh 和 Bash。现有脚本的语法完全超出了 POSIX 标准，如果用 sh 很可能无法运行。另见 [POSIX, sh, 与 Bash](https://www.zhihu.com/question/448169628/answer/3616072804)，Bash 已成为事实标准。

[^4]: 空白的增删会干扰 git log。

[^5]: 特别是有可能在未来进行开源的项目。

[^6]: 指那些可以用文档生成工具（如 Doxygen）自动生成文档的注释。

<!-- Local Variables: -->
<!-- eval: (electric-quote-local-mode -1) -->
<!-- End: -->
