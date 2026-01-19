Markdown

# 📦 mac-fast-7z

> **A High-Performance macOS Quick Action for 7-Zip Compression.**
>
> 专为 macOS 深度优化的极速 7z 自动化压缩工具。解决原生压缩性能瓶颈、跨平台格式兼容及文件占用（Resource Deadlock）报错。

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Platform: macOS](https://img.shields.io/badge/Platform-macOS%2011.0+-lightgrey.svg)](https://www.apple.com/macos/)
[![Engine: 7-Zip](https://img.shields.io/badge/Engine-7--Zip%20(7zz)-orange.svg)](https://www.7-zip.org/)

---

## 🛠️ 环境准备 (Prerequisites)

本项目依赖官方 `7zz` 命令行工具。请确保已安装 [Homebrew](https://brew.sh/)：

```bash
# 安装 7-Zip 官方工具
brew install sevenzip
🚀 安装与配置 (Installation)
启动 Automator：打开 macOS 自带的 Automator (自动操作)。

创建动作：选择 “快速操作” (Quick Action)。

参数设置：

工作流程收到当前：文件或文件夹

位于：Finder

添加脚本：搜索并拖入 “运行 Shell 脚本” (Run Shell Script)：

Shell: /bin/zsh

传递输入: 作为自变量 (as arguments)

粘贴代码：将下方 scripts/compress_7z.zsh 中的完整代码粘贴进去并保存为 极速压缩为 7z。

💻 核心脚本 (The Script)
该脚本经过多次迭代，集成了环境适配、死锁防护和通知反馈逻辑：

Bash

#!/bin/zsh
# =================================================================
# Name: mac-fast-7z
# Purpose: High-performance 7z compression for macOS
# =================================================================

# 1. 语言环境配置（防止中文乱码）
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# 2. 自动路径定位
ZIP_PATH=$(which 7zz) || ZIP_PATH="/opt/homebrew/bin/7zz"

success_count=0
total_count=$#

for f in "$@"; do
    [ ! -e "$f" ] && continue

    dir=$(dirname "$f")
    filename=$(basename "$f")
    output_name="${filename%.*}.7z"
    
    cd "$dir"

    # 执行核心压缩逻辑
    # -ssw: 压缩正在共享写入的文件（解决死锁报错）
    # --: 确保文件名不被误析为参数
    "$ZIP_PATH" a "$output_name" -- "$filename" \
        -r -mx=7 -ssw \
        '-xr!*.DS_Store' '-xr!__MACOSX'

    [ $? -eq 0 ] && ((success_count++))
done

# 3. 结果反馈
if [ $success_count -eq $total_count ]; then
    osascript -e "display notification \"已成功完成 $success_count 个文件的压缩\" with title \"📦 7-Zip 压缩完成\" sound name \"Glass\""
else
    osascript -e "display notification \"部分压缩任务未成功\" with title \"⚠️ 压缩异常\" sound name \"Basso\""
fi
📝 开发哲学 (Philosophy)
本项目遵循 Bauhaus (包豪斯) 的设计法则：“形式追随功能”。

在金融分析（CFA）与量化研究的日常工作中，文件处理的可靠性与速度至关重要。本项目旨在通过最小的交互成本（右键点击），实现最科学的数据归档与传输：

科学：严谨的 errno=11 冲突处理。

简约：无缝集成于 Finder 系统菜单。

高效：多线程并行，拒绝任何冗余等待。

⚖️ 许可声明 (License)
本项目采用 MIT License 协议开源。


---

