#!/bin/bash
# =============================================================================
# 终端命令行配置安装脚本
# 描述: 安装和配置现代化终端命令行显示
# 作者: Cline
# 版本: 2.0
# =============================================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

print_header() {
    echo
    print_message $PURPLE "🌟 $1"
    echo
}

# 检查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 检查操作系统
check_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macOS"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="Linux"
    else
        OS="Unknown"
    fi
}

# 备份现有配置
backup_config() {
    print_header "备份现有配置..."
    
    local timestamp=$(date +%Y%m%d_%H%M%S)
    
    # 备份.zshrc
    if [[ -f ~/.zshrc ]]; then
        cp ~/.zshrc ~/.zshrc.backup.$timestamp
        print_message $GREEN "✅ 已备份 ~/.zshrc 到 ~/.zshrc.backup.$timestamp"
    fi
    
    # 备份其他配置文件
    local configs=(".bashrc" ".bash_profile" ".profile")
    for config in "${configs[@]}"; do
        if [[ -f ~/$config ]]; then
            cp ~/$config ~/$config.backup.$timestamp
            print_message $GREEN "✅ 已备份 ~/$config 到 ~/$config.backup.$timestamp"
        fi
    done
}

# 检查依赖
check_dependencies() {
    print_header "检查依赖..."
    
    # 检查zsh
    if ! command_exists zsh; then
        print_message $RED "❌ zsh 未安装"
        if [[ "$OS" == "macOS" ]]; then
            print_message $YELLOW "请运行: brew install zsh"
        elif [[ "$OS" == "Linux" ]]; then
            print_message $YELLOW "请运行: sudo apt-get install zsh 或 sudo yum install zsh"
        fi
        exit 1
    else
        print_message $GREEN "✅ zsh 已安装: $(zsh --version)"
    fi
    
    # 检查Python
    if ! command_exists python3; then
        print_message $YELLOW "⚠️  python3 未安装，某些功能可能不可用"
    else
        print_message $GREEN "✅ python3 已安装: $(python3 --version)"
    fi
    
    # 检查git
    if ! command_exists git; then
        print_message $YELLOW "⚠️  git 未安装，Git集成功能将不可用"
    else
        print_message $GREEN "✅ git 已安装: $(git --version)"
    fi
}

# 安装字体（可选）
install_fonts() {
    print_header "安装Nerd Fonts字体（可选）..."
    
    print_message $CYAN "为了获得最佳显示效果，建议安装Nerd Fonts字体"
    print_message $YELLOW "这将确保所有图标和符号正确显示"
    
    read -p "是否安装Nerd Fonts字体？(y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [[ "$OS" == "macOS" ]]; then
            if command_exists brew; then
                brew tap homebrew/cask-fonts
                brew install --cask font-hack-nerd-font
                print_message $GREEN "✅ 已安装 Hack Nerd Font"
                print_message $YELLOW "请在终端设置中将字体更改为 'Hack Nerd Font'"
            else
                print_message $RED "❌ 请先安装 Homebrew"
            fi
        else
            print_message $YELLOW "请手动下载并安装 Nerd Fonts: https://www.nerdfonts.com/"
        fi
    else
        print_message $BLUE "跳过字体安装"
    fi
}

# 配置终端
configure_terminal() {
    print_header "配置终端..."
    
    # 获取当前脚本目录
