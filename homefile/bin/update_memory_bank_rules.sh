#!/bin/bash

# 脚本功能：
# 1. 进入 vanzan01-cursor-memory-bank 模板目录并 git pull 更新
# 2. 检查当前目录下 .cursor/rules/isolation_rules 是否存在，不存在则退出
# 3. 删除当前目录下 .cursor/rules/isolation_rules 下所有内容
# 4. 复制模板目录下最新的 isolation_rules 到当前目录

TEMPLATE_DIR="/Users/tanglq/main/_support/vanzan01-cursor-memory-bank"
TARGET_ISOLATION_RULES=".cursor/rules/isolation_rules"
SOURCE_ISOLATION_RULES="$TEMPLATE_DIR/.cursor/rules/isolation_rules"

# 检查 isolation_rules 是否存在
if [ ! -d "$TARGET_ISOLATION_RULES" ]; then
  echo "未检测到 .cursor/rules/isolation_rules 目录，终止更新。"
  exit 1
fi

if [ -f "/etc/proxy" ]; then
  source /etc/proxy
fi

# 1. 进入模板目录并 git pull
echo "正在进入模板目录并拉取最新代码……"
cd "$TEMPLATE_DIR" || { echo "模板目录不存在，终止操作。"; exit 1; }
git pull

# 2. 返回原项目目录
cd - > /dev/null

# 3. 删除旧 isolation_rules 内容
echo "正在删除旧的 isolation_rules 内容……"
rm -rf "$TARGET_ISOLATION_RULES"/*

# 4. 复制最新 isolation_rules
echo "正在复制最新 isolation_rules 文件……"
cp -r "$SOURCE_ISOLATION_RULES"/* "$TARGET_ISOLATION_RULES/"

echo "isolation_rules 已成功更新为最新官方版本！"

