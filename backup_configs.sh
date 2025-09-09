#!/bin/bash

# 配置文件备份脚本
# 备份所有重要的shell和终端配置文件

set -e

BACKUP_DIR="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"
echo "🔄 创建配置备份目录: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# 备份函数
backup_file() {
    local file="$1"
    local description="$2"
    
    if [[ -f "$file" ]]; then
        cp "$file" "$BACKUP_DIR/"
        echo "✅ 已备份 $description: $file"
    else
        echo "⚠️  文件不存在，跳过: $file"
    fi
}

backup_dir() {
    local dir="$1"
    local description="$2"
    
    if [[ -d "$dir" ]]; then
        cp -r "$dir" "$BACKUP_DIR/"
        echo "✅ 已备份 $description: $dir"
    else
        echo "⚠️  目录不存在，跳过: $dir"
    fi
}

echo "📦 开始备份配置文件..."

# 备份 shell 配置文件
backup_file "$HOME/.zshrc" "Zsh 配置文件"
backup_file "$HOME/.bashrc" "Bash 配置文件"
backup_file "$HOME/.bash_profile" "Bash Profile"
backup_file "$HOME/.profile" "通用 Profile"

# 备份 conda/mamba 配置
backup_file "$HOME/.condarc" "Conda 配置文件"

# 备份 oh-my-zsh 配置（如果存在）
backup_dir "$HOME/.oh-my-zsh" "Oh My Zsh 配置"

# 备份其他常见配置
backup_file "$HOME/.vimrc" "Vim 配置文件"
backup_file "$HOME/.gitconfig" "Git 配置文件"
backup_file "$HOME/.tmux.conf" "Tmux 配置文件"

# 备份 VS Code 设置（如果存在）
if [[ -d "$HOME/Library/Application Support/Code/User" ]]; then
    mkdir -p "$BACKUP_DIR/vscode"
    cp "$HOME/Library/Application Support/Code/User/settings.json" "$BACKUP_DIR/vscode/" 2>/dev/null || true
    cp "$HOME/Library/Application Support/Code/User/keybindings.json" "$BACKUP_DIR/vscode/" 2>/dev/null || true
    echo "✅ 已备份 VS Code 配置"
fi

# 备份终端配置（如果存在）
backup_file "$HOME/.config/alacritty/alacritty.yml" "Alacritty 终端配置"
backup_file "$HOME/.config/kitty/kitty.conf" "Kitty 终端配置"

# 创建备份信息文件
cat > "$BACKUP_DIR/backup_info.txt" << EOF
配置文件备份信息
================

备份时间: $(date)
备份目录: $BACKUP_DIR
系统信息: $(uname -a)
Shell: $SHELL

恢复说明:
--------
如需恢复配置，请将相应文件复制回原位置：

1. 恢复 Zsh 配置:
   cp $BACKUP_DIR/.zshrc ~/.zshrc

2. 恢复 Conda 配置:
   cp $BACKUP_DIR/.condarc ~/.condarc

3. 恢复 Oh My Zsh:
   rm -rf ~/.oh-my-zsh
   cp -r $BACKUP_DIR/.oh-my-zsh ~/

注意: 恢复后需要重新启动终端或运行 source ~/.zshrc
EOF

echo ""
echo "✅ 备份完成！"
echo "📁 备份位置: $BACKUP_DIR"
echo "📄 备份信息: $BACKUP_DIR/backup_info.txt"
echo ""
echo "🔄 如需恢复配置，请查看备份信息文件中的说明"
