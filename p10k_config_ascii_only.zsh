# Powerlevel10k 纯 ASCII 字符配置 - 完全避免乱码

() {
  emulate -L zsh -o extended_glob

  # 左侧提示符元素
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
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
    time                    # current time
  )

  # Python 版本配置 - 纯 ASCII
  typeset -g POWERLEVEL9K_PYTHON_VERSION_PROJECT_ONLY=false
  typeset -g POWERLEVEL9K_PYTHON_VERSION_FOREGROUND=0
  typeset -g POWERLEVEL9K_PYTHON_VERSION_BACKGROUND=3
  typeset -g POWERLEVEL9K_PYTHON_VERSION_CONTENT_EXPANSION='py${P9K_CONTENT}'

  # 虚拟环境配置 - 纯 ASCII
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=true
  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=0
  typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND=2
  typeset -g POWERLEVEL9K_VIRTUALENV_CONTENT_EXPANSION='(${P9K_CONTENT})'

  # Conda 环境配置 - 纯 ASCII
  typeset -g POWERLEVEL9K_ANACONDA_SHOW_PYTHON_VERSION=true
  typeset -g POWERLEVEL9K_ANACONDA_FOREGROUND=0
  typeset -g POWERLEVEL9K_ANACONDA_BACKGROUND=6
  typeset -g POWERLEVEL9K_ANACONDA_CONTENT_EXPANSION='conda:${P9K_CONTENT}'

  # 目录配置
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=7
  typeset -g POWERLEVEL9K_DIR_BACKGROUND=4
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_last
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3

  # Git 配置 - 使用纯文字
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=0
  typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND=2
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=0
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=3
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=0
  typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=1

  # Git 状态符号 - 使用 ASCII 字符
  typeset -g POWERLEVEL9K_VCS_CLEAN_CONTENT_EXPANSION='${P9K_VCS_BRANCH}'
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_CONTENT_EXPANSION='${P9K_VCS_BRANCH} ?'
  typeset -g POWERLEVEL9K_VCS_MODIFIED_CONTENT_EXPANSION='${P9K_VCS_BRANCH} *'

  # 提示符字符 - 使用标准 ASCII
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=2
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=1
  typeset -g POWERLEVEL9K_PROMPT_CHAR_CONTENT_EXPANSION='>'

  # 时间配置
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=0
  typeset -g POWERLEVEL9K_TIME_BACKGROUND=7
  typeset -g POWERLEVEL9K_TIME_FORMAT='%H:%M'

  # 状态配置 - 仅显示错误
  typeset -g POWERLEVEL9K_STATUS_OK=false
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=1
  typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND=0
  typeset -g POWERLEVEL9K_STATUS_ERROR_CONTENT_EXPANSION='ERR:${P9K_EXIT_CODE}'

  # 禁用不需要的元素以简化显示
  typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION=''
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=10

  # 即时提示
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose

  # 重新加载配置
  (( ! $+functions[p10k] )) || p10k reload
}

echo "纯 ASCII 字符配置已加载 - 完全避免乱码"
echo "显示格式: ~/path git_branch py3.13 (venv) >"
