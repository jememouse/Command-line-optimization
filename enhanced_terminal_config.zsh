#!/bin/zsh
# =============================================================================
# 增强颜色的终端配置 - 使用更明显的颜色
# 优化：使用粗体、高亮色和更好的颜色搭配
# =============================================================================

# 启用颜色和提示符替换
autoload -U colors && colors
setopt PROMPT_SUBST

# 定义增强的颜色方案 - 更明显、更鲜艳
typeset -A color_scheme
color_scheme[user]="%F{46}"           # 亮绿色 - 用户名
color_scheme[host]="%F{33}"           # 亮蓝色 - 主机名
color_scheme[path]="%F{226}"          # 亮黄色 - 路径
color_scheme[git]="%F{201}"           # 亮紫红色 - Git信息
color_scheme[project]="%F{51}"        # 亮青色 - 项目信息
color_scheme[python]="%F{196}"        # 亮红色 - Python信息
color_scheme[time]="%F{255}"          # 亮白色 - 时间
color_scheme[frame]="%F{87}"          # 亮青色 - 框架
color_scheme[prompt]="%F{82}"         # 亮绿色 - 提示符
color_scheme[reset]="%f"              # 重置颜色

# 获取Git信息
git_info() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        local branch=$(git branch --show-current 2>/dev/null)
        local git_status=""
        if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
            git_status="*"
        fi
        if [[ -n "$branch" ]]; then
            echo " 🌿 ${branch}${git_status}"
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
                echo "$pyenv_version (pyenv)"
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
        echo " 🔧 $(basename $VIRTUAL_ENV)"
    elif git rev-parse --git-dir > /dev/null 2>&1; then
        local project=$(basename $(git rev-parse --show-toplevel 2>/dev/null))
        if [[ -n "$project" ]]; then
            echo " 🔧 $project"
        fi
    fi
}

# 设置增强颜色的提示符
PROMPT='
${color_scheme[frame]}╭─${color_scheme[reset]}${color_scheme[user]}👤 %n${color_scheme[reset]} ${color_scheme[host]}@%m${color_scheme[reset]} ${color_scheme[path]}📁 %~${color_scheme[reset]}${color_scheme[git]}$(git_info)${color_scheme[reset]}${color_scheme[project]}$(project_info)${color_scheme[reset]}
${color_scheme[frame]}╰─${color_scheme[reset]}${color_scheme[python]}🐍 Python $(python_info)${color_scheme[reset]} ${color_scheme[time]}⏰ %D{%H:%M:%S}${color_scheme[reset]}
${color_scheme[prompt]}❯${color_scheme[reset]} '

# 右侧提示符为空
RPROMPT=''

# 增强的别名
alias ll='ls -alF --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias py='python3'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline -10'

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
echo "${color_scheme[user]}✅ 增强颜色的终端配置已加载！${color_scheme[reset]}"
echo "${color_scheme[project]}🎨 现在使用更明显的256色彩显示${color_scheme[reset]}"
echo "${color_scheme[git]}🌈 颜色方案：用户(亮绿) 主机(亮蓝) 路径(亮黄) Git(紫红) 项目(青) Python(红) 时间(白)${color_scheme[reset]}"
