# 📁 项目文件结构

## 🎯 核心配置文件

### Powerlevel10k 配置
- `p10k_config.zsh` - 主要的 Powerlevel10k 配置文件
- `p10k_config_ascii_only.zsh` - 纯 ASCII 字符版本（避免乱码）

### Shell 配置
- `enhanced_zshrc` - 增强的 zsh 配置文件
- `condarc_template` - Conda 配置模板

## 🛠️ 安装和配置脚本

### 主要脚本
- `setup_all.sh` - 一键安装和配置所有功能
- `apply_ascii_config.sh` - 应用纯 ASCII 配置
- `backup_configs.sh` - 备份现有配置文件

### 测试脚本
- `test_ascii_display.sh` - 测试 ASCII 字符显示

## 📚 文档

### 核心文档
- `README.md` - 项目主要说明文档
- `PROJECT_OVERVIEW.md` - 项目功能概览
- `TERMINAL_GUIDE.md` - 终端使用指南
- `PROJECT_STRUCTURE.md` - 本文件，项目结构说明

## 🎨 资源文件

### 字体
- `MesloLGS_NF_Regular.ttf` - Nerd Font 字体文件

### 项目标识
- `requirements.txt` - Python 项目标识文件

## 🎯 使用方法

### 快速开始
```bash
# 一键安装所有功能
./setup_all.sh

# 或者仅应用 ASCII 配置（避免乱码）
./apply_ascii_config.sh
```

### 测试配置
```bash
# 测试字符显示
./test_ascii_display.sh
```

### 备份配置
```bash
# 备份现有配置
./backup_configs.sh
```

## 📋 文件说明

| 文件 | 用途 | 重要性 |
|------|------|--------|
| `p10k_config.zsh` | 主配置文件 | ⭐⭐⭐ |
| `p10k_config_ascii_only.zsh` | 无乱码配置 | ⭐⭐⭐ |
| `setup_all.sh` | 一键安装 | ⭐⭐⭐ |
| `enhanced_zshrc` | zsh 增强配置 | ⭐⭐ |
| `README.md` | 项目说明 | ⭐⭐ |
| `MesloLGS_NF_Regular.ttf` | 字体文件 | ⭐⭐ |

## 🧹 已清理的文件

### 删除的重复配置文件
- `p10k_config_no_icons.zsh` - 与 ASCII 版本重复
- `p10k_config_simple.zsh` - 功能重复
- `working_p10k_config.zsh` - 临时文件

### 删除的临时脚本
- `fix_prompt_display.sh/zsh` - 临时修复脚本
- `force_python_display.zsh` - 调试脚本
- `immediate_fix.zsh` - 临时解决方案

### 删除的重复安装脚本
- `install_miniforge.sh` - 功能已整合到 setup_all.sh
- `install_terminal_enhancements.sh` - 功能重复
- `setup_enhanced_terminal.sh` - 功能重复

### 删除的重复文档
- 多个 `*_SUMMARY.md` 文件 - 内容重复，已整合到核心文档

## 🔧 维护说明

- 核心配置文件不要随意修改
- 新功能添加到 `setup_all.sh` 中
- 文档保持更新
- 定期测试配置的有效性

## 📊 清理统计

- **清理前**: 约 50+ 个文件
- **清理后**: 13 个核心文件
- **删除文件**: 35+ 个重复/临时文件
- **保留率**: 约 25%

项目现在结构清晰，易于维护和使用！
