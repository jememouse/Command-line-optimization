# =============================================================================
#                           实时命令联想补全配置
# =============================================================================

# -----------------------------------------------------------------------------
#                           1. 实时命令建议设置
# -----------------------------------------------------------------------------
# 加载自动建议插件
if [ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# 加载语法高亮插件
if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# -----------------------------------------------------------------------------
#                           2. 自动建议配置
# -----------------------------------------------------------------------------
# 建议策略配置
ZSH_AUTOSUGGEST_STRATEGY=(
    history          # 首先从历史记录中寻找建议
    completion       # 然后从补全系统中寻找建议
    match_prev_cmd  # 匹配上一个命令后经常使用的命令
)

# 建议外观配置
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#999999,underline"  # 建议的显示样式
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20                      # 建议的最大长度
ZSH_AUTOSUGGEST_USE_ASYNC=1                            # 异步加载建议
ZSH_AUTOSUGGEST_MANUAL_REBIND=1                        # 手动重新绑定

# -----------------------------------------------------------------------------
#                           3. 快捷键绑定
# -----------------------------------------------------------------------------
# 接受建议的快捷键
bindkey '^ ' autosuggest-accept              # Ctrl + Space 接受建议
bindkey '^f' autosuggest-accept              # Ctrl + f 接受建议
bindkey '^e' autosuggest-execute             # Ctrl + e 执行建议
bindkey '^n' autosuggest-next                # Ctrl + n 下一个建议
bindkey '^p' autosuggest-previous            # Ctrl + p 上一个建议
bindkey '^w' autosuggest-clear               # Ctrl + w 清除建议

# -----------------------------------------------------------------------------
#                           4. 智能历史记录搜索
# -----------------------------------------------------------------------------
# 上下键智能搜索
bindkey '^[[A' up-line-or-search            # 向上键搜索历史
bindkey '^[[B' down-line-or-search          # 向下键搜索历史

# 历史记录搜索优化
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=cyan,fg=white,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'
HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS='i'  # 忽略大小写

# -----------------------------------------------------------------------------
#                           5. 自定义联想函数
# -----------------------------------------------------------------------------
# 基于当前目录的命令联想
function suggest_from_current_dir() {
    local cmd="$1"
    local suggestions=()
    
    # 如果在 Git 仓库中
    if git rev-parse --git-dir > /dev/null 2>&1; then
        suggestions+=(
            "git status"
            "git pull"
            "git push"
            "git checkout"
            "git commit"
        )
    fi
    
    # 如果存在 package.json
    if [[ -f "package.json" ]]; then
        suggestions+=(
            "npm install"
            "npm start"
            "npm test"
            "npm run dev"
        )
    fi
    
    # 如果存在 requirements.txt
    if [[ -f "requirements.txt" ]]; then
        suggestions+=(
            "pip install -r requirements.txt"
            "python manage.py runserver"
            "python -m pytest"
        )
    fi
    
    # 如果存在 docker-compose.yml
    if [[ -f "docker-compose.yml" ]]; then
        suggestions+=(
            "docker-compose up"
            "docker-compose down"
            "docker-compose logs"
        )
    fi
    
    # 返回匹配的建议
    for suggestion in "${suggestions[@]}"; do
        if [[ "$suggestion" = "$cmd"* ]]; then
            echo "$suggestion"
            break
        fi
    done
}

# -----------------------------------------------------------------------------
#                           6. 智能补全增强
# -----------------------------------------------------------------------------
# 自动补全选项
setopt AUTO_LIST                  # 自动列出补全选项
setopt AUTO_MENU                  # 自动使用菜单补全
setopt COMPLETE_IN_WORD          # 在单词中间也能补全
setopt ALWAYS_TO_END             # 补全后光标移到末尾

# 补全样式
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# -----------------------------------------------------------------------------
#                           7. 命令建议回调
# -----------------------------------------------------------------------------
# 在每次命令执行前记录
function preexec_suggest() {
    # 记录命令到建议缓存
    echo "$1" >> ~/.zsh/command_suggestions
}

# 定期清理建议缓存
function cleanup_suggestions() {
    if [[ -f ~/.zsh/command_suggestions ]]; then
        # 保留最新的 1000 条建议
        tail -n 1000 ~/.zsh/command_suggestions > ~/.zsh/command_suggestions.tmp
        mv ~/.zsh/command_suggestions.tmp ~/.zsh/command_suggestions
    fi
}

# -----------------------------------------------------------------------------
#                           8. 测试函数
# -----------------------------------------------------------------------------
function test_suggestions() {
    echo "测试实时命令建议系统..."
    echo "请尝试以下操作："
    echo "1. 输入 'git' 并等待建议"
    echo "2. 在有 package.json 的目录中输入 'npm'"
    echo "3. 在有 requirements.txt 的目录中输入 'python'"
    echo "4. 使用以下快捷键："
    echo "   - Ctrl + Space: 接受建议"
    echo "   - Ctrl + f: 接受建议"
    echo "   - Ctrl + e: 执行建议"
    echo "   - Ctrl + n: 下一个建议"
    echo "   - Ctrl + p: 上一个建议"
    echo "   - Ctrl + w: 清除建议"
    echo "5. 使用上下方向键测试历史搜索"
}

# -----------------------------------------------------------------------------
#                           9. 初始化
# -----------------------------------------------------------------------------
# 创建必要的目录和文件
mkdir -p ~/.zsh
touch ~/.zsh/command_suggestions

# 添加到 preexec 钩子
autoload -U add-zsh-hook
add-zsh-hook preexec preexec_suggest

# 定期清理建议缓存
(cleanup_suggestions &)

# -----------------------------------------------------------------------------
#                           10. 使用说明
# -----------------------------------------------------------------------------
echo "实时命令联想补全系统已加载！"
echo "使用说明："
echo "1. 开始输入命令时会自动显示建议"
echo "2. 使用 Ctrl + Space 或 Ctrl + f 接受建议"
echo "3. 使用 Ctrl + e 直接执行建议"
echo "4. 使用 Ctrl + n/p 切换建议"
echo "5. 使用上下方向键搜索历史命令"
echo ""
echo "运行 'test_suggestions' 来测试系统"