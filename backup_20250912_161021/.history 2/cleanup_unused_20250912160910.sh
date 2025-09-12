#!/bin/zsh

echo "开始清理无关文件..."

# 创建备份目录
BACKUP_DIR="./backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# 移动历史文件到备份目录
if [[ -d .history ]]; then
    echo "备份历史文件..."
    mv .history "$BACKUP_DIR/"
fi

# 备份并移除无关文件
files_to_backup=(
    "backup_configs.sh"
    "enhanced_completion.zsh"
    "completion_config.zsh"
    "setup_completion.sh"
    "setup_suggestions.sh"
    "zshrc_new"
)

for file in "${files_to_backup[@]}"; do
    if [[ -f "$file" ]]; then
        echo "备份并移除: $file"
        mv "$file" "$BACKUP_DIR/"
    fi
done

echo "无关文件已移动到备份目录: $BACKUP_DIR"
echo "如果确认这些文件确实不需要，可以手动删除备份目录"
echo "删除命令: rm -rf $BACKUP_DIR"