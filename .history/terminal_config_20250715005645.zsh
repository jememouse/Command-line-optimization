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

