#!/bin/zsh

echo "开始安装增强补全和环境管理功能..."

# 1. 创建必要的目录
echo "创建目录结构..."
mkdir -p ~/.zsh/completions
mkdir -p ~/.zsh/cache
mkdir -p ~/.virtualenvs

# 2. 安装 NVM (Node Version Manager)
echo "安装 NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# 3. 复制配置文件
echo "安装配置文件..."
cp ./enhanced_completion.zsh ~/.zsh/
echo "source ~/.zsh/enhanced_completion.zsh" >> ~/.zshrc

# 4. 安装必要的工具
if command -v brew &>/dev/null; then
    echo "安装依赖工具..."
    brew install jq # 用于处理 JSON
fi

# 5. 设置权限
echo "设置权限..."
chmod 755 ~/.zsh/enhanced_completion.zsh

echo "安装完成！"
echo "请运行以下命令使配置生效："
echo "source ~/.zshrc"
echo ""
echo "可用的命令："
echo "1. Python 虚拟环境管理："
echo "   - venv_create <名称> [Python版本]"
echo "   - venv_activate <名称>"
echo "   - venv_remove <名称>"
echo "   - venv_list"
echo ""
echo "2. Node.js 版本管理："
echo "   - node_install <版本>"
echo "   - node_use <版本>"
echo "   - node_remove <版本>"
echo ""
echo "3. 环境切换："
echo "   - switch_env <类型> <环境名>"
echo ""
echo "4. 环境信息："
echo "   - show_current_env"