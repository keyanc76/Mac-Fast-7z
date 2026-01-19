#!/bin/zsh

# 1. 环境配置 (防止中文乱码)
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# 2. 定位 7zz 工具
if [ -f "/opt/homebrew/bin/7zz" ]; then
    ZIP_PATH="/opt/homebrew/bin/7zz"
else
    ZIP_PATH="/usr/local/bin/7zz"
fi

success_count=0
total_count=$#

for f in "$@"
do
    # 基础校验：跳过不存在的文件或文件夹
    [ ! -e "$f" ] && continue

    # 获取路径与文件名
    dir=$(dirname "$f")
    filename=$(basename "$f")
    # 生成输出文件名：去掉原后缀，加上 .7z
    output_name="${filename%.*}.7z"
    
    # 核心步骤：进入文件所在目录
    cd "$dir"

    # 执行压缩指令
    # -ssw: 解决资源死锁问题
    # --: 确保文件名特殊字符不被误读
    "$ZIP_PATH" a "$output_name" -- "$filename" \
    -r \
    -mx=7 \
    -ssw \
    '-xr!*.DS_Store' \
    '-xr!__MACOSX'

    # 检查退出状态码
    if [ $? -eq 0 ]; then
        ((success_count++))
    fi
done

# 3. 弹出通知提示
if [ $success_count -eq $total_count ]; then
    osascript -e "display notification \"已成功完成 $success_count 个文件的压缩\" with title \"📦 7-Zip 压缩完成\" sound name \"Glass\""
else
    osascript -e "display notification \"压缩出现问题 (成功 $success_count/$total_count)\" with title \"⚠️ 压缩异常\" sound name \"Basso\""
fi
