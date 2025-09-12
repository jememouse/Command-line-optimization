# =============================================================================
#                           高级命令补全和环境管理配置
# =============================================================================

# -----------------------------------------------------------------------------
#                           1. 命令参数补全增强
# -----------------------------------------------------------------------------
# 加载补全系统
zmodload zsh/complist
autoload -U compinit && compinit

# 补全选项
setopt COMPLETE_IN_WORD    # 在单词中间也能补全
setopt AUTO_PARAM_SLASH    # 目录补全时自动加上斜杠
setopt AUTO_PARAM_KEYS     # 智能处理参数
setopt AUTO_LIST           # 自动列出补全列表
setopt LIST_TYPES         # 在文件补全时显示类型标记
setopt MENU_COMPLETE      # 第一次 TAB 就显示所有补全项

# 增强的补全样式
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# -----------------------------------------------------------------------------
#                           2. 自定义补全规则
# -----------------------------------------------------------------------------
# Git 补全增强
zstyle ':completion:*:git-checkout:*' sort false # 不对 git checkout 的补全结果排序
zstyle ':completion:*:descriptions' format '[%d]' # 更好的描述格式
zstyle ':completion:*:git-*' group-name "Git 命令" # Git 命令分组

# npm 补全增强
zstyle ':completion:*:npm:*' group-name "NPM 命令"
zstyle ':completion:*:npm-*' group-name "NPM 脚本"

# 文件补全增强
zstyle ':completion:*:*:*:*:files' ignored-patterns '*.o' '*.pyc' '__pycache__' # 忽略特定文件
zstyle ':completion:*:*:*:*:directories' ignored-patterns 'node_modules' '.git' # 忽略特定目录

# -----------------------------------------------------------------------------
#                           3. 项目特定补全
# -----------------------------------------------------------------------------
# Python 项目补全
function _python_completion() {
    local commands=(
        'run:运行 Python 脚本'
        'test:运行测试'
        'install:安装依赖'
        'venv:虚拟环境管理'
    )
    _describe 'command' commands
}
compdef _python_completion python

# Node.js 项目补全
function _node_completion() {
    local scripts
    if [[ -f package.json ]]; then
        scripts=($(cat package.json | jq -r '.scripts | keys[]' 2>/dev/null))
        _describe 'npm scripts' scripts
    fi
}
compdef _node_completion npm

# -----------------------------------------------------------------------------
#                           4. Python 虚拟环境管理
# -----------------------------------------------------------------------------
VENV_HOME="$HOME/.virtualenvs"

# 创建虚拟环境
function venv_create() {
    local venv_name="$1"
    local python_version="${2:-3}"
    
    if [[ -z "$venv_name" ]]; then
        echo "用法: venv_create <环境名称> [Python版本]"
        return 1
    fi
    
    mkdir -p "$VENV_HOME"
    python$python_version -m venv "$VENV_HOME/$venv_name"
    echo "✅ 虚拟环境 '$venv_name' 创建成功"
}

# 激活虚拟环境
function venv_activate() {
    local venv_name="$1"
    
    if [[ -z "$venv_name" ]]; then
        echo "用法: venv_activate <环境名称>"
        echo "可用环境:"
        ls "$VENV_HOME"
        return 1
    fi
    
    if [[ -d "$VENV_HOME/$venv_name" ]]; then
        source "$VENV_HOME/$venv_name/bin/activate"
        echo "✅ 已激活环境: $venv_name"
    else
        echo "❌ 环境不存在: $venv_name"
    fi
}

# 删除虚拟环境
function venv_remove() {
    local venv_name="$1"
    
    if [[ -z "$venv_name" ]]; then
        echo "用法: venv_remove <环境名称>"
        return 1
    fi
    
    if [[ -d "$VENV_HOME/$venv_name" ]]; then
        rm -rf "$VENV_HOME/$venv_name"
        echo "✅ 已删除环境: $venv_name"
    else
        echo "❌ 环境不存在: $venv_name"
    fi
}

# 列出所有虚拟环境
function venv_list() {
    echo "Python 虚拟环境列表:"
    if [[ -d "$VENV_HOME" ]]; then
        ls -1 "$VENV_HOME"
    else
        echo "没有找到虚拟环境"
    fi
}

# -----------------------------------------------------------------------------
#                           5. Node 版本管理
# -----------------------------------------------------------------------------
# NVM 配置
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # 加载 NVM
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # 加载补全

# Node 版本管理函数
function node_install() {
    local version="$1"
    if [[ -z "$version" ]]; then
        echo "用法: node_install <版本>"
        echo "例如: node_install 16"
        return 1
    fi
    nvm install "$version"
}

function node_use() {
    local version="$1"
    if [[ -z "$version" ]]; then
        echo "用法: node_use <版本>"
        nvm ls
        return 1
    fi
    nvm use "$version"
}

function node_remove() {
    local version="$1"
    if [[ -z "$version" ]]; then
        echo "用法: node_remove <版本>"
        nvm ls
        return 1
    fi
    nvm uninstall "$version"
}

# -----------------------------------------------------------------------------
#                           6. 环境快速切换
# -----------------------------------------------------------------------------
# 环境快速切换函数
function switch_env() {
    local env_type="$1"
    local env_name="$2"
    
    case "$env_type" in
        "python")
            venv_activate "$env_name"
            ;;
        "node")
            node_use "$env_name"
            ;;
        *)
            echo "支持的环境类型: python, node"
            echo "用法: switch_env <类型> <环境名>"
            ;;
    esac
}

# -----------------------------------------------------------------------------
#                           7. 环境变量自动加载
# -----------------------------------------------------------------------------
# 自动加载 .env 文件
function load_env() {
    local env_file=".env"
    if [[ -f "$env_file" ]]; then
        echo "📦 加载环境变量文件: $env_file"
        while IFS='=' read -r key value; do
            # 忽略注释和空行
            [[ $key == \#* ]] && continue
            [[ -z "$key" ]] && continue
            # 删除引号
            value=$(echo "$value" | sed -e 's/^"//' -e 's/"$//' -e "s/^'//" -e "s/'$//")
            export "$key=$value"
        done < "$env_file"
    fi
}

# 目录变更时自动加载环境变量
function auto_load_env() {
    load_env
}
chpwd_functions=(${chpwd_functions[@]} "auto_load_env")

# -----------------------------------------------------------------------------
#                           8. 环境信息显示
# -----------------------------------------------------------------------------
function show_current_env() {
    echo "\n当前环境信息:"
    echo "-------------------"
    
    # Python 环境
    if [[ -n "$VIRTUAL_ENV" ]]; then
        echo "Python 虚拟环境: $(basename $VIRTUAL_ENV)"
        echo "Python 版本: $(python --version 2>&1)"
    fi
    
    # Node 环境
    if command -v node &>/dev/null; then
        echo "Node 版本: $(node --version)"
        echo "NPM 版本: $(npm --version)"
    fi
    
    # 环境变量文件
    if [[ -f ".env" ]]; then
        echo "环境变量文件: 已加载"
    fi
    
    echo "-------------------"
}

# -----------------------------------------------------------------------------
#                           9. 补全定义
# -----------------------------------------------------------------------------
# 为自定义函数添加补全
compdef '_files -g "*.py"' python
compdef '_files -g "package.json"' npm
compdef '_files -g ".env"' load_env

# venv 命令补全
_venv_completion() {
    local curcontext="$curcontext" state line
    typeset -A opt_args

    _arguments \
        '1: :->command' \
        '2: :->argument'

    case $state in
        command)
            _arguments "1:command:(create activate remove list)"
            ;;
        argument)
            case $words[2] in
                activate|remove)
                    _values 'environments' $(ls $VENV_HOME)
                    ;;
            esac
            ;;
    esac
}
compdef _venv_completion venv_activate venv_remove

# switch_env 命令补全
_switch_env_completion() {
    local curcontext="$curcontext" state line
    typeset -A opt_args

    _arguments \
        '1: :->type' \
        '2: :->env'

    case $state in
        type)
            _arguments "1:type:(python node)"
            ;;
        env)
            case $words[2] in
                python)
                    _values 'environments' $(ls $VENV_HOME 2>/dev/null)
                    ;;
                node)
                    _values 'versions' $(nvm ls --no-colors | grep -o "v[0-9.]*" 2>/dev/null)
                    ;;
            esac
            ;;
    esac
}
compdef _switch_env_completion switch_env

# -----------------------------------------------------------------------------
#                           10. 提示符集成
# -----------------------------------------------------------------------------
# 在提示符中显示环境信息
function env_info_prompt() {
    local env_info=""
    
    # Python 虚拟环境
    if [[ -n "$VIRTUAL_ENV" ]]; then
        env_info+="(py:$(basename $VIRTUAL_ENV))"
    fi
    
    # Node 版本
    if command -v node &>/dev/null; then
        env_info+="(node:$(node -v | cut -c2-))"
    fi
    
    echo "$env_info"
}

# 集成到提示符
PROMPT='$(env_info_prompt)'$PROMPT

# 加载完成提示
echo "✨ 高级命令补全和环境管理功能已加载"
echo "📚 可用命令:"
echo "   - venv_create/activate/remove/list : Python 虚拟环境管理"
echo "   - node_install/use/remove : Node.js 版本管理"
echo "   - switch_env : 快速切换环境"
echo "   - show_current_env : 显示当前环境信息"