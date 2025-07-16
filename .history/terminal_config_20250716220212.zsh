#!/bin/zsh
# =============================================================================
# 现代化终端命令行配置
# 描述: 提供美观、信息丰富的命令行提示符和环境显示
# 作者: Cline
# 版本: 2.0
# =============================================================================

# 检查是否在 zsh 中运行
if [[ -z "$ZSH_VERSION" ]]; then
    echo "⚠️  警告: 此配置文件专为 zsh 设计"
    return 2>/dev/null || exit 1
fi

# ===== 颜色定义 =====
autoload -U colors && colors

# 定义颜色变量
local RED="%{$fg[red]%}"
local GREEN="%{$fg[green]%}"
local YELLOW="%{$fg[yellow]%}"
local BLUE="%{$fg[blue]%}"
local MAGENTA="%{$fg[magenta]%}"
local CYAN="%{$fg[cyan]%}"
local WHITE="%{$fg[white]%}"
local GRAY="%{$fg[black]%}"
local RESET="%{$reset_color%}"

# ===== 图标和符号 =====
local ICON_PYTHON="🐍"
local ICON_GIT="🌿"
local ICON_FOLDER="📁"
local ICON_USER="👤"
local ICON_TIME="⏰"
local ICON_SYSTEM="🖥️"
local ICON_VENV="🔧"
local ICON_CONDA="🅒"
local ICON_SUCCESS="✅"
local ICON_ERROR="❌"
local ICON_ARROW="➤"

# ===== 环境信息获取函数 =====

# 获取Python版本和环境信息
function get_python_version() {
    local python_version=""
    local python_path=""

    # 检查pyenv
    if command -v pyenv &> /dev/null; then
        local pyenv_version=$(pyenv version-name 2>/dev/null)
        if [[ "$pyenv_version" != "system" ]]; then
            python_version="$pyenv_version (pyenv)"
            python_path=$(pyenv which python3 2>/dev/null || pyenv which python 2>/dev/null)
        fi
    fi

    # 如果没有pyenv或使用系统Python，检查常规Python
    if [[ -z "$python_version" ]]; then
        if command -v python3 &> /dev/null; then
            python_version=$(python3 --version 2>&1 | cut -d' ' -f2)
            python_path=$(which python3)
        elif command -v python &> /dev/null; then
            python_version=$(python --version 2>&1 | cut -d' ' -f2)
            python_path=$(which python)
        else
            echo "未安装"
            return
        fi
    fi

    echo "$python_version"
}

# 获取详细的Python环境信息
function get_python_env_detail() {
    local python_version=""
    local python_manager=""

    # 检查pyenv
    if command -v pyenv &> /dev/null; then
        local pyenv_version=$(pyenv version-name 2>/dev/null)
        if [[ "$pyenv_version" != "system" ]]; then
            python_version="$pyenv_version"
            python_manager="pyenv"
        fi
    fi

    # 检查conda
    if [[ -n "$CONDA_DEFAULT_ENV" && "$CONDA_DEFAULT_ENV" != "base" ]]; then
        if [[ -n "$python_manager" ]]; then
            python_manager="${python_manager}+conda"
        else
            python_manager="conda"
        fi
    fi

    # 检查虚拟环境
    if [[ -n "$VIRTUAL_ENV" ]]; then
        if [[ -n "$python_manager" ]]; then
            python_manager="${python_manager}+venv"
        else
            python_manager="venv"
        fi
    fi

    # 如果没有特殊环境管理器，获取系统Python版本
    if [[ -z "$python_version" ]]; then
        if command -v python3 &> /dev/null; then
            python_version=$(python3 --version 2>&1 | cut -d' ' -f2)
        elif command -v python &> /dev/null; then
            python_version=$(python --version 2>&1 | cut -d' ' -f2)
        else
            echo "未安装"
            return
        fi
        python_manager="system"
    fi

    if [[ -n "$python_manager" && "$python_manager" != "system" ]]; then
        echo "$python_version ($python_manager)"
    else
        echo "$python_version"
    fi
}

# 获取Git分支和状态
function get_git_info() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        local branch=$(git branch --show-current 2>/dev/null)
        local status=""
        
        # 检查工作区状态
        if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
            status="${RED}*${RESET}"
        fi
        
        if [[ -n "$branch" ]]; then
            echo " ${ICON_GIT} ${branch}${status}"
        fi
    fi
}

# 获取虚拟环境信息
function get_virtual_env() {
    local env_info=""
    local env_parts=()

    # Python虚拟环境
    if [[ -n "$VIRTUAL_ENV" ]]; then
        local venv_name=$(basename "$VIRTUAL_ENV")
        env_parts+=("${ICON_VENV} ${venv_name}")
    fi

    # Conda环境
    if [[ -n "$CONDA_DEFAULT_ENV" && "$CONDA_DEFAULT_ENV" != "base" ]]; then
        env_parts+=("${ICON_CONDA} ${CONDA_DEFAULT_ENV}")
    fi

    # pyenv环境
    if command -v pyenv &> /dev/null; then
        local pyenv_version=$(pyenv version-name 2>/dev/null)
        if [[ "$pyenv_version" != "system" && -z "$VIRTUAL_ENV" && -z "$CONDA_DEFAULT_ENV" ]]; then
            env_parts+=("🐍 ${pyenv_version}")
        fi
    fi

    # pipenv环境
    if [[ -n "$PIPENV_ACTIVE" ]]; then
        env_parts+=("📦 pipenv")
    fi

    # 组合环境信息
    if [[ ${#env_parts[@]} -gt 0 ]]; then
        env_info=$(IFS=' '; echo "${env_parts[*]}")
        echo " ${env_info}"
    fi
}

# 获取开发环境信息（Node.js, Go等）
function get_dev_env_info() {
    local dev_info=""
    local dev_parts=()

    # Node.js版本
    if command -v node &> /dev/null && [[ -f "package.json" || -f "node_modules" || -f ".nvmrc" ]]; then
        local node_version=$(node --version 2>/dev/null | sed 's/v//')
        if [[ -n "$node_version" ]]; then
            dev_parts+=("⚡ Node ${node_version}")
        fi
    fi

    # Go版本
    if command -v go &> /dev/null && [[ -f "go.mod" || -f "*.go" ]]; then
        local go_version=$(go version 2>/dev/null | awk '{print $3}' | sed 's/go//')
        if [[ -n "$go_version" ]]; then
            dev_parts+=("🐹 Go ${go_version}")
        fi
    fi

    # Rust版本
    if command -v rustc &> /dev/null && [[ -f "Cargo.toml" || -f "*.rs" ]]; then
        local rust_version=$(rustc --version 2>/dev/null | awk '{print $2}')
        if [[ -n "$rust_version" ]]; then
            dev_parts+=("🦀 Rust ${rust_version}")
        fi
    fi

    # 组合开发环境信息
    if [[ ${#dev_parts[@]} -gt 0 ]]; then
        dev_info=$(IFS=' '; echo "${dev_parts[*]}")
        echo " ${dev_info}"
    fi
}

# 获取系统信息
function get_system_info() {
    local os=$(uname -s)
    local arch=$(uname -m)
    echo "${ICON_SYSTEM} ${os} ${arch}"
}

# 获取当前时间
function get_time() {
    echo "${ICON_TIME} %D{%H:%M:%S}"
}

# 获取目录信息
function get_directory_info() {
    local current_dir="${PWD/#$HOME/~}"
    echo "${ICON_FOLDER} ${current_dir}"
}

# ===== 命令行提示符配置 =====
setopt PROMPT_SUBST
setopt PROMPT_PERCENT

# 主提示符 - 多行设计，信息丰富
PROMPT='
${CYAN}╭─${RESET} ${GREEN}${ICON_USER} %n${RESET} ${BLUE}@%m${RESET} ${YELLOW}$(get_directory_info)${RESET}${MAGENTA}$(get_git_info)${RESET}${CYAN}$(get_virtual_env)${RESET}$(get_dev_env_info)
${CYAN}╰─${RESET} ${GREEN}${ICON_PYTHON} Python $(get_python_env_detail)${RESET} ${GRAY}$(get_time)${RESET}
${CYAN}❯${RESET} '

# 右侧提示符 - 显示系统信息
RPROMPT='${GRAY}$(get_system_info)${RESET}'

# ===== 快速环境信息命令 =====

# 快速环境概览
function quickenv() {
    echo
    echo "${CYAN}⚡ 快速环境信息${RESET}"
    echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo "${GREEN}🖥️  系统:${RESET} $(uname -s) $(uname -r) ($(uname -m))"
    echo "${GREEN}📁 目录:${RESET} $(pwd)"
    echo "${GREEN}🐍 Python:${RESET} $(get_python_version)"
    echo "${GREEN}   路径:${RESET} $(which python3 2>/dev/null || which python 2>/dev/null || echo '未找到')"
    
    # 虚拟环境
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "${GREEN}🔧 虚拟环境:${RESET} $(basename $VIRTUAL_ENV)"
    else
        echo "${GREEN}🔧 虚拟环境:${RESET} 未激活"
    fi
    
    # Conda环境
    if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
        echo "${GREEN}🅒 Conda环境:${RESET} $CONDA_DEFAULT_ENV"
    fi
    
    # Git信息
    if command -v git &> /dev/null; then
        local git_version=$(git --version | cut -d' ' -f3)
        echo "${GREEN}📝 Git:${RESET} $git_version"
        
        if git rev-parse --git-dir > /dev/null 2>&1; then
            local branch=$(git branch --show-current 2>/dev/null)
            if [[ -n "$branch" ]]; then
                echo "${GREEN}🌿 分支:${RESET} $branch"
            fi
        fi
    fi
    
    echo "${GREEN}🐚 Shell:${RESET} Zsh $ZSH_VERSION"
    echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo
}

# 完整环境信息
function fullenv() {
    echo
    echo "${CYAN}🌟 完整环境信息${RESET}"
    echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    
    # 系统信息
    echo "${YELLOW}💻 系统信息:${RESET}"
    echo "   操作系统: $(uname -s)"
    echo "   内核版本: $(uname -r)"
    echo "   架构: $(uname -m)"
    echo "   主机名: $(hostname)"
    echo "   用户名: $(whoami)"
    echo
    
    # 目录信息
    echo "${YELLOW}📂 目录信息:${RESET}"
    echo "   当前目录: $(pwd)"
    echo "   家目录: $HOME"
    echo
    
    # Python环境
    echo "${YELLOW}🐍 Python环境:${RESET}"
    echo "   版本: $(get_python_version)"
    echo "   路径: $(which python3 2>/dev/null || which python 2>/dev/null || echo '未找到')"
    
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "   🔧 虚拟环境: $(basename $VIRTUAL_ENV)"
        echo "   虚拟环境路径: $VIRTUAL_ENV"
    else
        echo "   🔧 虚拟环境: 未激活"
    fi
    
    if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
        echo "   🅒 Conda环境: $CONDA_DEFAULT_ENV"
    fi
    
    if command -v pyenv &> /dev/null; then
        echo "   pyenv版本: $(pyenv version | cut -d' ' -f1)"
    fi
    echo
    
    # 开发工具
    echo "${YELLOW}🛠️  开发工具:${RESET}"
    local tools=("git" "node" "npm" "go" "rustc" "java" "docker" "conda")
    for tool in $tools; do
        if command -v $tool &> /dev/null; then
            case $tool in
                git) echo "   Git: $(git --version | cut -d' ' -f3)" ;;
                node) echo "   Node.js: $(node --version)" ;;
                npm) echo "   npm: $(npm --version)" ;;
                go) echo "   Go: $(go version | cut -d' ' -f3)" ;;
                rustc) echo "   Rust: $(rustc --version | cut -d' ' -f2)" ;;
                java) echo "   Java: $(java -version 2>&1 | head -n1 | cut -d'"' -f2)" ;;
                docker) echo "   Docker: $(docker --version | cut -d' ' -f3 | tr -d ',')" ;;
                conda) echo "   Conda: $(conda --version 2>&1 | cut -d' ' -f2-)" ;;
            esac
        fi
    done
    echo
    
    # Shell信息
    echo "${YELLOW}🐚 Shell信息:${RESET}"
    echo "   当前Shell: $SHELL"
    echo "   Zsh版本: $ZSH_VERSION"
    echo
    
    # 系统资源
    echo "${YELLOW}📊 系统资源:${RESET}"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "   CPU: $(sysctl -n machdep.cpu.brand_string)"
        echo "   内存: $(sysctl -n hw.memsize | awk '{print int($1/1024/1024/1024) "GB"}')"
    else
        if [[ -f /proc/cpuinfo ]]; then
            echo "   CPU: $(grep 'model name' /proc/cpuinfo | head -1 | cut -d':' -f2 | xargs)"
        fi
        if [[ -f /proc/meminfo ]]; then
            echo "   内存: $(grep MemTotal /proc/meminfo | awk '{print int($2/1024/1024) "GB"}')"
        fi
    fi
    
    # 磁盘使用
    echo "   磁盘使用:"
    df -h | grep -E '^/dev/' | awk '{print "     " $1 ": " $3 "/" $2 " (" $5 " 已使用)"}' | head -3
    echo
    
    echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo
}

# ===== 实用别名 =====

# 文件操作
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Python相关
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'
alias activate='source venv/bin/activate'
alias deactivate='deactivate 2>/dev/null || echo "没有激活的虚拟环境"'

# Git相关
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline -10'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

# 系统信息
alias sysinfo='uname -a'
alias diskinfo='df -h'
alias meminfo='vm_stat'  # macOS
alias cpuinfo='sysctl -n machdep.cpu.brand_string'  # macOS
alias ports='netstat -tuln'  # 查看端口
alias myip='curl -s ifconfig.me'  # 获取公网IP

# ===== 自动补全增强 =====
autoload -Uz compinit
compinit -i

# 补全样式
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

# ===== 历史记录配置 =====
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY

# ===== 其他有用的选项 =====
setopt AUTO_CD              # 自动切换目录
setopt CORRECT              # 命令纠错
setopt EXTENDED_GLOB        # 扩展通配符
setopt NO_BEEP              # 禁用蜂鸣声
setopt AUTO_LIST            # 自动列出选项
setopt AUTO_MENU            # 自动菜单补全
setopt COMPLETE_IN_WORD     # 在单词内补全

# ===== 欢迎信息 =====
function show_welcome() {
    echo
    echo "${CYAN}🌟 终端命令行已优化！${RESET}"
    echo "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo "${YELLOW}💡 可用命令:${RESET}"
    echo "   ${GREEN}quickenv${RESET}  - 显示快速环境信息"
    echo "   ${GREEN}fullenv${RESET}   - 显示完整环境信息"
    echo "   ${GREEN}py${RESET}        - Python3 快捷方式"
    echo "   ${GREEN}venv${RESET}      - 创建虚拟环境"
    echo "   ${GREEN}activate${RESET}  - 激活虚拟环境"
    echo
}

# 只在交互式shell中显示欢迎信息
[[ $- == *i* ]] && show_welcome

echo "${GREEN}🔧 现代化终端配置已加载！${RESET}"
