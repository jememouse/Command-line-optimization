#!/bin/zsh

echo "开始安装命令补全系统..."

# 1. 创建必要的目录
echo "创建目录结构..."
mkdir -p ~/.zsh/cache
mkdir -p ~/.zsh/completions

# 2. 安装配置文件
echo "安装配置文件..."
cp ./completion_config.zsh ~/.zsh/
echo "source ~/.zsh/completion_config.zsh" >> ~/.zshrc

# 3. 下载补全脚本
echo "下载额外的补全脚本..."
mkdir -p ~/.zsh/site-functions
# Git 补全
if [ ! -f ~/.zsh/site-functions/_git ]; then
    curl -L https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh -o ~/.zsh/site-functions/_git
fi

# 4. 设置权限
echo "设置权限..."
chmod 755 ~/.zsh/completion_config.zsh
chmod -R 755 ~/.zsh/site-functions

echo "安装完成！"
echo "请运行以下命令使配置生效："
echo "source ~/.zshrc"
echo ""
echo "然后运行测试命令："
echo "test_completion all"