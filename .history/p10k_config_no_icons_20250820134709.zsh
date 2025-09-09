# Powerlevel10k 无图标版本配置 - 解决乱码问题

() {
  emulate -L zsh -o extended_glob

  # 左侧提示符元素
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    os_icon                 # OS identifier
    dir                     # current directory
    vcs                     # git status
    python_version          # python version
    virtualenv              # python virtual environment
    anaconda                # conda environment
    prompt_char             # prompt symbol
  )

  # 右侧提示符元素
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status                  # exit code of the last command
    command_execution_time  # duration of the last command
    time                    # current time
  )

  # Python 版本配置 - 无图标版本
  typeset -g POWERLEVEL9K_PYTHON_VERSION_PROJECT_ONLY=false
  typeset -g POWERLEVEL9K_PYTHON_VERSION_FOREGROUND=0
  typeset -g POWERLEVEL9K_PYTHON_VERSION_BACKGROUND=11
  typeset -g POWERLEVEL9K_PYTHON_VERSION_CONTENT_EXPANSION='py${P9K_CONTENT}'

  # 虚拟环境配置 - 无图标版本
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=true
  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=0
  typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND=2
  typeset -g POWERLEVEL9K_VIRTUALENV_CONTENT_EXPANSION='[${P9K_CONTENT}]'

  # Conda 环境配置 - 无图标版本
  typeset -g POWERLEVEL9K_ANACONDA_SHOW_PYTHON_VERSION=true
  typeset -g POWERLEVEL9K_ANACONDA_FOREGROUND=0
  typeset -g POWERLEVEL9K_ANACONDA_BACKGROUND=6
  typeset -g POWERLEVEL9K_ANACONDA_CONTENT_EXPANSION='conda:${P9K_CONTENT}'

  # 目录配置
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=0
  typeset -g POWERLEVEL9K_DIR_BACKGROUND=4
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3

  # Git 配置 - 使用文字而非图标
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=0
  typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND=2
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=0
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=3
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=0
  typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=1

  # 提示符字符 - 使用简单字符
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=2
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=1
  typeset -g POWERLEVEL9K_PROMPT_CHAR_CONTENT_EXPANSION='>'

  # OS 图标 - 使用文字
  typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=7
  typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=0
  typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION='${P9K_OS_ICON}'

  # 时间配置
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=0
  typeset -g POWERLEVEL9K_TIME_BACKGROUND=7
  typeset -g POWERLEVEL9K_TIME_FORMAT='%H:%M:%S'

  # 状态配置
  typeset -g POWERLEVEL9K_STATUS_OK=false
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=1
  typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND=0

  # 命令执行时间
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=0
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3

  # 即时提示
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose

  # 重新加载配置
  (( ! $+functions[p10k] )) || p10k reload
}

echo "无图标版本配置已加载 - 解决乱码问题"
