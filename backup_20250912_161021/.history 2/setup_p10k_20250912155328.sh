#!/bin/zsh

echo "开始安装 Powerlevel10k 主题及相关配置..."

# 1. 检查并安装 Powerlevel10k
if [[ ! -d ~/powerlevel10k ]]; then
    echo "克隆 Powerlevel10k 仓库..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
fi

# 2. 创建基础的 p10k 配置
echo "创建 p10k 配置..."
cat > ~/.p10k.zsh << 'EOL'
# p10k 配置文件

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# 基础设置
typeset -g POWERLEVEL9K_MODE=nerdfont-complete
typeset -g POWERLEVEL9K_ICON_PADDING=none

# 提示符元素配置
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    dir                     # 当前目录
    vcs                    # Git 状态
    virtualenv             # Python 虚拟环境
    node_version           # Node.js 版本
    command_execution_time # 命令执行时间
    prompt_char           # 提示符
)

typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status                 # 命令状态
    time                  # 时间显示
)

# 目录设置
typeset -g POWERLEVEL9K_DIR_FOREGROUND=31
typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=103
typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=39

# Git 状态设置
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=76
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=178
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=39

# 提示符样式
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='❯'
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='❯'
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND=76
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND=196

# 时间显示格式
typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'

# 虚拟环境显示
typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=37
typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=true

# Node.js 版本显示
typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND=70
typeset -g POWERLEVEL9K_NODE_VERSION_PROJECT_ONLY=true

# 命令执行时间
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=101

# 状态显示
typeset -g POWERLEVEL9K_STATUS_OK=false
typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=196

# 分段样式
typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=''
typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=''
typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=' '
typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=' '

# 多行提示符
typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=""
typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=""
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX=""
typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_SUFFIX=""
typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX=""

# 瞬时提示符
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
EOL

# 3. 更新 .zshrc
echo "更新 .zshrc 配置..."
cat > ~/.zshrc << 'EOL'
# 加载 Powerlevel10k
source ~/powerlevel10k/powerlevel10k.zsh-theme

# 加载 p10k 配置
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# 加载命令补全配置
[[ -f ~/.zsh/completion_config.zsh ]] && source ~/.zsh/completion_config.zsh

# 加载命令联想配置
[[ -f ~/.zsh/suggestion_config.zsh ]] && source ~/.zsh/suggestion_config.zsh

# 基础配置
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# History 配置
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS

# 基本别名
alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -la'
EOL

# 4. 设置权限
echo "设置权限..."
chmod 644 ~/.p10k.zsh
chmod 644 ~/.zshrc

echo "安装完成！请执行以下操作："
echo "1. 重新打开终端"
echo "或"
echo "2. 运行: source ~/.zshrc"
echo ""
echo "如果字体显示不正常，请安装 Meslo Nerd Font 字体："
echo "可以从这里下载：https://github.com/romkatv/powerlevel10k#fonts"