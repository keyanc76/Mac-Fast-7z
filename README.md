# 📦 mac-fast-7z

> **A minimalist, high-performance macOS Quick Action for 7z compression.**
> 
> 专为 macOS 设计的极简、极速 7z 自动化压缩工具。解决原生压缩慢、格式不通用及 `Resource deadlock` 报错等痛点。

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![macOS Support](https://img.shields.io/badge/macOS-11.0+-blue.svg)](https://www.apple.com/macos/)

---

### 准备工作 (Prerequisites)

本项目依赖官方 `7zz` 命令行工具，建议通过 Homebrew 安装：

```bash
brew install sevenzip

---

### 安装步骤 (Installation)
打开 macOS 自带的 Automator (自动操作)。

新建 “快速操作” (Quick Action)。

在顶部配置：

工作流程收到当前：文件或文件夹

位于：Finder

添加 “运行 Shell 脚本” (Run Shell Script) 操作：

Shell: /bin/zsh

传递输入: 作为自变量 (as arguments)

将本项目 scripts/compress_7z.zsh 中的代码粘贴进去。

Cmd + S 保存并命名为 “Compress as 7z”

---

### 脚本 (Script)
# 示例代码片段，完整代码请见 scripts 目录
"$ZIP_PATH" a "$output_name" -- "$filename" \
    -r -mx=7 -ssw \
    '-xr!*.DS_Store' '-xr!__MACOSX'

---

