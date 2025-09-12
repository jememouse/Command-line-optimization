# =============================================================================
#                           命令自动补全配置
# =============================================================================

# -----------------------------------------------------------------------------
#                           1. 基础补全设置
# -----------------------------------------------------------------------------
# 加载补全系统
autoload -Uz compinit && compinit
zmodload zsh/complist

# 基础补全选项
setopt COMPLETE_IN_WORD     # 在单词中间也能补全
setopt ALWAYS_TO_END       # 补全后光标移到末尾
setopt AUTO_MENU           # 展示菜单补全
setopt AUTO_LIST          # 自动列出补全选项
setopt AUTO_PARAM_SLASH   # 目录补全时自动加上斜杠
setopt NO_BEEP           # 补全时不发出蜂鸣声

# -----------------------------------------------------------------------------
#                           2. 补全样式设置
# -----------------------------------------------------------------------------
# 漂亮的补全菜单
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# 补全时忽略大小写
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-Z}'

# 补全缓存
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# 补全提示信息
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- 没有匹配项 --%f'
zstyle ':completion:*:corrections' format '%F{green}-- %d (errors: %e) --%f'

# -----------------------------------------------------------------------------
#                           3. 命令特定补全
# -----------------------------------------------------------------------------
# Git 补全
if [[ -f /usr/local/share/zsh/site-functions/_git ]]; then
    zstyle ':completion:*:*:git:*' script /usr/local/share/zsh/site-functions/_git
fi
zstyle ':completion:*:git-*' group-name 'git 命令'

# SSH 主机补全
zstyle ':completion:*:ssh:*' hosts on

# Kill 进程补全
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# -----------------------------------------------------------------------------
#                           4. 自定义补全函数
# -----------------------------------------------------------------------------
# Python 虚拟环境补全
function _python_venv() {
    local venvs
    venvs=($(ls ~/.virtualenvs 2>/dev/null))
    _describe 'virtualenv' venvs
}

# Node 版本补全
function _node_version() {
    local versions
    versions=($(ls ~/.nvm/versions/node 2>/dev/null | grep 'v' | sed 's/v//'))
    _describe 'node version' versions
}

# Docker 容器补全
function _docker_containers() {
    local containers
    containers=($(docker ps --format "{{.Names}}" 2>/dev/null))
    _describe 'containers' containers
}

# -----------------------------------------------------------------------------
#                           5. 补全测试函数
# -----------------------------------------------------------------------------
function test_completion() {
    local test_type="$1"
    
    case "$test_type" in
        "git")
            echo "测试 Git 补全..."
            echo "输入 'git che' 然后按 TAB 键，应该显示 checkout 等选项"
            echo "git che"
            ;;
        "ssh")
            echo "测试 SSH 补全..."
            echo "输入 'ssh ' 然后按 TAB 键，应该显示可用的主机"
            echo "ssh "
            ;;
        "kill")
            echo "测试进程补全..."
            echo "输入 'kill ' 然后按 TAB 键，应该显示进程列表"
            echo "kill "
            ;;
        "venv")
            echo "测试虚拟环境补全..."
            echo "输入 'workon ' 然后按 TAB 键，应该显示可用的虚拟环境"
            echo "workon "
            ;;
        "all")
            test_completion git
            echo "\n按任意键继续..."
            read -k 1
            test_completion ssh
            echo "\n按任意键继续..."
            read -k 1
            test_completion kill
            echo "\n按任意键继续..."
            read -k 1
            test_completion venv
            ;;
        *)
            echo "可用的测试类型: git, ssh, kill, venv, all"
            ;;
    esac
}

# -----------------------------------------------------------------------------
#                           6. 别名和快捷方式
# -----------------------------------------------------------------------------
# 定义常用命令别名
alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -la'
alias grep='grep --color=auto'

# Git 快捷命令
alias g='git'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gst='git status'

# -----------------------------------------------------------------------------
#                           7. 注册补全
# -----------------------------------------------------------------------------
# 为自定义命令添加补全
compdef _python_venv workon
compdef _node_version nvm use
compdef _docker_containers docker

# -----------------------------------------------------------------------------
#                           8. 智能提示符
# -----------------------------------------------------------------------------
# 在提示符中显示补全提示
function completion_info() {
    if [[ -n $VIRTUAL_ENV ]]; then
        echo "(venv:$(basename $VIRTUAL_ENV))"
    fi
    if [[ -n $NVM_BIN ]]; then
        echo "(node:$(node -v 2>/dev/null))"
    fi
}

# 设置提示符
PROMPT='$(completion_info)%F{green}%n@%m%f:%F{blue}%~%f$ '

# -----------------------------------------------------------------------------
#                           9. 启动测试
# -----------------------------------------------------------------------------
echo "命令补全系统已加载完成！"
echo "可用的测试命令："
echo "  test_completion [类型]   - 测试特定类型的补全"
echo "  - 可用类型: git, ssh, kill, venv, all"
echo ""
echo "补全使用说明："
echo "  1. 使用 TAB 键触发补全"
echo "  2. 使用方向键或 TAB/Shift+TAB 在选项间导航"
echo "  3. 按 Enter 选择补全项"
echo "  4. 按 Esc 取消补全"
echo ""
echo "要测试补全系统，请运行："
echo "  test_completion all"