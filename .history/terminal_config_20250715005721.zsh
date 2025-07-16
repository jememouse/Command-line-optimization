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

# 获取Python版本
function get_python_version() {
    if command -v python3 &> /dev/null; then
        python3 --version 2>&1 | cut -d' ' -f2
    elif command -v python &> /dev/null; then
        python --version 2>&1 | cut -d' ' -f2
    else
        echo "未安装"
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
    
    # Python虚拟环境
    if [[ -n "$VIRTUAL_ENV" ]]; then
        env_info="${ICON_VENV} $(basename $VIRTUAL_ENV)"
    fi
    
    # Conda环境
    if [[ -n "$CONDA_DEFAULT_ENV" && "$CONDA_DEFAULT_ENV" != "base" ]]; then
        if [[ -n "$env_info" ]]; then
            env_info="${env_info} ${ICON_CONDA} ${CONDA_DEFAULT_ENV}"
        else
            env_info="${ICON_CONDA} ${CONDA_DEFAULT_ENV}"
        fi
    fi
    
    [[ -n "$env_info" ]] && echo " ${env_info}"
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
${CYAN}╭─${RESET} ${GREEN}${ICON_USER} %n${RESET} ${BLUE}@%m${RESET} ${YELLOW}$(get_directory_info)${RESET}${MAGENTA}$(get_git_info)${RESET}${CYAN}$(get_virtual_env)${RESET}
${CYAN}╰─${RESET} ${GREEN}${ICON_PYTHON} Python $(get_python_version)${RESET} ${GRAY}$(get_time)${RESET}
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

