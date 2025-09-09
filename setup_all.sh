#!/bin/bash

# 终端增强功能一键配置脚本

set -e

echo "🚀 开始配置终端增强功能..."
echo "=================================="

# 检查 Oh My Zsh 是否安装
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "🤔 未找到 Oh My Zsh，正在为您安装..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "✅ Oh My Zsh 已安装。"
fi

# 备份并链接配置文件
copy_config() {
  local src_file=$1
  local dest_file=$2
  
  echo "----------------------------------"
  echo "⚙️  正在配置 $dest_file..."
  
  # 如果目标文件已存在，则备份
  if [ -f "$dest_file" ] || [ -L "$dest_file" ]; then
    local backup_file="$dest_file.backup.$(date +%Y%m%d_%H%M%S)"
    echo "ℹ️  发现现有配置文件，正在备份到 $backup_file"
    mv "$dest_file" "$backup_file"
  fi
  
  # 复制项目中的配置文件到目标位置
  echo "✅ 正在复制 $src_file 到 $dest_file"
  cp "./$src_file" "$dest_file"
}

copy_config "enhanced_zshrc" "$HOME/.zshrc"
copy_config "p10k_config.zsh" "$HOME/.p10k.zsh"

# 字体安装提示
echo "----------------------------------"
echo "🎨 字体安装提示"
echo "为了获得最佳视觉效果，请务必安装并设置字体。"
echo "字体文件位于: ./MesloLGS_NF_Regular.ttf"
echo "请双击字体文件进行安装，然后在您的终端设置中选择 'MesloLGS NF' 作为字体。"

echo ""
echo "🎉 配置完成！"
echo "============="
echo "请完全重启您的终端以使所有更改生效。"