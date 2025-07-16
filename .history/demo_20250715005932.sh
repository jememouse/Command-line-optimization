#!/bin/bash
# =============================================================================
# 终端命令行配置演示脚本
# 描述: 演示新配置的终端命令行功能
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
    print_message $BLUE "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
}

# 显示加载动画
show_loading() {
    local message=$1
    local duration=${2:-2}
    local spin='-\|/'
    
    printf "${CYAN}${message} "
    for i in $(seq 1 $duration); do
        for j in {0..3}; do
            printf "\b${spin:$j:1}"
            sleep 0.1
        done
    done
    printf "\b${GREEN}✅${NC}\n"
}

# 演示提示符
demo_prompt() {
    print_header "演示1: 现代化提示符"
    
    print_message $CYAN "新的提示符设计包含以下信息："
    echo
    print_message $YELLOW "┌─[👤 用户名]─[@主机名]─[📁 当前目录]─[🌿 git分支] [🔧 虚拟环境]"
    print_message $YELLOW "└─[🐍 Python版本] [⏰ 时间] ➤ "
    echo
    print_message $GREEN "特点："
    echo "   • 多行设计，信息清晰"
    echo "   • 实时显示Python版本"
    echo "   • Git分支和状态指示"
    echo "   • 虚拟环境自动识别"
    echo "   • 时间戳显示"
    echo
    
    read -p "按 Enter 键继续..."
}

# 演示环境信息
demo_env_commands() {
    print_header "演示2: 环境信息命令"
    
    print_message $CYAN "我们提供了两个强大的环境信息命令："
    echo
    
    # 演示quickenv
    print_message $GREEN "quickenv - 快速环境概览"
    echo
    if command -v quickenv &> /dev/null; then
        quickenv
    else
        print_message $YELLOW "模拟输出："
        echo "⚡ 快速环境信息"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "🖥️  系统: Darwin 22.6.0 (x86_64)"
        echo "📁 目录: ~/Documents/code-project/终端命令行优化"
        echo "🐍 Python: 3.11.5"
        echo "   路径: /usr/local/bin/python3"
        echo "🔧 虚拟环境: myproject"
        echo "📝 Git: 2.39.3"
        echo "🌿 分支: main"
        echo "🐚 Shell: Zsh 5.9"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    fi
    
    echo
    read -p "按 Enter 键继续..."
    
    # 演示fullenv
    print_message $GREEN "fullenv - 完整环境详情"
    echo
    if command -v fullenv &> /dev/null; then
        fullenv
    else
        print_message $YELLOW "模拟输出："
        echo "🌟 完整环境信息"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "💻 系统信息:"
        echo "   操作系统: Darwin"
        echo "   内核版本: 22.6.0"
        echo "   架构: x86_64"
        echo "   主机名: MacBook-Pro"
        echo "   用户名: jiewang"
        echo
        echo "📂 目录信息:"
        echo "   当前目录: ~/Documents/code-project/终端命令行优化"
        echo "   家目录: /Users/jiewang"
        echo
        echo "🐍 Python环境:"
        echo "   版本: 3.11.5"
        echo "   路径: /usr/local/bin/python3"
        echo "   🔧 虚拟环境: myproject"
        echo "   虚拟环境路径: ~/venvs/myproject"
        echo
        echo "🛠️  开发工具:"
        echo "   Git: 2.39.3"
        echo "   Node.js: v18.17.1"
        echo "   npm: 9.6.7"
        echo "   Docker: 24.0.5"
        echo
        echo "📊 系统资源:"
        echo "   CPU: Apple M2 Pro"
        echo "   内存: 32GB"
        echo "   磁盘使用: /dev/disk1: 200GB/500GB (40% 已使用)"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    fi
    
    echo
    read -p "按 Enter 键继续..."
}

# 演示别名和快捷方式
demo_aliases() {
    print_header "演示3: 实用别名和快捷方式"
    
    print_message $CYAN "我们提供了丰富的别名和快捷方式："
    echo
    
    print_message $GREEN "文件操作："
    echo "   ll    - ls -alF (详细列表)"
    echo "   la    - ls -A (显示隐藏文件)"
    echo "   l     - ls -CF (简洁列表)"
    echo "   ..    - cd .. (返回上级)"
    echo "   ...   - cd ../.. (返回两级)"
    echo
    
    print_message $GREEN "Python相关："
    echo "   py        - python3"
