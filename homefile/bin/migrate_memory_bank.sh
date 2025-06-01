#!/bin/bash

# vanzan01/cursor-memory-bank 官方规范迁移脚本
# 假定当前目录为项目根目录
# 模板目录固定为 /Users/tanglq/main/_support/vanzan01-cursor-memory-bank

TEMPLATE_DIR="/Users/tanglq/main/_support/vanzan01-cursor-memory-bank"
BACKUP_DIR="./backup_memory_bank_migration"
OLD_MEMORY_BANK="./memory-bank"
OLD_CURSORRULES="./.cursorrules"

# 1. 检查 memory-bank 目录
if [ ! -d "$OLD_MEMORY_BANK" ]; then
  echo "未检测到 memory-bank 目录，终止迁移。"
  exit 1
fi

echo "开始迁移，模板目录：$TEMPLATE_DIR"

# 2. 备份原有数据
mkdir -p "$BACKUP_DIR"
cp -r "$OLD_MEMORY_BANK" "$BACKUP_DIR/memory-bank_backup"
echo "已备份 memory-bank 到 $BACKUP_DIR/memory-bank_backup"
if [ -f "$OLD_CURSORRULES" ]; then
  cp "$OLD_CURSORRULES" "$BACKUP_DIR/.cursorrules_backup"
  echo "已备份 .cursorrules 到 $BACKUP_DIR/.cursorrules_backup"
fi

# 3. 复制 vanzan01 模板目录结构和文件（不会覆盖已有 memory-bank 下内容）
# - memory-bank 目录
for file in "$TEMPLATE_DIR/memory-bank"/*; do
  fname=$(basename "$file")
  if [ ! -f "./memory-bank/$fname" ]; then
    cp "$file" "./memory-bank/$fname"
    echo "添加模板 memory-bank/$fname"
  fi
done

# - .cursor/rules 目录
mkdir -p ./.cursor
if [ -d "$TEMPLATE_DIR/.cursor/rules" ]; then
  cp -rn "$TEMPLATE_DIR/.cursor/rules" ./.cursor/
  echo "已复制 .cursor/rules 模板"
else
  mkdir -p ./.cursor/rules
fi

# - custom_modes 目录
echo
echo "======================================="
echo "请确保已经在Cursor中配置 custom models."
echo "======================================="
echo
#if [ -d "$TEMPLATE_DIR/custom_modes" ]; then
#  cp -rn "$TEMPLATE_DIR/custom_modes" ./
#  echo "已复制 custom_modes 模板"
#else
#  mkdir -p ./custom_modes
#fi

# - 其他推荐文件（如 creative_mode_think_tool.md、README.md 等）
#for fname in creative_mode_think_tool.md MEMORY_BANK_OPTIMIZATIONS.md memory_bank_upgrade_guide.md; do
#  if [ -f "$TEMPLATE_DIR/$fname" ] && [ ! -f "./$fname" ]; then
#    cp "$TEMPLATE_DIR/$fname" ./
#    echo "添加 $fname"
#  fi
#done

#if [ -d "$TEMPLATE_DIR/optimization-journey" ] && [ ! -d "./optimization-journey" ]; then
#  cp -r "$TEMPLATE_DIR/optimization-journey" ./
#  echo "添加 optimization-journey 目录"
#fi

# 4. 迁移 .cursorrules 内容到 .cursor/rules/journal.mdc（如有）
if [ -f "$OLD_CURSORRULES" ]; then
  cat "$OLD_CURSORRULES" > ./.cursor/rules/journal.mdc
  echo "迁移 .cursorrules 内容到 .cursor/rules/journal.mdc"
fi

# 5. 自动补全 custom_modes 引用但不存在的 isolation_rules 目录和文件
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

# 6. 输出后续手工操作提示
echo
echo "【重要】请在 Cursor 的设置中手动添加/配置以下自定义模式（Custom Modes）："
echo "1. VAN 模式 → 关联 custom_modes/van_instructions.md"
echo "2. PLAN 模式 → 关联 custom_modes/plan_instructions.md"
echo "3. CREATIVE 模式 → 关联 custom_modes/creative_instructions.md"
echo "4. IMPLEMENT 模式 → 关联 custom_modes/implement_instructions.md"
echo "5. QA/REFLECT 模式（如有）→ 关联 custom_modes/reflect_archive_instructions.md"
echo
echo "每个模式的 instructions 路径请严格对应 custom_modes 目录下的文件。"
echo "如需可视化流程图和复杂度决策树，详见 memory-bank/ 及 .cursor/rules/isolation_rules/ 下的相关文件。"
echo
echo "迁移完成！你现在拥有了分阶段、JIT加载、可视化流程和复杂度自适应的 Memory Bank 体系。"
echo "如需进一步优化，请参考 MEMORY_BANK_OPTIMIZATIONS.md 和 memory_bank_upgrade_guide.md。"

