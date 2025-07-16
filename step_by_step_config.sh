#!/bin/bash
# =============================================================================
# 终端命令行优化 - 分步配置脚本
# 描述: 一步一步配置终端命令行信息显示
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

print_step() {
    echo
    print_message $CYAN "🔧 $1"
    echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# 等待用户确认
wait_for_user() {
    echo
    read -p "按 Enter 键继续，或按 Ctrl+C 退出..."
    echo
}

# 步骤1：检查当前环境
step1_check_environment() {
    print_step "步骤1：检查当前环境"
    
    echo "当前Shell: $SHELL"
    echo "Zsh版本: $ZSH_VERSION"
    echo "当前目录: $(pwd)"
    echo "Python版本: $(python3 --version 2>/dev/null || echo '未安装')"
    echo "Git版本: $(git --version 2>/dev/null || echo '未安装')"
    
    if command -v pyenv &> /dev/null; then
        echo "pyenv版本: $(pyenv --version)"
        echo "当前pyenv Python: $(pyenv version-name)"
    else
        echo "pyenv: 未安装"
    fi
    
    if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
        echo "Conda环境: $CONDA_DEFAULT_ENV"
    else
        echo "Conda环境: 未激活"
    fi
    
    wait_for_user
}

# 步骤2：备份现有配置
step2_backup_config() {
    print_step "步骤2：备份现有配置"
    
    local backup_time=$(date +%Y%m%d_%H%M%S)
    
    if [[ -f ~/.zshrc ]]; then
        cp ~/.zshrc ~/.zshrc.backup.$backup_time
        print_message $GREEN "✅ 已备份 ~/.zshrc 到 ~/.zshrc.backup.$backup_time"
    else
        print_message $YELLOW "⚠️  ~/.zshrc 不存在"
    fi
    
    wait_for_user
}

# 步骤3：测试配置文件
step3_test_config() {
    print_step "步骤3：测试配置文件语法"
    
    if zsh -n terminal_config.zsh; then
        print_message $GREEN "✅ 配置文件语法正确"
    else
        print_message $RED "❌ 配置文件语法错误"
        exit 1
    fi
    
    wait_for_user
}

# 步骤4：添加配置到.zshrc
step4_add_config() {
    print_step "步骤4：添加配置到.zshrc"
    
    local config_line="source $(pwd)/terminal_config.zsh"
    
    # 检查是否已经添加
    if grep -q "terminal_config.zsh" ~/.zshrc 2>/dev/null; then
        print_message $YELLOW "⚠️  配置已存在于 ~/.zshrc"
    else
        echo "" >> ~/.zshrc
        echo "# 终端命令行优化配置" >> ~/.zshrc
        echo "$config_line" >> ~/.zshrc
        print_message $GREEN "✅ 已添加配置到 ~/.zshrc"
    fi
    
    wait_for_user
}

# 步骤5：测试新配置
step5_test_new_config() {
    print_step "步骤5：测试新配置"
    
    print_message $YELLOW "现在将在新的zsh会话中测试配置..."
    print_message $CYAN "您将看到新的提示符和功能"
    
    wait_for_user
    
    # 启动新的zsh会话来测试
    print_message $GREEN "启动新的zsh会话进行测试..."
    zsh -c "
        echo '=== 测试新配置 ==='
        echo '当前Python版本:'
        get_python_env_detail 2>/dev/null || echo '函数未加载'
        echo
        echo '测试quickenv命令:'
        quickenv 2>/dev/null || echo '命令未找到'
        echo
        echo '如果看到上述信息，说明配置成功！'
        echo '按 Ctrl+D 退出测试会话'
        exec zsh
    "
}

# 步骤6：完成配置
step6_complete() {
    print_step "步骤6：配置完成"
    
    print_message $GREEN "🎉 终端命令行优化配置完成！"
    echo
    print_message $CYAN "现在您可以使用以下命令："
    echo "  quickenv     - 快速环境信息"
    echo "  fullenv      - 完整环境信息"
    echo "  envswitch    - 环境切换助手"
    echo "  pyversion    - Python版本详情"
    echo "  pypath       - Python路径"
    echo "  pyinfo       - Python详细信息"
    echo
    print_message $YELLOW "要在新终端中使用，请运行："
    echo "  source ~/.zshrc"
    echo
    print_message $YELLOW "或者重新打开终端窗口"
}

# 主函数
main() {
    print_message $CYAN "🚀 终端命令行优化 - 分步配置"
    print_message $BLUE "本脚本将一步一步帮您配置终端命令行信息显示"
    echo
    
    step1_check_environment
    step2_backup_config
    step3_test_config
    step4_add_config
    step5_test_new_config
    step6_complete
}

# 运行主函数
main
