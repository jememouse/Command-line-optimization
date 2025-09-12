#!/bin/zsh

echo "开始修复配置..."

# 备份现有配置
if [[ -f ~/.zshrc ]]; then
    echo "备份现有的 zshrc..."
    cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S)
fi

# 安装新配置
echo "安装新的配置文件..."
cp ./zshrc_new ~/.zshrc

# 创建必要的目录
echo "创建必要的目录..."
mkdir -p ~/.zsh/completions
mkdir -p ~/.zsh/cache

# 确保相关目录存在
echo "检查配置目录..."
if [[ ! -d ~/.zsh ]]; then
    mkdir -p ~/.zsh
fi

# 移除错误的配置引用
if [[ -f ~/.zshrc ]]; then
    echo "清理错误的配置引用..."
    sed -i '.bak' '/source.*p10k\.zshsource/d' ~/.zshrc
fi

echo "配置修复完成！"
echo "请运行以下命令使配置生效："
echo "source ~/.zshrc"