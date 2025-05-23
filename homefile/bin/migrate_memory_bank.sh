#!/bin/bash

# vanzan01/cursor-memory-bank 迁移脚本
# 假定当前目录为项目根目录
# 固定模板目录：/Users/tanglq/main/_support/vanzan01-cursor-memory-bank

TEMPLATE_DIR="/Users/tanglq/main/_support/vanzan01-cursor-memory-bank"
BACKUP_DIR="./backup_memory_bank_migration"
OLD_MEMORY_BANK="./memory-bank"
OLD_CURSORRULES="./.cursorrules"

# 检查 memory-bank 目录是否存在
if [ ! -d "$OLD_MEMORY_BANK" ]; then
  echo "未检测到 memory-bank 目录，终止迁移。"
  exit 1
fi

echo "开始迁移，模板目录：$TEMPLATE_DIR"

# 1. 备份原有数据
mkdir -p "$BACKUP_DIR"
cp -r "$OLD_MEMORY_BANK" "$BACKUP_DIR/memory-bank_backup"
echo "已备份 memory-bank 到 $BACKUP_DIR/memory-bank_backup"
if [ -f "$OLD_CURSORRULES" ]; then
  cp "$OLD_CURSORRULES" "$BACKUP_DIR/.cursorrules_backup"
  echo "已备份 .cursorrules 到 $BACKUP_DIR/.cursorrules_backup"
fi

# 2. 复制 vanzan01 模板目录结构和文件（不覆盖已有 memory-bank 下内容）
# - memory-bank 目录
if [ ! -d "./memory-bank" ]; then
  cp -r "$TEMPLATE_DIR/memory-bank" ./
else
  # 合并文件，不覆盖已有内容
  for file in "$TEMPLATE_DIR/memory-bank"/*; do
    fname=$(basename "$file")
    if [ ! -f "./memory-bank/$fname" ]; then
      cp "$file" "./memory-bank/$fname"
      echo "添加模板 memory-bank/$fname"
    fi
  done
fi

# - .cursor/rules 目录
mkdir -p ./.cursor
if [ -d "$TEMPLATE_DIR/.cursor/rules" ]; then
  cp -rn "$TEMPLATE_DIR/.cursor/rules" ./.cursor/
  echo "已复制 .cursor/rules 模板"
else
  mkdir -p ./.cursor/rules
fi

# - custom_modes 目录
if [ -d "$TEMPLATE_DIR/custom_modes" ]; then
  cp -rn "$TEMPLATE_DIR/custom_modes" ./
  echo "已复制 custom_modes 模板"
else
  mkdir -p ./custom_modes
fi

# - 其他推荐文件（如 creative_mode_think_tool.md、README.md 等）
for fname in creative_mode_think_tool.md MEMORY_BANK_OPTIMIZATIONS.md memory_bank_upgrade_guide.md; do
  if [ -f "$TEMPLATE_DIR/$fname" ] && [ ! -f "./$fname" ]; then
    cp "$TEMPLATE_DIR/$fname" ./
    echo "添加 $fname"
  fi
done

# - optimization-journey（可选，建议合并）
if [ -d "$TEMPLATE_DIR/optimization-journey" ] && [ ! -d "./optimization-journey" ]; then
  cp -r "$TEMPLATE_DIR/optimization-journey" ./
  echo "添加 optimization-journey 目录"
fi

# 3. 迁移 .cursorrules 内容到 .cursor/rules/journal.mdc（如有）
if [ -f "$OLD_CURSORRULES" ]; then
  cat "$OLD_CURSORRULES" > ./.cursor/rules/journal.mdc
  echo "迁移 .cursorrules 内容到 .cursor/rules/journal.mdc"
fi

# 4. 自动补全 custom_modes 引用但不存在的 isolation_rules 目录和文件
for mode_file in ./custom_modes/*.md; do
  grep -oE "target_file: '([^']+)'" "$mode_file" | while read -r line; do
    rel_path=$(echo "$line" | sed "s/target_file: '\(.*\)'/\1/")
    abs_path="./$rel_path"
    abs_dir=$(dirname "$abs_path")
    mkdir -p "$abs_dir"
    if [ ! -f "$abs_path" ]; then
      echo "# Placeholder for $rel_path" > "$abs_path"
      echo "自动补全 $rel_path"
    fi
  done
done

echo "迁移完成！"
echo "已严格按 vanzan01/cursor-memory-bank 目录结构迁移。"
echo "请根据项目实际内容补充和完善 memory-bank 及 custom_modes。"

