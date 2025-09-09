#!/bin/bash

# 测试纯 ASCII 字符显示

echo "🧪 纯 ASCII 字符显示测试"
echo "========================"
echo ""

echo "1. 标准 ASCII 字符:"
echo "   > $ # @ % & * + - = | \\ / ? ! ~ ^"
echo ""

echo "2. Python 相关显示:"
echo "   py3.13"
echo "   (myenv)"
echo "   conda:data-science"
echo ""

echo "3. Git 状态显示:"
echo "   main"
echo "   main *"
echo "   main ?"
echo ""

echo "4. 完整提示符示例:"
echo "   ~/project main py3.13 (venv) >"
echo "   ~/project main * py3.13 conda:data >"
echo ""

echo "所有字符都是标准 ASCII，应该在任何终端中正常显示。"
echo ""

if [[ -f ~/.p10k.zsh ]]; then
    echo "✅ 配置文件存在"
    
    if grep -q "py\${P9K_CONTENT}" ~/.p10k.zsh; then
        echo "✅ Python 版本配置正确"
    fi
    
    if grep -q "(\${P9K_CONTENT})" ~/.p10k.zsh; then
        echo "✅ 虚拟环境配置正确"
    fi
else
    echo "❌ 配置文件不存在"
fi

echo ""
echo "💡 如果提示符没有显示 Python 版本，请重启终端"
