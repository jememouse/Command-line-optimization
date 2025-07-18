#!/bin/zsh
# =============================================================================
# 增强版暗黑主题终端配置 - 专为深色背景优化
# 特点：高对比度、护眼配色、专业外观、适配深灰色背景
# 优化：针对深灰色、炭黑色等舒适的深色背景进行颜色调优
# 推荐背景：#1e1e1e (深灰)、#2d2d2d (炭黑)、#282828 (暖灰)
# =============================================================================

# 检查是否在 zsh 中运行
if [[ -z "$ZSH_VERSION" ]]; then
    echo "⚠️  警告: 此配置文件专为 zsh 设计"
    return 2>/dev/null || exit 1
fi

# 启用颜色和提示符替换
autoload -U colors && colors
setopt PROMPT_SUBST

# =============================================================================
# 深灰色背景专用颜色方案 - 针对舒适的深色背景精心调优
# 推荐背景：#1e1e1e、#2d2d2d、#282828 等深灰色调
# =============================================================================

# 主要元素颜色 - 使用适中对比度的明亮颜色，避免过于刺眼
local USER_COLOR="%{$fg_bold[cyan]%}"         # 用户名 - 亮青色（在深灰背景下醒目且舒适）
local HOST_COLOR="%{$fg_bold[blue]%}"         # 主机名 - 亮蓝色（稳定感，在深灰背景下清晰）
local PATH_COLOR="%{$fg_bold[yellow]%}"       # 路径 - 亮黄色（在深灰背景下对比度佳）
local GIT_COLOR="%{$fg_bold[green]%}"         # Git分支 - 亮绿色（活跃状态，在深灰背景下清晰）
local PROJECT_COLOR="%{$fg_bold[magenta]%}"   # 项目名 - 亮紫色（优雅且在深灰背景下突出）
local PYTHON_COLOR="%{$fg_bold[red]%}"        # Python版本 - 亮红色（重要信息，适中醒目）

# 辅助元素颜色 - 在深灰背景下保持清晰且舒适
local TIME_COLOR="%{$fg_bold[white]%}"        # 时间 - 亮白色（在深灰背景下清晰可见）
local FRAME_COLOR="%{$fg[cyan]%}"             # 框架线条 - 普通青色（柔和边框，不刺眼）
local PROMPT_COLOR="%{$fg_bold[green]%}"      # 命令提示符 - 亮绿色（就绪状态）
local SEPARATOR="%{$fg_bold[white]%}"         # 分隔符 - 亮白色（在深灰背景下清晰分隔）
local LABEL_COLOR="%{$fg[white]%}"            # 标签文字 - 白色（在深灰背景下清晰舒适）

# 状态指示颜色
local SUCCESS_COLOR="%{$fg_bold[green]%}"     # 成功状态 - 亮绿色
local WARNING_COLOR="%{$fg_bold[yellow]%}"    # 警告状态 - 亮黄色
local ERROR_COLOR="%{$fg_bold[red]%}"         # 错误状态 - 亮红色
local INFO_COLOR="%{$fg_bold[cyan]%}"         # 信息状态 - 亮青色

local RESET="%{$reset_color%}"

# =============================================================================
# 图标定义 - 使用Unicode符号增强视觉效果
# =============================================================================
local ICON_USER="👤"
local ICON_HOST="🖥️"
local ICON_FOLDER="📁"
local ICON_GIT="🌿"
local ICON_PYTHON="🐍"
local ICON_PROJECT="🔧"
local ICON_TIME="⏰"
local ICON_SUCCESS="✅"
local ICON_WARNING="⚠️"
local ICON_ERROR="❌"

# =============================================================================
# 性能优化缓存系统
# =============================================================================
typeset -g _PYTHON_VERSION_CACHE=""
typeset -g _PYTHON_VERSION_CACHE_TIME=0
typeset -g _GIT_INFO_CACHE=""
typeset -g _GIT_INFO_CACHE_TIME=0
typeset -g _CACHE_TIMEOUT=3  # 缓存3秒，平衡性能和实时性

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

# =============================================================================
# 核心信息获取函数
# =============================================================================

# 获取Git信息（带缓存和状态指示）
git_info() {
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
    local status_color="$GIT_COLOR"
    
    if [[ -n "$branch" ]]; then
        # 检查工作区状态
        if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
            git_status="*"
            status_color="$WARNING_COLOR"  # 有未提交更改时使用警告色
        fi
        
        _GIT_INFO_CACHE=" ${SEPARATOR}|${RESET} ${LABEL_COLOR}git${SEPARATOR}:${RESET}${status_color}${branch}${git_status}${RESET}"
    else
        _GIT_INFO_CACHE=""
    fi
    
    _GIT_INFO_CACHE_TIME=$(_get_timestamp)
    echo "$_GIT_INFO_CACHE"
}

# 获取Python版本信息（带缓存）
python_info() {
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

    # 获取Python版本
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
        _PYTHON_VERSION_CACHE="$python_version ${LABEL_COLOR}(${python_manager})${RESET}"
    else
        _PYTHON_VERSION_CACHE="$python_version"
    fi
    
    _PYTHON_VERSION_CACHE_TIME=$(_get_timestamp)
    echo "$_PYTHON_VERSION_CACHE"
}

# 获取项目信息
project_info() {
    local project_name=""
    
    # 优先显示虚拟环境名称
    if [[ -n "$VIRTUAL_ENV" ]]; then
        project_name=$(basename "$VIRTUAL_ENV")
        echo " ${SEPARATOR}|${RESET} ${LABEL_COLOR}env${SEPARATOR}:${RESET}${PROJECT_COLOR}${project_name}${RESET}"
    elif [[ -n "$CONDA_DEFAULT_ENV" && "$CONDA_DEFAULT_ENV" != "base" ]]; then
        echo " ${SEPARATOR}|${RESET} ${LABEL_COLOR}conda${SEPARATOR}:${RESET}${PROJECT_COLOR}${CONDA_DEFAULT_ENV}${RESET}"
    elif git rev-parse --git-dir > /dev/null 2>&1; then
        project_name=$(basename $(git rev-parse --show-toplevel 2>/dev/null))
        if [[ -n "$project_name" ]]; then
            echo " ${SEPARATOR}|${RESET} ${LABEL_COLOR}project${SEPARATOR}:${RESET}${PROJECT_COLOR}${project_name}${RESET}"
        fi
    fi
}

# =============================================================================
# 深灰背景优化的提示符 - 双行设计，舒适且专业
# =============================================================================
PROMPT='
${FRAME_COLOR}┌─${RESET} ${USER_COLOR}${ICON_USER} %n${RESET}${SEPARATOR}@${RESET}${HOST_COLOR}%m${RESET} ${LABEL_COLOR}in${RESET} ${PATH_COLOR}${ICON_FOLDER} %~${RESET}$(git_info)$(project_info)
${FRAME_COLOR}└─${RESET} ${PYTHON_COLOR}${ICON_PYTHON} Python $(python_info)${RESET} ${SEPARATOR}|${RESET} ${TIME_COLOR}${ICON_TIME} %D{%H:%M:%S}${RESET}
${PROMPT_COLOR}❯${RESET} '

# 右侧提示符为空，保持简洁
RPROMPT=''

# =============================================================================
# 实用别名和快捷命令
# =============================================================================
alias ll='ls -alF --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias py='python3'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline -10'
alias gd='git diff'

# =============================================================================
# 历史记录配置
# =============================================================================
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY

# =============================================================================
# 自动补全配置
# =============================================================================
autoload -Uz compinit
compinit -i

# =============================================================================
# 其他有用的选项
# =============================================================================
setopt AUTO_CD
setopt CORRECT
setopt EXTENDED_GLOB
setopt NO_BEEP

# =============================================================================
# 加载完成提示
# =============================================================================
echo "${SUCCESS_COLOR}${ICON_SUCCESS}${RESET} ${INFO_COLOR}增强版深灰背景主题终端配置已加载${RESET}"
echo "${INFO_COLOR}${ICON_SUCCESS}${RESET} ${LABEL_COLOR}专为深灰色背景优化的舒适颜色方案${RESET}"
echo "${INFO_COLOR}${ICON_SUCCESS}${RESET} ${LABEL_COLOR}推荐背景: #1e1e1e、#2d2d2d、#282828${RESET}"
