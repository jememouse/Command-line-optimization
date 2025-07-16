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
