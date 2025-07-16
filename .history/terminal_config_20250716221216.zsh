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

# ===== 性能优化和缓存 =====

# 缓存变量
typeset -g _PYTHON_VERSION_CACHE=""
typeset -g _PYTHON_VERSION_CACHE_TIME=0
typeset -g _GIT_INFO_CACHE=""
typeset -g _GIT_INFO_CACHE_TIME=0
typeset -g _CACHE_TIMEOUT=5  # 缓存5秒

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

# ===== 环境信息获取函数 =====

# 获取Python版本和环境信息（带缓存）
function get_python_version() {
    # 检查缓存
    if [[ -n "$_PYTHON_VERSION_CACHE" ]] && _is_cache_valid $_PYTHON_VERSION_CACHE_TIME; then
        echo "$_PYTHON_VERSION_CACHE"
        return
    fi

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
            python_version="未安装"
        fi
    fi

    # 更新缓存
    _PYTHON_VERSION_CACHE="$python_version"
    _PYTHON_VERSION_CACHE_TIME=$(_get_timestamp)

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
        # 检查工作区状态（异步检查以提高性能）
        if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
            git_status="${RED}*${RESET}"
        fi

        git_info=" ${ICON_GIT} ${branch}${git_status}"
    fi

    # 更新缓存
    _GIT_INFO_CACHE="$git_info"
    _GIT_INFO_CACHE_TIME=$(_get_timestamp)

    echo "$git_info"
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
    echo "${GREEN}🐍 Python:${RESET} $(get_python_env_detail)"
    echo "${GREEN}   路径:${RESET} $(which python3 2>/dev/null || which python 2>/dev/null || echo '未找到')"

    # Python环境管理器
    if command -v pyenv &> /dev/null; then
        local pyenv_version=$(pyenv version-name 2>/dev/null)
        echo "${GREEN}🔧 pyenv:${RESET} $pyenv_version"
    fi

    # 虚拟环境
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "${GREEN}🔧 虚拟环境:${RESET} $(basename $VIRTUAL_ENV)"
        echo "${GREEN}   路径:${RESET} $VIRTUAL_ENV"
    fi

    # Conda环境
    if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
        echo "${GREEN}🅒 Conda环境:${RESET} $CONDA_DEFAULT_ENV"
        if command -v conda &> /dev/null; then
            local conda_version=$(conda --version 2>&1 | cut -d' ' -f2)
            echo "${GREEN}   版本:${RESET} $conda_version"
        fi
    fi

    # pipenv环境
    if [[ -n "$PIPENV_ACTIVE" ]]; then
        echo "${GREEN}📦 pipenv:${RESET} 已激活"
    fi

    # 开发环境
    if command -v node &> /dev/null; then
        echo "${GREEN}⚡ Node.js:${RESET} $(node --version)"
    fi

    if command -v go &> /dev/null; then
        echo "${GREEN}🐹 Go:${RESET} $(go version | awk '{print $3}')"
    fi

    # Git信息
    if command -v git &> /dev/null; then
        local git_version=$(git --version | cut -d' ' -f3)
        echo "${GREEN}📝 Git:${RESET} $git_version"

        if git rev-parse --git-dir > /dev/null 2>&1; then
            local branch=$(git branch --show-current 2>/dev/null)
            if [[ -n "$branch" ]]; then
                echo "${GREEN}🌿 分支:${RESET} $branch"
                # 显示Git状态
                local git_status=$(git status --porcelain 2>/dev/null)
                if [[ -n "$git_status" ]]; then
                    echo "${GREEN}   状态:${RESET} ${RED}有未提交的更改${RESET}"
                else
                    echo "${GREEN}   状态:${RESET} ${GREEN}工作区干净${RESET}"
                fi
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
    echo "   版本: $(get_python_env_detail)"
    echo "   路径: $(which python3 2>/dev/null || which python 2>/dev/null || echo '未找到')"

    # Python环境管理器详情
    if command -v pyenv &> /dev/null; then
        local pyenv_version=$(pyenv version-name 2>/dev/null)
        local pyenv_path=$(pyenv which python3 2>/dev/null || pyenv which python 2>/dev/null)
        echo "   🔧 pyenv版本: $pyenv_version"
        [[ -n "$pyenv_path" ]] && echo "   pyenv路径: $pyenv_path"
    fi

    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "   🔧 虚拟环境: $(basename $VIRTUAL_ENV)"
        echo "   虚拟环境路径: $VIRTUAL_ENV"
        echo "   Python解释器: $(which python3 2>/dev/null || which python 2>/dev/null)"
    fi

    if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
        echo "   🅒 Conda环境: $CONDA_DEFAULT_ENV"
        if command -v conda &> /dev/null; then
            echo "   Conda版本: $(conda --version 2>&1 | cut -d' ' -f2)"
            echo "   Conda路径: $(which conda)"
        fi
    fi

    if [[ -n "$PIPENV_ACTIVE" ]]; then
        echo "   📦 pipenv: 已激活"
        if command -v pipenv &> /dev/null; then
            echo "   pipenv版本: $(pipenv --version 2>/dev/null | cut -d' ' -f3)"
        fi
    fi

    # 显示pip信息
    if command -v pip3 &> /dev/null; then
        echo "   📦 pip3版本: $(pip3 --version | cut -d' ' -f2)"
    elif command -v pip &> /dev/null; then
        echo "   📦 pip版本: $(pip --version | cut -d' ' -f2)"
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

# 环境切换助手
function envswitch() {
    echo
    echo "${CYAN}🔄 环境切换助手${RESET}"
    echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"

    # 显示当前环境
    echo "${YELLOW}当前环境:${RESET}"
    echo "   🐍 Python: $(get_python_env_detail)"

    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "   🔧 虚拟环境: $(basename $VIRTUAL_ENV)"
    fi

    if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
        echo "   🅒 Conda环境: $CONDA_DEFAULT_ENV"
    fi
    echo

    # 显示可用选项
    echo "${YELLOW}可用操作:${RESET}"

    # pyenv选项
    if command -v pyenv &> /dev/null; then
        echo "${GREEN}pyenv版本管理:${RESET}"
        echo "   pyenvlist    - 查看所有Python版本"
        echo "   pyenvglobal  - 设置全局Python版本"
        echo "   pyenvlocal   - 设置本地Python版本"
        echo
    fi

    # 虚拟环境选项
    echo "${GREEN}虚拟环境管理:${RESET}"
    echo "   mkvenv <name>  - 创建虚拟环境"
    echo "   activate       - 激活虚拟环境"
    echo "   deactivate     - 退出虚拟环境"
    echo "   lsvenv         - 列出虚拟环境"
    echo

    # conda选项
    if command -v conda &> /dev/null; then
        echo "${GREEN}Conda环境管理:${RESET}"
        echo "   condalist        - 查看所有conda环境"
        echo "   condaactivate    - 激活conda环境"
        echo "   condadeactivate  - 退出conda环境"
        echo
    fi

    echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo
}

# 项目环境初始化助手
function initproject() {
    local project_name=${1:-$(basename $(pwd))}

    echo
    echo "${CYAN}🚀 项目环境初始化: ${project_name}${RESET}"
    echo "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"

    # 检查是否在Git仓库中
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "${YELLOW}初始化Git仓库...${RESET}"
        git init
        echo "# ${project_name}" > README.md
        echo ".venv/" > .gitignore
        echo "__pycache__/" >> .gitignore
        echo "*.pyc" >> .gitignore
        git add .
        git commit -m "Initial commit"
        echo "${GREEN}✅ Git仓库已初始化${RESET}"
    fi

    # 创建Python虚拟环境
    if [[ ! -d ".venv" && ! -d "venv" ]]; then
        echo "${YELLOW}创建Python虚拟环境...${RESET}"
        python3 -m venv .venv
        echo "${GREEN}✅ 虚拟环境已创建${RESET}"

        echo "${YELLOW}激活虚拟环境...${RESET}"
        source .venv/bin/activate
        echo "${GREEN}✅ 虚拟环境已激活${RESET}"

        # 升级pip
        echo "${YELLOW}升级pip...${RESET}"
        pip install --upgrade pip
        echo "${GREEN}✅ pip已升级${RESET}"
    else
        echo "${GREEN}✅ 虚拟环境已存在${RESET}"
    fi

    # 创建requirements.txt（如果不存在）
    if [[ ! -f "requirements.txt" ]]; then
        echo "${YELLOW}创建requirements.txt...${RESET}"
        touch requirements.txt
        echo "${GREEN}✅ requirements.txt已创建${RESET}"
    fi

    echo
    echo "${GREEN}🎉 项目环境初始化完成！${RESET}"
    echo "${CYAN}下一步:${RESET}"
    echo "   1. 激活虚拟环境: source .venv/bin/activate"
    echo "   2. 安装依赖: pip install -r requirements.txt"
    echo "   3. 开始开发！"
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

# Python环境管理
alias pyversion='get_python_env_detail'
alias pypath='which python3 2>/dev/null || which python 2>/dev/null'
alias pyinfo='python3 -c "import sys; print(f\"Python {sys.version}\nPath: {sys.executable}\")"'

# 虚拟环境快捷操作
alias mkvenv='python3 -m venv'
alias rmvenv='rm -rf'
alias lsvenv='ls -la | grep "^d.*venv\|^d.*env\|^d.*\.venv"'

# conda相关（如果安装了conda）
if command -v conda &> /dev/null; then
    alias condainfo='conda info'
    alias condalist='conda env list'
    alias condaactivate='conda activate'
    alias condadeactivate='conda deactivate'
fi

# pyenv相关（如果安装了pyenv）
if command -v pyenv &> /dev/null; then
    alias pyenvlist='pyenv versions'
    alias pyenvglobal='pyenv global'
    alias pyenvlocal='pyenv local'
    alias pyenvinstall='pyenv install'
fi

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
    echo "${YELLOW}💡 环境信息命令:${RESET}"
    echo "   ${GREEN}quickenv${RESET}     - 显示快速环境信息"
    echo "   ${GREEN}fullenv${RESET}      - 显示完整环境信息"
    echo "   ${GREEN}envswitch${RESET}    - 环境切换助手"
    echo "   ${GREEN}initproject${RESET}  - 项目环境初始化"
    echo
    echo "${YELLOW}💡 Python快捷命令:${RESET}"
    echo "   ${GREEN}py${RESET}           - Python3 快捷方式"
    echo "   ${GREEN}pyversion${RESET}    - 显示Python版本详情"
    echo "   ${GREEN}pypath${RESET}       - 显示Python路径"
    echo "   ${GREEN}pyinfo${RESET}       - 显示Python详细信息"
    echo "   ${GREEN}mkvenv${RESET}       - 创建虚拟环境"
    echo "   ${GREEN}activate${RESET}     - 激活虚拟环境"
    echo "   ${GREEN}lsvenv${RESET}       - 列出虚拟环境"
    echo
    echo "${YELLOW}💡 增强功能:${RESET}"
    echo "   • 支持 pyenv、conda、pipenv 环境管理"
    echo "   • 自动检测 Node.js、Go、Rust 开发环境"
    echo "   • 智能缓存，提升响应速度"
    echo "   • Git状态实时显示"
    echo
}

# 只在交互式shell中显示欢迎信息
[[ $- == *i* ]] && show_welcome

echo "${GREEN}🔧 现代化终端配置已加载！${RESET}"
