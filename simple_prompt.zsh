#!/bin/zsh
# =============================================================================
# 简化的终端提示符配置 - 实现您要求的样式
# 样式: ╭─👤 jiewang @MacBook-Pro 📁 ~/Documents/myproject 🌿 main* 🔧 myproject
#       ╰─🐍 Python 3.12.11 (pyenv) ⏰ 14:31:12
#       ❯
# =============================================================================

# 启用颜色和提示符替换
autoload -U colors && colors
setopt PROMPT_SUBST

# 定义颜色
local RED="%{$fg[red]%}"
local GREEN="%{$fg[green]%}"
local YELLOW="%{$fg[yellow]%}"
local BLUE="%{$fg[blue]%}"
local MAGENTA="%{$fg[magenta]%}"
local CYAN="%{$fg[cyan]%}"
local GRAY="%{$fg[black]%}"
local RESET="%{$reset_color%}"

# 获取Python版本信息
get_python_info() {
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

    # 如果没有特殊环境，获取系统Python版本
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
        echo "$python_version ($python_manager)"
    else
        echo "$python_version"
    fi
}

# 获取Git信息
get_git_info() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        return
    fi

    local branch=$(git branch --show-current 2>/dev/null)
    local git_status=""

    if [[ -n "$branch" ]]; then
        # 检查是否有未提交的更改
        if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
            git_status="*"
        fi
        echo " 🌿 ${branch}${git_status}"
    fi
}

# 获取项目环境信息
get_project_info() {
    # Python虚拟环境
    if [[ -n "$VIRTUAL_ENV" ]]; then
        local venv_name=$(basename "$VIRTUAL_ENV")
        echo " 🔧 ${venv_name}"
    # Conda环境
    elif [[ -n "$CONDA_DEFAULT_ENV" && "$CONDA_DEFAULT_ENV" != "base" ]]; then
        echo " 🔧 ${CONDA_DEFAULT_ENV}"
    # Git项目名
    elif git rev-parse --git-dir > /dev/null 2>&1; then
        local project_name=$(basename $(git rev-parse --show-toplevel 2>/dev/null))
        if [[ -n "$project_name" ]]; then
            echo " 🔧 ${project_name}"
        fi
    fi
}

# 获取目录信息
get_directory() {
    local current_dir="${PWD/#$HOME/~}"
    echo "📁 ${current_dir}"
}

# 获取时间
get_time() {
    echo "⏰ %D{%H:%M:%S}"
}

# 设置提示符
PROMPT='
${CYAN}╭─${RESET}${GREEN}👤 %n${RESET} ${BLUE}@%m${RESET} ${YELLOW}$(get_directory)${RESET}${MAGENTA}$(get_git_info)${RESET}${CYAN}$(get_project_info)${RESET}
${CYAN}╰─${RESET}${GREEN}🐍 Python $(get_python_info)${RESET} ${GRAY}$(get_time)${RESET}
${CYAN}❯${RESET} '

# 右侧提示符为空
RPROMPT=''

# 基本别名
alias ll='ls -alF'
alias la='ls -A'
alias py='python3'
alias gs='git status'

echo "${GREEN}✅ 简化提示符配置已加载！${RESET}"
echo "${CYAN}现在您应该看到如下样式的提示符：${RESET}"
echo "${CYAN}╭─👤 用户名 @主机名 📁 ~/目录 🌿 分支* 🔧 项目名${RESET}"
echo "${CYAN}╰─🐍 Python 版本 ⏰ 时间${RESET}"
echo "${CYAN}❯${RESET}"
