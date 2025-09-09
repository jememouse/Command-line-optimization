#!/bin/bash

# 终端命令行优化安装脚本
# 实现实时命令建议、智能补全、上下文感知等功能

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 打印函数
print_step() {
    echo -e "${BLUE}🔧 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

# 检查系统要求
check_requirements() {
    print_step "检查系统要求"
    
    # 检查操作系统
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "此脚本仅支持 macOS 系统"
        exit 1
    fi
    
    # 检查 Homebrew
    if ! command -v brew &> /dev/null; then
        print_warning "未检测到 Homebrew，正在安装..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    # 检查 Git
    if ! command -v git &> /dev/null; then
        print_error "需要安装 Git"
        exit 1
    fi
    
    print_success "系统要求检查完成"
}

# 安装必要工具
install_tools() {
    print_step "安装必要工具"
    
    # 更新 Homebrew
    brew update
    
    # 安装核心工具
    local tools=(
        "fzf"           # 模糊搜索
        "fd"            # 更好的 find
        "ripgrep"       # 更好的 grep  
        "bat"           # 更好的 cat
        "exa"           # 更好的 ls
        "zoxide"        # 智能 cd
        "thefuck"       # 命令纠错
        "tldr"          # 简化的 man 页面
        "tree"          # 目录树显示
        "htop"          # 系统监控
        "jq"            # JSON 处理
        "wget"          # 下载工具
    )
    
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            print_info "安装 $tool..."
            brew install "$tool"
        else
            print_info "$tool 已安装"
        fi
    done
    
    print_success "工具安装完成"
}

# 安装 Oh My Zsh
install_oh_my_zsh() {
    print_step "安装 Oh My Zsh"
    
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        print_info "下载并安装 Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        print_success "Oh My Zsh 安装完成"
    else
        print_info "Oh My Zsh 已安装"
    fi
}

# 安装 Zsh 插件
install_zsh_plugins() {
    print_step "安装 Zsh 插件"
    
    local ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
    
    # zsh-autosuggestions (实时命令建议)
    if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
        print_info "安装 zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    fi
    
    # zsh-syntax-highlighting (语法高亮)
    if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
        print_info "安装 zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    fi
    
    # zsh-completions (增强补全)
    if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]]; then
        print_info "安装 zsh-completions..."
        git clone https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"
    fi
    
    # zsh-history-substring-search (历史搜索)
    if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-history-substring-search" ]]; then
        print_info "安装 zsh-history-substring-search..."
        git clone https://github.com/zsh-users/zsh-history-substring-search "$ZSH_CUSTOM/plugins/zsh-history-substring-search"
    fi
    
    # you-should-use (别名提醒)
    if [[ ! -d "$ZSH_CUSTOM/plugins/you-should-use" ]]; then
        print_info "安装 you-should-use..."
        git clone https://github.com/MichaelAquilina/zsh-you-should-use "$ZSH_CUSTOM/plugins/you-should-use"
    fi
    
    print_success "Zsh 插件安装完成"
}

# 安装 Powerlevel10k 主题
install_powerlevel10k() {
    print_step "安装 Powerlevel10k 主题"
    
    local ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
    
    if [[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]]; then
        print_info "下载 Powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
        print_success "Powerlevel10k 安装完成"
    else
        print_info "Powerlevel10k 已安装"
    fi
}

# 主函数
main() {
    echo -e "${PURPLE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    终端命令行优化工具                          ║"
    echo "║                                                              ║"
    echo "║  功能特性:                                                    ║"
    echo "║  • 实时命令建议                                               ║"
    echo "║  • 智能参数补全                                               ║"
    echo "║  • 上下文感知提示                                             ║"
    echo "║  • 更好的视觉效果                                             ║"
    echo "║  • 命令记忆功能                                               ║"
    echo "║  • 智能历史搜索                                               ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
    
    check_requirements
    install_tools
    install_oh_my_zsh
    install_zsh_plugins
    install_powerlevel10k
    
    echo ""
    print_success "基础组件安装完成！"
    print_info "接下来将配置 .zshrc 文件..."
    echo ""
}

# 运行主函数
main "$@"
