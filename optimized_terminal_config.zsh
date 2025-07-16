#!/bin/zsh
# =============================================================================
# 优化的终端命令行配置 - 实现指定样式
# 样式: ╭─👤 jiewang @MacBook-Pro 📁 ~/Documents/myproject 🌿 main* 🔧 myproject
#       ╰─🐍 Python 3.12.11 (pyenv) ⏰ 14:31:12
#       ❯
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
local ICON_VENV="🔧"

# ===== 缓存变量 =====
typeset -g _PYTHON_VERSION_CACHE=""
typeset -g _PYTHON_VERSION_CACHE_TIME=0
typeset -g _GIT_INFO_CACHE=""
typeset -g _GIT_INFO_CACHE_TIME=0
typeset -g _CACHE_TIMEOUT=5

# 获取当前时间戳
function _get_timestamp() {
    date +%s
}

# 检查缓存是否有效
function _is_cache_valid() {
    local cache_time=$1
    local current_time=$(_get_timestamp)
    [[ $((current_time - cache_time)) -lt $_CACHE_TIMEOUT ]]
}

# ===== 核心信息获取函数 =====

# 获取Python版本和环境信息（带缓存）
function get_python_version() {
    # 检查缓存
    if [[ -n "$_PYTHON_VERSION_CACHE" ]] && _is_cache_valid $_PYTHON_VERSION_CACHE_TIME; then
        echo "$_PYTHON_VERSION_CACHE"
        return
    fi

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
            python_version="未安装"
        fi
        python_manager="system"
    fi

    # 格式化输出
    if [[ -n "$python_manager" && "$python_manager" != "system" ]]; then
        _PYTHON_VERSION_CACHE="$python_version ($python_manager)"
    else
        _PYTHON_VERSION_CACHE="$python_version"
    fi
    
    _PYTHON_VERSION_CACHE_TIME=$(_get_timestamp)
    echo "$_PYTHON_VERSION_CACHE"
}

# 获取Git分支和状态（带缓存）
function get_git_info() {
    # 检查是否在Git仓库中
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        return
    fi

    # 检查缓存
    if [[ -n "$_GIT_INFO_CACHE" ]] && _is_cache_valid $_GIT_INFO_CACHE_TIME; then
        echo "$_GIT_INFO_CACHE"
        return
    fi

    local branch=$(git branch --show-current 2>/dev/null)
    local git_status=""
    local git_info=""

    if [[ -n "$branch" ]]; then
        # 检查工作区状态
        if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
            git_status="*"
        fi

        git_info=" ${ICON_GIT} ${branch}${git_status}"
    fi

    # 更新缓存
    _GIT_INFO_CACHE="$git_info"
    _GIT_INFO_CACHE_TIME=$(_get_timestamp)

    echo "$git_info"
}

# 获取虚拟环境或项目信息
function get_project_env() {
    local env_info=""

    # Python虚拟环境
    if [[ -n "$VIRTUAL_ENV" ]]; then
        local venv_name=$(basename "$VIRTUAL_ENV")
        env_info=" ${ICON_VENV} ${venv_name}"
    # Conda环境
    elif [[ -n "$CONDA_DEFAULT_ENV" && "$CONDA_DEFAULT_ENV" != "base" ]]; then
        env_info=" ${ICON_VENV} ${CONDA_DEFAULT_ENV}"
    # 如果没有虚拟环境，但在Git仓库中，显示项目名
    elif git rev-parse --git-dir > /dev/null 2>&1; then
        local project_name=$(basename $(git rev-parse --show-toplevel 2>/dev/null))
        if [[ -n "$project_name" ]]; then
            env_info=" ${ICON_VENV} ${project_name}"
        fi
    fi

    echo "$env_info"
}

# 获取目录信息
function get_directory_info() {
    local current_dir="${PWD/#$HOME/~}"
    echo "${ICON_FOLDER} ${current_dir}"
}

# 获取当前时间
function get_time() {
    echo "${ICON_TIME} %D{%H:%M:%S}"
}

# ===== 命令行提示符配置 =====
setopt PROMPT_SUBST
setopt PROMPT_PERCENT

# 主提示符 - 实现您要求的样式
PROMPT='
${CYAN}╭─${RESET}${GREEN}${ICON_USER} %n${RESET} ${BLUE}@%m${RESET} ${YELLOW}$(get_directory_info)${RESET}${MAGENTA}$(get_git_info)${RESET}${CYAN}$(get_project_env)${RESET}
${CYAN}╰─${RESET}${GREEN}${ICON_PYTHON} Python $(get_python_version)${RESET} ${GRAY}$(get_time)${RESET}
${CYAN}❯${RESET} '

# 右侧提示符为空，保持简洁
RPROMPT=''

# ===== 实用别名 =====
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias py='python3'
alias pip='pip3'

# Python环境管理
alias pyversion='get_python_version'
alias pypath='which python3 2>/dev/null || which python 2>/dev/null'

# Git相关
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline -10'

# ===== 历史记录配置 =====
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# ===== 其他有用的选项 =====
setopt AUTO_CD
setopt CORRECT
setopt EXTENDED_GLOB
setopt NO_BEEP

# ===== 自动补全 =====
autoload -Uz compinit
compinit -i

echo "${GREEN}✅ 优化的终端配置已加载！${RESET}"
