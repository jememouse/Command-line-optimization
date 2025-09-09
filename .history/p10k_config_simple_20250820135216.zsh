# Powerlevel10k 简化版本配置 - 最小乱码风险

() {
  emulate -L zsh -o extended_glob

  # 左侧提示符元素 - 最简配置
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    dir                     # current directory
    python_version          # python version
    prompt_char             # prompt symbol
  )

  # 右侧提示符元素
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    time                    # current time
  )

  # Python 版本配置 - 纯文字
  typeset -g POWERLEVEL9K_PYTHON_VERSION_PROJECT_ONLY=false
  typeset -g POWERLEVEL9K_PYTHON_VERSION_FOREGROUND=0
  typeset -g POWERLEVEL9K_PYTHON_VERSION_BACKGROUND=3
  typeset -g POWERLEVEL9K_PYTHON_VERSION_CONTENT_EXPANSION='py${P9K_CONTENT}'

  # 目录配置
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=7
  typeset -g POWERLEVEL9K_DIR_BACKGROUND=4

  # 提示符字符 - 使用标准字符
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=2
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=1
  typeset -g POWERLEVEL9K_PROMPT_CHAR_CONTENT_EXPANSION='$'

  # 时间配置
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=0
  typeset -g POWERLEVEL9K_TIME_BACKGROUND=7
  typeset -g POWERLEVEL9K_TIME_FORMAT='%H:%M'

  # 即时提示
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose

  # 重新加载配置
  (( ! $+functions[p10k] )) || p10k reload
}

echo "简化版本配置已加载 - 纯文字显示"
