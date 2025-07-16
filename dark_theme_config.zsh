#!/bin/zsh
# =============================================================================
# 暗黑主题终端配置 - 专为深色背景优化
# 特点：高对比度、护眼、专业外观
# =============================================================================

# 启用颜色和提示符替换
autoload -U colors && colors
setopt PROMPT_SUBST

# 暗黑主题优化的颜色方案
# 选择在深色背景下对比度高、视觉舒适的颜色
local USER_COLOR="%{$fg_bold[cyan]%}"         # 用户名 - 亮青色（在暗背景下很醒目）
local HOST_COLOR="%{$fg_bold[blue]%}"         # 主机名 - 亮蓝色（稳定可靠）
local PATH_COLOR="%{$fg_bold[yellow]%}"       # 路径 - 亮黄色（暗背景下对比强烈）
local GIT_COLOR="%{$fg_bold[green]%}"         # Git - 亮绿色（表示活跃状态）
local PROJECT_COLOR="%{$fg_bold[magenta]%}"   # 项目 - 亮紫色（在暗背景下突出）
local PYTHON_COLOR="%{$fg_bold[red]%}"        # Python - 亮红色（重要信息）
local TIME_COLOR="%{$fg[white]%}"             # 时间 - 白色（暗背景下清晰）
local FRAME_COLOR="%{$fg[cyan]%}"             # 框架 - 普通青色（不抢夺注意力）
local PROMPT_COLOR="%{$fg_bold[green]%}"      # 提示符 - 亮绿色（表示就绪）
local SEPARATOR="%{$fg[white]%}"              # 分隔符 - 白色
local LABEL_COLOR="%{$fg[gray]%}"             # 标签 - 灰色（低调但可见）
local RESET="%{$reset_color%}"

# 获取Git信息
git_info() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        local branch=$(git branch --show-current 2>/dev/null)
        local git_status=""
        if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
            git_status="*"
        fi
        if [[ -n "$branch" ]]; then
            echo " ${SEPARATOR}|${RESET} ${LABEL_COLOR}git${SEPARATOR}:${RESET}${GIT_COLOR}${branch}${git_status}${RESET}"
        fi
    fi
}

# 获取Python版本信息
python_info() {
    if command -v python3 &> /dev/null; then
        local version=$(python3 --version 2>&1 | cut -d' ' -f2)
        if command -v pyenv &> /dev/null; then
            local pyenv_version=$(pyenv version-name 2>/dev/null)
            if [[ "$pyenv_version" != "system" ]]; then
                echo "$pyenv_version ${LABEL_COLOR}(pyenv)${RESET}"
                return
            fi
        fi
        echo "$version"
    else
        echo "未安装"
    fi
}

# 获取项目信息
project_info() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo " ${SEPARATOR}|${RESET} ${LABEL_COLOR}env${SEPARATOR}:${RESET}${PROJECT_COLOR}$(basename $VIRTUAL_ENV)${RESET}"
    elif git rev-parse --git-dir > /dev/null 2>&1; then
        local project=$(basename $(git rev-parse --show-toplevel 2>/dev/null))
        if [[ -n "$project" ]]; then
            echo " ${SEPARATOR}|${RESET} ${LABEL_COLOR}project${SEPARATOR}:${RESET}${PROJECT_COLOR}$project${RESET}"
        fi
    fi
}

# 暗黑主题优化的提示符
# 使用更柔和的框架颜色，突出重要信息
PROMPT='
${FRAME_COLOR}┌─${RESET} ${USER_COLOR}%n${RESET}${SEPARATOR}@${RESET}${HOST_COLOR}%m${RESET} ${LABEL_COLOR}in${RESET} ${PATH_COLOR}%~${RESET}$(git_info)$(project_info)
${FRAME_COLOR}└─${RESET} ${LABEL_COLOR}python${SEPARATOR}:${RESET}${PYTHON_COLOR}$(python_info)${RESET} ${SEPARATOR}|${RESET} ${TIME_COLOR}%D{%H:%M:%S}${RESET}
${PROMPT_COLOR}❯${RESET} '

# 右侧提示符为空
RPROMPT=''

# 实用别名
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias py='python3'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline -10'
alias gd='git diff'

# 历史记录配置
HISTFILE=~/.zsh_history
HISTSIZE=2000
SAVEHIST=2000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY

# 自动补全
autoload -Uz compinit
compinit -i

# 其他有用的选项
setopt AUTO_CD
setopt CORRECT
setopt EXTENDED_GLOB
setopt NO_BEEP

# 显示加载信息
echo "${USER_COLOR}✓${RESET} 暗黑主题终端配置已加载"
echo "${PROJECT_COLOR}●${RESET} 专为深色背景优化的颜色方案"
