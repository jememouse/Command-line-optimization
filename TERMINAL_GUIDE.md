# 🚀 终端命令行优化完整指南

这是一个全面的终端命令行优化解决方案，提供实时命令建议、智能补全、上下文感知提示等强大功能。

## 📋 目录

- [功能特性](#功能特性)
- [快速开始](#快速开始)
- [详细功能说明](#详细功能说明)
- [快捷键和命令](#快捷键和命令)
- [自定义配置](#自定义配置)
- [故障排除](#故障排除)
- [高级用法](#高级用法)

## ✨ 功能特性

### 🔮 实时命令建议
- 基于历史记录的智能建议
- 自动补全常用命令
- 支持模糊匹配

### 🧠 智能参数补全
- 上下文感知的参数补全
- 支持文件路径、Git 分支、进程等
- 智能大小写匹配

### 🎯 上下文感知提示
- 自动检测项目类型（Python、Node.js、Git 等）
- 提供相关的操作建议
- 显示环境状态信息

### 🎨 更好的视觉效果
- Powerlevel10k 主题
- 语法高亮
- 彩色输出
- 图标支持

### 📚 命令记忆功能
- 智能历史记录管理
- 命令使用频率统计
- 重复命令去重

### 🔍 智能历史搜索
- FZF 模糊搜索
- 实时搜索预览
- 多种搜索模式

## 🚀 快速开始

### 1. 一键安装

```bash
# 给脚本执行权限
chmod +x setup_enhanced_terminal.sh

# 运行安装脚本
./setup_enhanced_terminal.sh
```

### 2. 重启终端

```bash
# 重新加载配置
source ~/.zshrc

# 或者重新启动终端应用
```

### 3. 字体设置

如果提示符显示异常，请：
1. 打开终端偏好设置
2. 选择"字体"选项卡
3. 将字体更改为 "MesloLGS NF"

### 4. 自定义提示符

```bash
# 运行配置向导
p10k configure
```

## 📖 详细功能说明

### 实时命令建议

当您开始输入命令时，系统会基于历史记录显示灰色的建议文本：

```bash
$ git s█
$ git status  # 灰色建议文本
```

- 按 `→` 或 `End` 键接受建议
- 按 `Ctrl+F` 接受建议中的一个单词

### 智能参数补全

按 `Tab` 键触发智能补全：

```bash
$ git checkout <Tab>
main    develop    feature/login    # 显示可用分支

$ cd <Tab>
Documents/    Downloads/    Projects/    # 显示目录

$ kill <Tab>
1234 chrome    5678 node    # 显示进程
```

### 上下文感知提示

进入不同类型的项目目录时，系统会自动显示相关信息：

```bash
$ cd my-python-project
📁 Git 仓库: my-python-project
🌿 分支: main
🐍 检测到 Python 项目
💡 提示: 可能需要激活虚拟环境

$ cd my-node-app
📦 检测到 Node.js 项目
💡 提示: 运行 'npm install' 安装依赖
```

### 智能历史搜索

使用 `fh` 命令或 `Ctrl+R` 进行历史搜索：

```bash
$ fh
# 打开 FZF 搜索界面，可以模糊搜索历史命令
```

## ⌨️ 快捷键和命令

### 快捷键

| 快捷键 | 功能 |
|--------|------|
| `Ctrl+R` | 历史搜索 |
| `Ctrl+T` | 文件选择 |
| `Alt+C` | 目录选择 |
| `↑/↓` | 历史子串搜索 |
| `→` | 接受建议 |
| `Ctrl+F` | 接受建议中的一个单词 |
| `Ctrl+X Ctrl+E` | 在编辑器中编辑命令行 |

### 功能函数

| 命令 | 功能 | 示例 |
|------|------|------|
| `fuzzy_history_search` | 命令历史搜索 | `fuzzy_history_search` |
| `find_file_by_name <名称>` | 查找文件 | `find_file_by_name config` |
| `search_content <词>` | 搜索文件内容 | `search_content "TODO"` |
| `fuzzy_process_kill` | 进程管理 | `fuzzy_process_kill` |
| `project` | 切换项目 | `project` |
| `make_directory_and_enter <目录>` | 创建并进入目录 | `make_directory_and_enter new-project` |
| `sysinfo` | 系统信息 | `sysinfo` |
| `nettest` | 网络测试 | `nettest` |
| `cmd_stats` | 命令统计 | `cmd_stats` |
| `today_stats` | 今日命令统计 | `today_stats` |

### 文件操作命令

| 命令 | 原命令 | 功能 |
|------|--------|------|
| `list_long` | `exa -l --icons` | 详细列表 |
| `list_all` | `exa -la --icons` | 包含隐藏文件 |
| `list_tree` | `exa --tree` | 树形显示 |
| `show_file` | `bat` | 语法高亮显示文件内容 |
| `search_files` | `fd` | 文件查找 |
| `search_text` | `rg` | 文本搜索 |

### Git 命令

| 命令 | 原命令 | 功能 |
|------|--------|------|
| `git_status` | `git status` | 状态 |
| `git_checkout` | `git checkout` | 切换分支 |
| `git_checkout_branch` | `git checkout -b` | 创建新分支 |
| `git_add_all` | `git add .` | 添加所有文件 |
| `git_commit_message` | `git commit -m` | 提交 |
| `git_push` | `git push` | 推送 |
| `git_pull` | `git pull` | 拉取 |
| `git_log_graph` | `git log --oneline --graph` | 图形化日志 |

## ⚙️ 自定义配置

### 编辑配置文件

```bash
# 编辑主配置文件
edit_zsh

# 编辑本地配置文件
edit_local

# 重新加载配置
reload_zsh
```

### 添加自定义别名

在 `~/.zshrc.local` 文件中添加：

```bash
# 自定义别名
alias mycommand='echo "Hello World"'
alias work='cd ~/Projects/work'

# 自定义函数
my_function() {
    echo "这是我的自定义函数"
}
```

### 修改提示符

```bash
# 重新配置 Powerlevel10k
p10k configure

# 编辑 Powerlevel10k 配置
code ~/.p10k.zsh
```

## 🔧 故障排除

### 常见问题

#### 1. 字体显示异常
**问题**: 提示符显示乱码或方块
**解决**: 安装并设置 MesloLGS NF 字体

```bash
# 字体已自动安装到 ~/Library/Fonts/
# 请在终端设置中选择 "MesloLGS NF" 字体
```

#### 2. 命令未找到
**问题**: `fzf`、`exa` 等命令不可用
**解决**: 重新运行安装脚本

```bash
./install_terminal_enhancements.sh
```

#### 3. 配置不生效
**问题**: 新配置没有生效
**解决**: 重新加载配置

```bash
source ~/.zshrc
# 或重启终端
```

#### 4. 性能问题
**问题**: 终端启动缓慢
**解决**: 检查插件配置

```bash
# 查看启动时间
time zsh -i -c exit

# 禁用不需要的插件
edit_zsh
```

### 恢复原始配置

如果需要恢复到原始配置：

```bash
# 查看备份文件
ls ~/.zshrc.backup.*

# 恢复备份
cp ~/.zshrc.backup.YYYYMMDD_HHMMSS ~/.zshrc

# 重新加载
source ~/.zshrc
```

## 🚀 高级用法

### 自定义 FZF 配置

```bash
# 在 ~/.zshrc.local 中添加
export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --border --preview 'bat --color=always {}'"
```

### 添加项目模板

```bash
# 创建项目模板函数
create_python_project() {
    local project_name="$1"
    mkdir -p "$HOME/Projects/$project_name"
    cd "$HOME/Projects/$project_name"
    
    # 创建基本结构
    mkdir -p src tests docs
    touch README.md requirements.txt .gitignore
    
    # 初始化 Git
    git init
    git add .
    git commit -m "Initial commit"
    
    echo "✅ Python 项目 '$project_name' 创建完成"
}
```

### 环境变量管理

```bash
# 在 ~/.zshrc.local 中添加项目特定的环境变量
export WORK_DIR="$HOME/Projects/work"
export API_KEY="your-api-key"
export DATABASE_URL="postgresql://localhost/mydb"
```

## 📚 更多资源

- [Oh My Zsh 文档](https://ohmyz.sh/)
- [Powerlevel10k 配置指南](https://github.com/romkatv/powerlevel10k)
- [FZF 使用技巧](https://github.com/junegunn/fzf)
- [Zsh 官方文档](http://zsh.sourceforge.net/Doc/)

---

🎉 享受您的增强终端体验！如有问题，请查看故障排除部分或创建 Issue。
