#!/bin/bash
# =============================================================================
# 终端配置管理脚本
# 功能：恢复默认配置、应用自定义配置、查看当前状态
# =============================================================================

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

print_header() {
    echo
    print_message $CYAN "🔧 $1"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# 显示当前配置状态
show_current_status() {
    print_header "当前配置状态"
    
    echo "Shell信息："
    echo "  当前Shell: $SHELL"
    echo "  用户名: $USER"
    echo "  zsh版本: $(zsh --version 2>/dev/null || echo '未安装')"
    echo
    
    echo "配置文件状态："
    if [[ -f ~/.zshrc ]]; then
        print_message $GREEN "✅ ~/.zshrc 存在"
        echo "  文件大小: $(wc -l < ~/.zshrc) 行"
        echo "  最后修改: $(stat -f "%Sm" ~/.zshrc 2>/dev/null || stat -c "%y" ~/.zshrc 2>/dev/null)"
    else
        print_message $YELLOW "⚠️  ~/.zshrc 不存在"
    fi
    
    # 检查备份文件
    local backups=($(ls ~/.zshrc.backup.* 2>/dev/null || true))
    if [[ ${#backups[@]} -gt 0 ]]; then
        echo
        echo "备份文件："
        for backup in "${backups[@]}"; do
            echo "  📁 $(basename $backup)"
        done
    fi
    
    echo
    echo "当前提示符："
    echo "  PS1: ${PS1:-'未设置'}"
    echo "  PROMPT: ${PROMPT:-'未设置'}"
}

# 恢复默认配置
restore_default() {
    print_header "恢复默认配置"
    
    # 备份当前配置
    if [[ -f ~/.zshrc ]]; then
        local timestamp=$(date +%Y%m%d_%H%M%S)
        cp ~/.zshrc ~/.zshrc.backup.$timestamp
        print_message $GREEN "✅ 已备份当前配置到 ~/.zshrc.backup.$timestamp"
    fi
    
    # 创建最小的默认配置
    cat > ~/.zshrc << 'EOF'
# 默认zsh配置
# 启用颜色支持
autoload -U colors && colors

# 基本提示符
PROMPT='%n@%m:%~$ '

# 基本别名
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# 历史记录
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

# 自动补全
autoload -Uz compinit
compinit

echo "✅ 默认zsh配置已加载"
EOF
    
    print_message $GREEN "✅ 已恢复默认配置"
    print_message $YELLOW "请运行 'source ~/.zshrc' 或重启终端来应用配置"
}

# 应用自定义配置
apply_custom_config() {
    print_header "应用自定义配置"
    
    local config_file="$1"
    if [[ -z "$config_file" ]]; then
        echo "可用的配置文件："
        echo "  1. terminal_config.zsh - 完整功能配置"
        echo "  2. optimized_terminal_config.zsh - 优化版本"
        echo "  3. simple_prompt.zsh - 简化版本"
        echo
        read -p "请选择配置文件 (1-3): " choice
        
        case $choice in
            1) config_file="terminal_config.zsh" ;;
            2) config_file="optimized_terminal_config.zsh" ;;
            3) config_file="simple_prompt.zsh" ;;
            *) print_message $RED "❌ 无效选择"; return 1 ;;
        esac
    fi
    
    if [[ ! -f "$config_file" ]]; then
        print_message $RED "❌ 配置文件不存在: $config_file"
        return 1
    fi
    
    # 备份当前配置
    if [[ -f ~/.zshrc ]]; then
        local timestamp=$(date +%Y%m%d_%H%M%S)
        cp ~/.zshrc ~/.zshrc.backup.$timestamp
        print_message $GREEN "✅ 已备份当前配置"
    fi
    
    # 应用新配置
    local full_path="$(cd "$(dirname "$config_file")" && pwd)/$(basename "$config_file")"
    
    cat > ~/.zshrc << EOF
# 自定义终端配置
# 配置文件: $full_path
# 应用时间: $(date)

source "$full_path"
EOF
    
    print_message $GREEN "✅ 已应用配置: $config_file"
    print_message $YELLOW "请运行 'source ~/.zshrc' 或重启终端来应用配置"
}

# 测试配置
test_config() {
    print_header "测试配置"
    
    if [[ ! -f ~/.zshrc ]]; then
        print_message $RED "❌ ~/.zshrc 不存在"
        return 1
    fi
    
    # 语法检查
    if zsh -n ~/.zshrc 2>/dev/null; then
        print_message $GREEN "✅ 配置文件语法正确"
    else
        print_message $RED "❌ 配置文件语法错误"
        echo "错误详情："
        zsh -n ~/.zshrc
        return 1
    fi
    
    # 功能测试
    print_message $CYAN "测试配置加载..."
    zsh -c "source ~/.zshrc && echo '✅ 配置加载成功'"
}

# 查看配置内容
view_config() {
    print_header "查看配置内容"
    
    if [[ ! -f ~/.zshrc ]]; then
        print_message $RED "❌ ~/.zshrc 不存在"
        return 1
    fi
    
    echo "~/.zshrc 内容："
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    cat -n ~/.zshrc
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# 显示帮助
show_help() {
    echo "终端配置管理脚本"
    echo
    echo "用法: $0 [选项]"
    echo
    echo "选项:"
    echo "  status          显示当前配置状态"
    echo "  default         恢复默认配置"
    echo "  apply [文件]    应用自定义配置"
    echo "  test            测试当前配置"
    echo "  view            查看配置内容"
    echo "  help            显示帮助信息"
    echo
    echo "示例:"
    echo "  $0 status                    # 查看当前状态"
    echo "  $0 default                   # 恢复默认配置"
    echo "  $0 apply simple_prompt.zsh   # 应用简化配置"
    echo "  $0 test                      # 测试配置"
}

# 主函数
main() {
    case "${1:-status}" in
        status)
            show_current_status
            ;;
        default)
            restore_default
            ;;
        apply)
            apply_custom_config "$2"
            ;;
        test)
            test_config
            ;;
        view)
            view_config
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_message $RED "❌ 未知选项: $1"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
