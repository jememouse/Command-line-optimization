#!/bin/zsh

echo "开始安装和配置基础终端环境..."

# 1. 创建必要的目录
echo "创建配置目录..."
mkdir -p ~/.zsh
mkdir -p ~/.zsh/plugins

# 2. 备份现有配置
if [[ -f ~/.zshrc ]]; then
    echo "备份现有的 zshrc 配置..."
    cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S)
fi

# 3. 安装必要的插件
echo "安装命令建议插件..."
if [[ ! -d ~/.zsh/zsh-autosuggestions ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
fi

echo "安装语法高亮插件..."
if [[ ! -d ~/.zsh/zsh-syntax-highlighting ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
fi

# 4. 复制新的配置文件
echo "应用新的配置文件..."
cp ./basic_zshrc ~/.zshrc

# 5. 设置权限
echo "设置适当的权限..."
chmod 644 ~/.zshrc

echo "安装完成！请运行以下命令使配置生效："
echo "source ~/.zshrc"