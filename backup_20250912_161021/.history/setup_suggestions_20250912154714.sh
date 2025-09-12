#!/bin/zsh

echo "开始安装实时命令联想系统..."

# 1. 创建必要的目录
echo "创建目录结构..."
mkdir -p ~/.zsh

# 2. 安装必要的插件
echo "安装自动建议插件..."
if [ ! -d ~/.zsh/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
fi

echo "安装语法高亮插件..."
if [ ! -d ~/.zsh/zsh-syntax-highlighting ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
fi

# 3. 复制配置文件
echo "安装配置文件..."
cp ./suggestion_config.zsh ~/.zsh/
echo "source ~/.zsh/suggestion_config.zsh" >> ~/.zshrc

# 4. 创建建议缓存文件
echo "初始化建议缓存..."
touch ~/.zsh/command_suggestions

# 5. 设置权限
echo "设置权限..."
chmod 755 ~/.zsh/suggestion_config.zsh
chmod 644 ~/.zsh/command_suggestions

echo "安装完成！"
echo "请运行以下命令使配置生效："
echo "source ~/.zshrc"
echo ""
echo "然后运行以下命令测试联想功能："
echo "test_suggestions"