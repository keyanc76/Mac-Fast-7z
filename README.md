

# 📦 mac-fast-7z

**High-performance macOS Quick Action for 7-Zip Compression.** 专为 macOS 深度优化的极速 7z 自动化压缩工具，旨在解决原生 ZIP 效率低下与文件占用报错。

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Platform: macOS](https://img.shields.io/badge/Platform-macOS%2011.0+-lightgrey.svg)](https://www.apple.com/macos/)
[![Engine: 7-Zip](https://img.shields.io/badge/Engine-7--Zip%20(7zz)-orange.svg)](https://www.7-zip.org/)
---

## 📥 环境准备 (Prerequisites)

本项目核心依赖为官方 `7zz` 命令行工具。

| 依赖项 | 安装命令 | 推荐来源 |
| --- | --- | --- |
| **Homebrew** | `/bin/bash -c "$(curl -fsSL ...)"` | [brew.sh](https://brew.sh) |
| **7-Zip (7zz)** | `brew install sevenzip` | Homebrew 官方库 |

---

## 🚀 部署指南 (Installation)

### 1. 创建动作

打开 **Automator (自动操作)**，新建 **“快速操作” (Quick Action)**。

### 2. 配置流

在顶部设置：

* 工作流程收到当前：**文件或文件夹**
* 位于：**Finder**

### 3. 配置脚本

添加 **“运行 Shell 脚本” (Run Shell Script)**：

* **Shell**: `/bin/zsh`
* **传递输入**: **作为自变量 (as arguments)**

---

## 💻 核心脚本 (The Script)

请将下方代码完整粘贴至 Automator 的脚本框内：

```zsh
#!/bin/zsh

# 1. 设置环境变量，确保中文路径不乱码
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# 2. 动态定位 7zz 工具路径
ZIP_PATH=$(which 7zz) || ZIP_PATH="/opt/homebrew/bin/7zz"

success_count=0
total_count=$#

for f in "$@"; do
    # 跳过不存在的文件
    [ ! -e "$f" ] && continue

    dir=$(dirname "$f")
    filename=$(basename "$f")
    output_name="${filename%.*}.7z"
    
    cd "$dir"

    # 执行核心压缩指令
    # -ssw: 解决 Resource deadlock avoided 报错
    # --: 确保文件名特殊字符不被误读为参数
    "$ZIP_PATH" a "$output_name" -- "$filename" \
        -r -mx=7 -ssw \
        '-xr!*.DS_Store' '-xr!__MACOSX'

    # 检查状态码
    [ $? -eq 0 ] && ((success_count++))
done

# 3. 结果通知反馈
if [ $success_count -eq $total_count ]; then
    osascript -e "display notification \"已完成 $success_count 个文件的压缩\" with title \"📦 7-Zip 压缩完成\" sound name \"Glass\""
else
    osascript -e "display notification \"部分任务失败 ($success_count/$total_count)\" with title \"⚠️ 压缩异常\" sound name \"Basso\""
fi

```

---

## ⚖️ 许可声明 (License)

本项目遵循 **[MIT License](https://www.google.com/search?q=LICENSE)** 协议开源。您可以自由地使用、修改及分发本项目，但需保留原作者版权声明。

---
