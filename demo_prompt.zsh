#!/bin/zsh
# =============================================================================
# 演示脚本 - 展示您要求的命令行样式
# =============================================================================

# 启动一个新的zsh会话并应用配置
echo "🚀 启动演示 - 您要求的命令行样式"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 显示预期的样式
echo "📋 预期样式："
echo "╭─👤 jiewang @MacBook-Pro 📁 ~/Documents/myproject 🌿 main* 🔧 myproject"
echo "╰─🐍 Python 3.12.11 (pyenv) ⏰ 14:31:12"
echo "❯"
echo ""

echo "🔧 正在应用配置..."
echo ""

# 启动新的zsh会话并应用优化配置
exec zsh -c "
# 加载优化配置
source ./optimized_terminal_config.zsh

# 显示当前配置效果
echo '✅ 配置已应用！'
echo ''
echo '💡 测试命令：'
echo '  - echo \"Hello World\"'
echo '  - ls'
echo '  - git status (如果在Git仓库中)'
echo '  - pyversion'
echo ''
echo '🎯 当前提示符样式：'

# 启动交互式会话
exec zsh
"
