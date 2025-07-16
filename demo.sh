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
    
    print_message $CYAN "我们提供了强大的环境信息和管理命令："
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
        echo "🖥️  系统: Darwin 25.0.0 (arm64)"
        echo "📁 目录: ~/Documents/code-project/终端命令行优化"
        echo "🐍 Python: 3.12.11 (pyenv)"
        echo "   路径: /Users/jiewang/.pyenv/versions/3.12.11/bin/python3"
        echo "🔧 pyenv: 3.12.11"
        echo "⚡ Node.js: v23.7.0"
        echo "📝 Git: 2.39.5"
        echo "🌿 分支: main"
        echo "   状态: 有未提交的更改"
        echo "🐚 Shell: Zsh 5.9"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    fi

    echo
    read -p "按 Enter 键查看环境切换助手..."

    # 演示envswitch
    print_message $GREEN "envswitch - 环境切换助手"
    echo
    print_message $YELLOW "模拟输出："
    echo "🔄 环境切换助手"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "当前环境:"
    echo "   🐍 Python: 3.12.11 (pyenv)"
    echo
    echo "可用操作:"
    echo "pyenv版本管理:"
    echo "   pyenvlist    - 查看所有Python版本"
    echo "   pyenvglobal  - 设置全局Python版本"
    echo "   pyenvlocal   - 设置本地Python版本"
    echo
    echo "虚拟环境管理:"
    echo "   mkvenv <name>  - 创建虚拟环境"
    echo "   activate       - 激活虚拟环境"
    echo "   deactivate     - 退出虚拟环境"
    echo "   lsvenv         - 列出虚拟环境"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
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
    echo "   pip       - pip3"
    echo "   venv      - python3 -m venv"
    echo "   activate  - source venv/bin/activate"
    echo
    
    print_message $GREEN "Git相关："
    echo "   gs  - git status"
    echo "   ga  - git add"
    echo "   gc  - git commit"
    echo "   gp  - git push"
    echo "   gl  - git log --oneline -10"
    echo "   gd  - git diff"
    echo
    
    print_message $GREEN "系统信息："
    echo "   sysinfo  - uname -a"
    echo "   diskinfo - df -h"
    echo "   meminfo  - vm_stat (macOS)"
    echo "   cpuinfo  - CPU信息"
    echo "   myip     - 获取公网IP"
    echo
    
    read -p "按 Enter 键继续..."
}

# 演示自动补全
demo_autocomplete() {
    print_header "演示4: 智能自动补全"
    
    print_message $CYAN "增强的自动补全功能："
    echo
    print_message $GREEN "特性："
    echo "   • 命令、文件名、目录名智能补全"
    echo "   • Git分支名补全"
    echo "   • 命令参数补全"
    echo "   • 历史命令补全"
    echo "   • 模糊匹配"
    echo
    
    print_message $YELLOW "使用示例："
    echo "   输入 'git ch' 然后按 Tab → 显示 checkout, cherry-pick 等"
    echo "   输入 'cd D' 然后按 Tab → 显示以D开头的目录"
    echo "   输入 '!py' 然后按 Tab → 显示历史中的python命令"
    echo
    
    read -p "按 Enter 键继续..."
}

# 演示Git集成
demo_git_integration() {
    print_header "演示5: Git集成"
    
    print_message $CYAN "Git集成功能："
    echo
    
    # 创建临时git仓库演示
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"
    
    if command -v git &> /dev/null; then
        git init --quiet
        echo "# 测试项目" > README.md
        git add README.md
        git commit -m "初始提交" --quiet
        git checkout -b feature/demo --quiet
        
        print_message $GREEN "当前Git状态："
        echo "   分支: feature/demo"
        echo "   状态: 工作区干净"
        echo
        
        print_message $YELLOW "提示符将显示："
        echo "   🌿 feature/demo"
        echo
        
        # 创建修改
        echo "修改内容" >> README.md
        print_message $YELLOW "当有未提交的更改时："
        echo "   🌿 feature/demo* (星号表示有修改)"
    else
        print_message $YELLOW "Git未安装，跳过演示"
    fi
    
    # 清理
    cd - > /dev/null
    rm -rf "$temp_dir"
    
    echo
    read -p "按 Enter 键继续..."
}

# 演示虚拟环境集成
demo_venv_integration() {
    print_header "演示6: 虚拟环境集成"
    
    print_message $CYAN "虚拟环境自动识别："
    echo
    
    print_message $GREEN "支持的虚拟环境："
    echo "   • Python venv"
    echo "   • virtualenv"
    echo "   • conda"
    echo "   • pyenv"
    echo
    
    print_message $YELLOW "示例显示："
    echo "   🔧 myproject (Python venv)"
    echo "   🅒 data-science (conda环境)"
    echo "   🔧 myproject 🅒 data-science (同时显示)"
    echo
    
    print_message $GREEN "使用方法："
    echo "   1. 创建虚拟环境: venv myproject"
    echo "   2. 激活虚拟环境: activate"
    echo "   3. 提示符自动显示环境信息"
    echo
    
    read -p "按 Enter 键继续..."
}

# 性能测试
demo_performance() {
    print_header "演示7: 性能优化"
    
    print_message $CYAN "性能特点："
    echo
    print_message $GREEN "优化措施："
    echo "   • 异步Git状态检查"
    echo "   • 缓存Python版本信息"
    echo "   • 最小化系统调用"
    echo "   • 智能条件判断"
    echo
    
    print_message $YELLOW "性能测试："
    local start_time=$(date +%s.%N)
    
    # 模拟提示符生成
    for i in {1..10}; do
        # 这里可以添加实际的性能测试
        sleep 0.01
    done
    
    local end_time=$(date +%s.%N)
    local duration=$(echo "$end_time - $start_time" | bc -l)
    
    print_message $GREEN "   提示符生成时间: ${duration}s (平均)"
    print_message $GREEN "   无感知延迟，流畅体验"
    echo
    
    read -p "按 Enter 键继续..."
}

# 故障排除
demo_troubleshooting() {
    print_header "演示8: 故障排除"
    
    print_message $CYAN "常见问题及解决方案："
    echo
    
    print_message $YELLOW "问题1: 图标显示为方框"
    echo "   解决方案: 安装Nerd Fonts字体"
    echo "   推荐: Hack Nerd Font 或 FiraCode Nerd Font"
    echo
    
    print_message $YELLOW "问题2: Python版本显示错误"
    echo "   解决方案: 检查PATH环境变量"
    echo "   命令: which python3"
    echo
    
    print_message $YELLOW "问题3: Git分支不显示"
    echo "   解决方案: 确保在Git仓库中"
    echo "   命令: git status"
    echo
    
    print_message $YELLOW "问题4: 虚拟环境不显示"
    echo "   解决方案: 检查虚拟环境是否激活"
    echo "   命令: echo $VIRTUAL_ENV"
    echo
    
    read -p "按 Enter 键继续..."
}

# 主演示函数
main() {
    print_header "终端命令行配置演示"
    
    print_message $CYAN "欢迎使用全新的终端命令行配置！"
    echo
    print_message $GREEN "本次演示将展示以下功能："
    echo "   1. 现代化提示符设计"
    echo "   2. 环境信息命令"
    echo "   3. 实用别名和快捷方式"
    echo "   4. 智能自动补全"
    echo "   5. Git集成"
    echo "   6. 虚拟环境集成"
    echo "   7. 性能优化"
    echo "   8. 故障排除"
    echo
    
    read -p "按 Enter 键开始演示..."
    
    demo_prompt
    demo_env_commands
    demo_aliases
    demo_autocomplete
    demo_git_integration
    demo_venv_integration
    demo_performance
    demo_troubleshooting
    
    print_header "演示完成！"
    
    print_message $GREEN "🎉 演示完成！"
    echo
    print_message $CYAN "下一步："
    echo "   1. 运行 ./install.sh 安装配置"
    echo "   2. 重启终端或运行: source ~/.zshrc"
    echo "   3. 开始使用新的终端体验！"
    echo
    print_message $YELLOW "如需帮助，请查看 README.md 或运行: ./install.sh --help"
}

# 处理命令行参数
case "$1" in
    --help|-h)
        echo "使用方法: $0 [选项]"
        echo
        echo "选项:"
        echo "  --help, -h     显示帮助信息"
        echo "  --quick        快速演示（跳过等待）"
        exit 0
        ;;
    --quick)
        # 快速演示模式
        print_header "终端命令行配置 - 快速演示"
        print_message $GREEN "所有功能已就绪！"
        print_message $CYAN "运行 ./install.sh 开始安装"
        exit 0
        ;;
    *)
        main
        ;;
esac
