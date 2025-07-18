#!/bin/bash
# =============================================================================
# 深色主题终端配置安装脚本
# 功能：自动安装和配置深色背景优化的终端主题
# =============================================================================

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# 图标
ICON_SUCCESS="✅"
ICON_WARNING="⚠️"
ICON_ERROR="❌"
ICON_INFO="ℹ️"

echo -e "${CYAN}🎨 深灰背景主题终端配置安装程序${NC}"
echo -e "${BLUE}=================================${NC}"
echo

# 检查是否为zsh
if [[ "$SHELL" != *"zsh"* ]]; then
    echo -e "${ICON_WARNING} ${YELLOW}警告: 当前Shell不是zsh${NC}"
    echo -e "${WHITE}当前Shell: $SHELL${NC}"
    echo -e "${WHITE}建议切换到zsh以获得最佳体验${NC}"
    echo
    read -p "是否继续安装？(y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${ICON_ERROR} ${RED}安装已取消${NC}"
        exit 1
    fi
fi

# 备份现有配置
echo -e "${ICON_INFO} ${BLUE}备份现有配置...${NC}"
if [[ -f ~/.zshrc ]]; then
    cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S)
    echo -e "${ICON_SUCCESS} ${GREEN}已备份 ~/.zshrc${NC}"
else
    echo -e "${ICON_INFO} ${YELLOW}未找到现有的 ~/.zshrc 文件${NC}"
fi

# 获取当前脚本目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 检查配置文件是否存在
if [[ ! -f "$SCRIPT_DIR/enhanced_dark_theme.zsh" ]]; then
    echo -e "${ICON_ERROR} ${RED}错误: 找不到 enhanced_dark_theme.zsh 文件${NC}"
    exit 1
fi

echo -e "${ICON_INFO} ${BLUE}安装深色主题配置...${NC}"

# 创建或更新 .zshrc
cat >> ~/.zshrc << 'EOF'

# =============================================================================
# 深色主题终端配置 - 自动加载
# =============================================================================
EOF

echo "source \"$SCRIPT_DIR/enhanced_dark_theme.zsh\"" >> ~/.zshrc

echo -e "${ICON_SUCCESS} ${GREEN}配置已添加到 ~/.zshrc${NC}"

# 显示安装完成信息
echo
echo -e "${ICON_SUCCESS} ${GREEN}深灰背景主题终端配置安装完成！${NC}"
echo -e "${BLUE}=================================${NC}"
echo
echo -e "${WHITE}🎯 主要特性:${NC}"
echo -e "  ${GREEN}•${NC} 专为深灰色背景优化的舒适颜色方案"
echo -e "  ${GREEN}•${NC} 支持Git分支状态显示"
echo -e "  ${GREEN}•${NC} Python环境和版本信息"
echo -e "  ${GREEN}•${NC} 项目和虚拟环境检测"
echo -e "  ${GREEN}•${NC} 性能优化的缓存系统"
echo
echo -e "${WHITE}🚀 下一步操作:${NC}"
echo -e "  1. ${CYAN}重新启动终端${NC} 或运行 ${YELLOW}source ~/.zshrc${NC}"
echo -e "  2. ${CYAN}设置终端背景为深灰色${NC} (推荐: #1e1e1e, #2d2d2d, #282828)"
echo -e "  3. ${CYAN}享受优化后的终端体验！${NC}"
echo
echo -e "${WHITE}💡 推荐背景颜色:${NC}"
echo -e "  • ${CYAN}深灰色${NC}: #1e1e1e (护眼舒适)"
echo -e "  • ${CYAN}炭黑色${NC}: #2d2d2d (专业外观)"
echo -e "  • ${CYAN}暖灰色${NC}: #282828 (温和舒适)"
echo -e "  • 配置文件位置: $SCRIPT_DIR/enhanced_dark_theme.zsh"
echo
echo -e "${CYAN}感谢使用深灰背景主题终端配置！${NC}"
