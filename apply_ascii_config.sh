#!/bin/bash

# 应用纯 ASCII 字符的 Powerlevel10k 配置，完全避免乱码

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    echo -e "${PURPLE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║          📝 应用纯 ASCII 字符配置 - 完全避免乱码              ║"
    echo "║                                                              ║"
    echo "║  特点:                                                       ║"
    echo "║  • 使用标准 ASCII 字符                                       ║"
    echo "║  • Python 版本显示: py3.13                                   ║"
    echo "║  • 虚拟环境显示: (venv_name)                                 ║"
    echo "║  • 提示符: >                                                 ║"
    echo "║  • 完全兼容所有终端和字体                                     ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_step() {
    echo -e "${BLUE}🔧 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

# 显示配置选项
show_config_options() {
    print_step "可用的配置选项"
    
    echo -e "${CYAN}📋 配置文件对比:${NC}"
    echo ""
    echo "1. 纯 ASCII 配置 (推荐)"
    echo "   文件: p10k_config_ascii_only.zsh"
    echo "   特点: 完全使用标准字符，零乱码风险"
    echo "   显示: ~/path main py3.13 (venv) >"
    echo ""
    echo "2. 简化配置"
    echo "   文件: p10k_config_simple.zsh"
    echo "   特点: 最简配置，基本功能"
    echo "   显示: ~/path py3.13 >"
    echo ""
    echo "3. 无图标配置"
    echo "   文件: p10k_config_no_icons.zsh"
    echo "   特点: 功能完整，无特殊图标"
    echo "   显示: ~/path main py3.13 (venv) >"
    echo ""
    echo "4. 修改后的原始配置"
    echo "   文件: p10k_config.zsh"
    echo "   特点: 原始功能，替换特殊字符"
    echo "   显示: ~/path main py3.13 (venv) >"
    echo ""
}

# 备份现有配置
backup_config() {
    print_step "备份现有配置"
    
    if [[ -f ~/.p10k.zsh ]]; then
        local backup_file="$HOME/.p10k.zsh.backup.ascii.$(date +%Y%m%d_%H%M%S)"
        cp ~/.p10k.zsh "$backup_file"
        print_success "已备份到: $backup_file"
    else
        print_info "未找到现有配置文件"
    fi
}

# 应用选择的配置
apply_config() {
    print_step "选择要应用的配置"
    
    echo "请选择配置:"
    echo "1. 纯 ASCII 配置 (推荐，完全避免乱码)"
    echo "2. 简化配置 (最简版本)"
    echo "3. 无图标配置 (功能完整)"
    echo "4. 修改后的原始配置"
    echo ""
    
    read -p "请选择 (1-4): " choice
    
    case $choice in
        1)
            if [[ -f p10k_config_ascii_only.zsh ]]; then
                cp p10k_config_ascii_only.zsh ~/.p10k.zsh
                print_success "已应用纯 ASCII 配置"
                config_name="纯 ASCII 配置"
            else
                echo -e "${RED}❌ 找不到 p10k_config_ascii_only.zsh${NC}"
                exit 1
            fi
            ;;
        2)
            if [[ -f p10k_config_simple.zsh ]]; then
                cp p10k_config_simple.zsh ~/.p10k.zsh
                print_success "已应用简化配置"
                config_name="简化配置"
            else
                echo -e "${RED}❌ 找不到 p10k_config_simple.zsh${NC}"
                exit 1
            fi
            ;;
        3)
            if [[ -f p10k_config_no_icons.zsh ]]; then
                cp p10k_config_no_icons.zsh ~/.p10k.zsh
                print_success "已应用无图标配置"
                config_name="无图标配置"
            else
                echo -e "${RED}❌ 找不到 p10k_config_no_icons.zsh${NC}"
                exit 1
            fi
            ;;
        4)
            if [[ -f p10k_config.zsh ]]; then
                cp p10k_config.zsh ~/.p10k.zsh
                print_success "已应用修改后的原始配置"
                config_name="修改后的原始配置"
            else
                echo -e "${RED}❌ 找不到 p10k_config.zsh${NC}"
                exit 1
            fi
            ;;
        *)
            echo -e "${RED}❌ 无效选择${NC}"
            exit 1
            ;;
    esac
    
    echo ""
    print_info "已应用: $config_name"
}

# 重新加载配置
reload_config() {
    print_step "重新加载配置"
    
    if [[ -n "$ZSH_VERSION" ]] && command -v p10k &> /dev/null; then
        if source ~/.p10k.zsh 2>/dev/null; then
            print_success "配置已重新加载"
        else
            print_info "请重启终端以应用配置"
        fi
        
        if p10k reload 2>/dev/null; then
            print_success "Powerlevel10k 已重新加载"
        fi
    else
        print_info "请重启终端或运行 'source ~/.zshrc'"
    fi
}

# 测试配置
test_config() {
    print_step "测试配置"
    
    echo -e "${CYAN}📋 测试字符显示:${NC}"
    echo ""
    echo "标准 ASCII 字符:"
    echo "  > $ # @ % & * + - = | \\ / ? ! ~ ^"
    echo ""
    echo "Python 版本格式:"
    echo "  py3.13"
    echo ""
    echo "虚拟环境格式:"
    echo "  (myenv)"
    echo ""
    echo "Conda 环境格式:"
    echo "  conda:data-science"
    echo ""
    echo "Git 状态格式:"
    echo "  main (clean)"
    echo "  main * (modified)"
    echo "  main ? (untracked)"
    echo ""
    
    read -p "以上字符是否正常显示？(y/n): " display_ok
    
    if [[ "$display_ok" == "y" ]]; then
        print_success "字符显示正常！"
    else
        echo -e "${YELLOW}⚠️  如果仍有显示问题，请检查终端编码设置${NC}"
    fi
}

# 显示使用说明
show_usage() {
    print_step "使用说明"
    
    echo -e "${CYAN}📋 配置效果预览:${NC}"
    echo ""
    echo "纯 ASCII 配置显示效果:"
    echo "  ~/project main py3.13 (venv) >"
    echo "  ~/project main py3.13 conda:data-science >"
    echo "  ~/project main * py3.13 >"
    echo ""
    
    echo -e "${CYAN}📋 字符说明:${NC}"
    echo "• py3.13      - Python 版本"
    echo "• (venv)      - 虚拟环境名称"
    echo "• conda:env   - Conda 环境"
    echo "• main        - Git 分支"
    echo "• *           - Git 有修改"
    echo "• ?           - Git 有未跟踪文件"
    echo "• >           - 命令提示符"
    echo ""
    
    echo -e "${CYAN}📋 管理命令:${NC}"
    echo "• 重新加载配置: source ~/.p10k.zsh"
    echo "• 重新加载 p10k: p10k reload"
    echo "• 重新配置: p10k configure"
    echo "• 切换配置: 重新运行此脚本"
    echo ""
}

# 创建测试脚本
create_test_script() {
    print_step "创建测试脚本"
    
    cat > test_ascii_display.sh << 'EOF'
#!/bin/bash

# 测试纯 ASCII 字符显示

echo "🧪 纯 ASCII 字符显示测试"
echo "========================"
echo ""

echo "1. 标准 ASCII 字符:"
echo "   > $ # @ % & * + - = | \\ / ? ! ~ ^"
echo ""

echo "2. Python 相关显示:"
echo "   py3.13"
echo "   (myenv)"
echo "   conda:data-science"
echo ""

echo "3. Git 状态显示:"
echo "   main"
echo "   main *"
echo "   main ?"
echo ""

echo "4. 完整提示符示例:"
echo "   ~/project main py3.13 (venv) >"
echo "   ~/project main * py3.13 conda:data >"
echo ""

echo "所有字符都是标准 ASCII，应该在任何终端中正常显示。"
echo ""

if [[ -f ~/.p10k.zsh ]]; then
    echo "✅ 配置文件存在"
    
    if grep -q "py\${P9K_CONTENT}" ~/.p10k.zsh; then
        echo "✅ Python 版本配置正确"
    fi
    
    if grep -q "(\${P9K_CONTENT})" ~/.p10k.zsh; then
        echo "✅ 虚拟环境配置正确"
    fi
else
    echo "❌ 配置文件不存在"
fi

echo ""
echo "💡 如果提示符没有显示 Python 版本，请重启终端"
EOF
    
    chmod +x test_ascii_display.sh
    print_success "测试脚本已创建: test_ascii_display.sh"
}

# 主函数
main() {
    print_header
    
    echo "🔧 开始应用纯 ASCII 字符配置..."
    echo ""
    
    show_config_options
    backup_config
    apply_config
    reload_config
    test_config
    show_usage
    create_test_script
    
    echo ""
    echo -e "${GREEN}🎉 纯 ASCII 字符配置已成功应用！${NC}"
    echo ""
    echo -e "${CYAN}📋 下一步操作:${NC}"
    echo "1. 重启终端或运行: source ~/.zshrc"
    echo "2. 测试显示: ./test_ascii_display.sh"
    echo "3. 如需调整: 重新运行此脚本"
    echo ""
    echo -e "${PURPLE}✨ 现在您的终端完全使用标准字符，不会有任何乱码！${NC}"
}

# 运行主函数
main "$@"
