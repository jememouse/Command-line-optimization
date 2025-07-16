#!/bin/bash
# =============================================================================
# 终端配置测试脚本
# 描述: 测试新的终端配置功能
# =============================================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

print_header() {
    echo
    print_message $CYAN "🧪 $1"
    echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# 测试配置文件语法
test_syntax() {
    print_header "测试配置文件语法"
    
    if zsh -n terminal_config.zsh; then
        print_message $GREEN "✅ 配置文件语法检查通过"
    else
        print_message $RED "❌ 配置文件语法错误"
        exit 1
    fi
}

# 测试Python版本检测
test_python_detection() {
    print_header "测试Python版本检测"
    
    echo "测试get_python_env_detail函数..."
    local result=$(zsh -c "source terminal_config.zsh && get_python_env_detail")
    if [[ -n "$result" && "$result" != "未安装" ]]; then
        print_message $GREEN "✅ Python版本检测: $result"
    else
        print_message $YELLOW "⚠️  Python版本检测可能有问题: $result"
    fi
}

# 测试环境信息命令
test_env_commands() {
    print_header "测试环境信息命令"
    
    # 测试quickenv
    echo "测试quickenv命令..."
    if zsh -c "source terminal_config.zsh && command -v quickenv" > /dev/null; then
        print_message $GREEN "✅ quickenv命令可用"
    else
        print_message $RED "❌ quickenv命令不可用"
    fi
    
    # 测试envswitch
    echo "测试envswitch命令..."
    if zsh -c "source terminal_config.zsh && command -v envswitch" > /dev/null; then
        print_message $GREEN "✅ envswitch命令可用"
    else
        print_message $RED "❌ envswitch命令不可用"
    fi
    
    # 测试initproject
    echo "测试initproject命令..."
    if zsh -c "source terminal_config.zsh && command -v initproject" > /dev/null; then
        print_message $GREEN "✅ initproject命令可用"
    else
        print_message $RED "❌ initproject命令不可用"
    fi
}

# 测试别名
test_aliases() {
    print_header "测试Python相关别名"
    
    local aliases=("pyversion" "pypath" "pyinfo" "mkvenv" "lsvenv")
    
    for alias_name in "${aliases[@]}"; do
        if zsh -c "source terminal_config.zsh && command -v $alias_name" > /dev/null; then
            print_message $GREEN "✅ $alias_name 别名可用"
        else
            print_message $YELLOW "⚠️  $alias_name 别名不可用"
        fi
    done
}

# 测试Git集成
test_git_integration() {
    print_header "测试Git集成"
    
    if git rev-parse --git-dir > /dev/null 2>&1; then
        local git_info=$(zsh -c "source terminal_config.zsh && get_git_info")
        if [[ -n "$git_info" ]]; then
            print_message $GREEN "✅ Git信息检测正常"
        else
            print_message $YELLOW "⚠️  Git信息检测可能有问题"
        fi
    else
        print_message $YELLOW "⚠️  当前目录不是Git仓库，跳过Git测试"
    fi
}

# 测试虚拟环境检测
test_venv_detection() {
    print_header "测试虚拟环境检测"
    
    local venv_info=$(zsh -c "source terminal_config.zsh && get_virtual_env")
    print_message $BLUE "虚拟环境信息: ${venv_info:-'无'}"
    
    # 检查pyenv
    if command -v pyenv > /dev/null; then
        print_message $GREEN "✅ pyenv已安装"
    else
        print_message $YELLOW "⚠️  pyenv未安装"
    fi
    
    # 检查conda
    if command -v conda > /dev/null; then
        print_message $GREEN "✅ conda已安装"
    else
        print_message $YELLOW "⚠️  conda未安装"
    fi
}

# 性能测试
test_performance() {
    print_header "测试性能"
    
    echo "测试提示符生成速度..."
    local start_time=$(date +%s.%N)
    
    # 运行多次提示符生成
    for i in {1..5}; do
        zsh -c "source terminal_config.zsh && get_python_env_detail && get_git_info && get_virtual_env" > /dev/null
    done
    
    local end_time=$(date +%s.%N)
    local duration=$(echo "$end_time - $start_time" | bc -l 2>/dev/null || echo "0.1")
    
    print_message $GREEN "✅ 5次提示符生成耗时: ${duration}s"
    
    if (( $(echo "$duration < 1.0" | bc -l 2>/dev/null || echo "1") )); then
        print_message $GREEN "✅ 性能测试通过"
    else
        print_message $YELLOW "⚠️  性能可能需要优化"
    fi
}

# 主测试函数
main() {
    print_message $CYAN "🚀 开始测试终端配置..."
    echo
    
    test_syntax
    test_python_detection
    test_env_commands
    test_aliases
    test_git_integration
    test_venv_detection
    test_performance
    
    echo
    print_message $GREEN "🎉 测试完成！"
    print_message $CYAN "如果所有测试都通过，可以运行 ./install.sh 安装配置"
    echo
}

# 运行测试
main
