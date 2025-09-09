# Powerlevel10k 配置文件
# 提供美观的终端提示符和丰富的视觉效果

# Temporarily change options.
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  # Unset all configuration options. This allows you to apply configuration changes without
  # restarting zsh. Edit ~/.p10k.zsh and type `source ~/.p10k.zsh`.
  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  # Zsh >= 5.1 is required.
  [[ $ZSH_VERSION == (5.<1->*|<6->.*) ]] || return

  # The list of segments shown on the left. Fill it with the most important segments.
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    os_icon                 # OS identifier
    dir                     # current directory
    vcs                     # git status
    # Python environment information
    virtualenv              # python virtual environment
    anaconda                # conda environment
    python_version          # python version
    prompt_char             # prompt symbol
  )

  # The list of segments shown on the right. Fill it with less important segments.
  # Right prompt on the last prompt line (where you are typing your commands) gets
  # automatically hidden when the input line reaches it. Right prompt above the
  # last prompt line gets hidden if it would overlap with left prompt.
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status                  # exit code of the last command
    command_execution_time  # duration of the last command
    background_jobs         # presence of background jobs
    # Development environments
    node_version            # node.js version
    go_version              # go version
    rust_version            # rustc version
    java_version            # java version
    # Package info for current project
    package                 # name@version from package.json
    # Cloud and tools
    kubecontext             # current kubernetes context
    terraform               # terraform workspace
    aws                     # aws profile
    # System info
    context                 # user@hostname
    time                    # current time
  )

  # Defines character set used by powerlevel10k. It's best to let `p10k configure` set it for you.
  typeset -g POWERLEVEL9K_MODE=nerdfont-complete
  # typeset -g POWERLEVEL9K_MODE=compatible      # ASCII
  # typeset -g POWERLEVEL9K_MODE=powerline       # Linux console
  # typeset -g POWERLEVEL9K_MODE=nerdfont-complete  # Requires Nerd Font

  # When set to `moderate`, some icons will have an extra space after them. This is meant to avoid
  # icon overlap when using non-monospace fonts. When set to `none`, spaces are not added.
  typeset -g POWERLEVEL9K_ICON_PADDING=none

  # When set to true, icons appear before content on both sides of the prompt. When set
  # to false, icons go after content. If empty or not set, icons go before content in the left
  # prompt and after content in the right prompt.
  #
  # You can also override it for a specific segment:
  #
  #   POWERLEVEL9K_STATUS_ICON_BEFORE_CONTENT=false
  #
  # Or for a specific segment in specific state:
  #
  #   POWERLEVEL9K_DIR_NOT_WRITABLE_ICON_BEFORE_CONTENT=false
  typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=true

  # Add an empty line before each prompt.
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

  # Connect left prompt lines with these symbols. You'll probably want to use the same color
  # as POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND below.
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX='%242F╭─'
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX='%242F├─'
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='%242F╰─'
  # Connect right prompt lines with these symbols.
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX='%242F─╮'
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_SUFFIX='%242F─┤'
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX='%242F─╯'

  # The color of the filler between left and right prompt on the first prompt line.
  # You'll probably want to use the same color as POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX
  # and POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX above.
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND=242

  # Filler between left and right prompt on the first prompt line. You can set it to ' ', '·' or
  # '─'. The last two make it easier to see the alignment between left and right prompt and to
  # separate prompt from command output. You might want to set POWERLEVEL9K_PROMPT_ADD_NEWLINE=false
  # for more compact prompt if using using this option.
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR='─'

  # The color of the filler between left and right prompt on subsequent prompt lines.
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_GAP_FOREGROUND=242

  # Filler between left and right prompt on subsequent prompt lines.
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_GAP_CHAR='─'

  # Start the prompt with a clear line. This makes it easier to distinguish prompt from command
  # output, especially when there is no right prompt.
  typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false

  # Left prompt terminator for lines without any segments.
  typeset -g POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_TERMINATOR='%{%}'

  # Right prompt terminator for lines without any segments.
  typeset -g POWERLEVEL9K_EMPTY_LINE_RIGHT_PROMPT_TERMINATOR='%{%}'

  ################################[ os_icon: os identifier ]################################
  # OS identifier color.
  typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=232
  typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=7
  # Make the icon bold.
  typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION='%B${P9K_CONTENT}%b'

  ################################[ prompt_char: prompt symbol ]################################
  # Green prompt symbol if the last command succeeded.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=76
  # Red prompt symbol if the last command failed.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=196
  # Default prompt symbol.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
  # Prompt symbol in command vi mode.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
  # Prompt symbol in visual vi mode.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='V'
  # Prompt symbol in overwrite vi mode.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true
  # No line terminator if prompt_char is the last segment.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
  # No line introducer if prompt_char is the first segment.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''
  # No surrounding whitespace.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_{LEFT,RIGHT}_WHITESPACE=''

  ##################################[ dir: current directory ]##################################
  # Default current directory color.
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=31
  # If directory is too long, shorten some of its segments to the shortest possible unique
  # prefix. The shortened directory can be tab-completed to the original.
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  # Replace removed segment suffixes with this symbol.
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=
  # Color of the shortened directory segments.
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=103
  # Color of the anchor directory segments. Anchor segments are never shortened. The first
  # segment is always an anchor.
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=39
  # Display anchor directory segments in bold.
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
  # Don't shorten directories that contain any of these files. They are anchors.
  local anchor_files=(
    .bzr
    .citc
    .git
    .hg
    .node-version
    .python-version
    .go-version
    .ruby-version
    .lua-version
    .java-version
    .perl-version
    .php-version
    .tool-versions
    .shorten_folder_marker
    .svn
    .terraform
    CVS
    Cargo.toml
    composer.json
    go.mod
    package.json
    stack.yaml
  )
  typeset -g POWERLEVEL9K_SHORTEN_FOLDER_MARKER="(${(j:|:)anchor_files})"
  # If set to "first" ("last"), remove everything before the first (last) subdirectory that contains
  # files matching $POWERLEVEL9K_SHORTEN_FOLDER_MARKER. For example, when the current directory is
  # /foo/bar/git_repo/nested_git_repo/baz, and git_repo and nested_git_repo contain .git files,
  # "first" will give us git_repo/nested_git_repo/baz while "last" will give us nested_git_repo/baz.
  # Note: Ignore-case is not supported in this context.
  typeset -g POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER=false
  # Don't shorten this many last directory segments. They are anchors.
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
  # Shorten directory if it's longer than this even if there is space for it. The value can
  # be either absolute (e.g., '80') or a percentage of terminal width (e.g, '50%'). If empty,
  # directory will be shortened only when prompt doesn't fit or when other parameters demand it
  # (see POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS and POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT below).
  # If set to `0`, directory will always be shortened to its minimum length.
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=80
  # When `dir` segment is on the last prompt line, try to shorten it enough to leave at least this
  # many columns for typing commands.
  typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS=40
  # When `dir` segment is on the last prompt line, try to shorten it enough to leave at least
  # COLUMNS * POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT * 0.01 columns for typing commands.
  typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT=50
  # If set to true, embed a hyperlink into the directory. Useful for quickly
  # opening a directory in the file manager simply by clicking the link.
  # Can also be handy when the directory is shortened, as it allows you to see
  # the full directory that was used in previous commands.
  typeset -g POWERLEVEL9K_DIR_HYPERLINK=false

  # Enable special styling for non-writable and non-existent directories. See POWERLEVEL9K_LOCK_ICON
  # and POWERLEVEL9K_DIR_CLASSES below.
  typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=v3

  ##################################[ python_version: python version ]##################################
  # Python version color.
  typeset -g POWERLEVEL9K_PYTHON_VERSION_FOREGROUND=37
  typeset -g POWERLEVEL9K_PYTHON_VERSION_BACKGROUND=4
  # Show Python version always (not just in Python projects)
  typeset -g POWERLEVEL9K_PYTHON_VERSION_PROJECT_ONLY=false
  # Custom Python version format.
  typeset -g POWERLEVEL9K_PYTHON_VERSION_CONTENT_EXPANSION='🐍${P9K_CONTENT}'

  ##################################[ virtualenv: python virtual environment ]##################################
  # Python virtual environment color.
  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=0
  typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND=2
  # Show Python version next to the virtual environment name.
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=true
  # If set to "false", won't show virtualenv if pyenv is already shown.
  # If set to "if-different", won't show virtualenv if it's the same as pyenv.
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_WITH_PYENV=false
  # Separate environment name from Python version only with a space.
  typeset -g POWERLEVEL9K_VIRTUALENV_{LEFT,RIGHT}_DELIMITER=
  # Custom virtualenv prompt.
  typeset -g POWERLEVEL9K_VIRTUALENV_CONTENT_EXPANSION='🐍${P9K_CONTENT}'

  ##################################[ anaconda: conda environment ]##################################
  # Anaconda environment color.
  typeset -g POWERLEVEL9K_ANACONDA_FOREGROUND=0
  typeset -g POWERLEVEL9K_ANACONDA_BACKGROUND=2
  # Show Python version next to the conda environment name.
  typeset -g POWERLEVEL9K_ANACONDA_SHOW_PYTHON_VERSION=true
  # If set to "false", won't show anaconda if pyenv is already shown.
  # If set to "if-different", won't show anaconda if it's the same as pyenv.
  typeset -g POWERLEVEL9K_ANACONDA_SHOW_WITH_PYENV=false
  # Separate environment name from Python version only with a space.
  typeset -g POWERLEVEL9K_ANACONDA_{LEFT,RIGHT}_DELIMITER=
  # Custom anaconda prompt.
  typeset -g POWERLEVEL9K_ANACONDA_CONTENT_EXPANSION='🐍${P9K_CONTENT}'

  ##################################[ node_version: node.js version ]##################################
  # Node.js version color.
  typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND=0
  typeset -g POWERLEVEL9K_NODE_VERSION_BACKGROUND=2
  # Show Node.js version only when in a Node.js project.
  typeset -g POWERLEVEL9K_NODE_VERSION_PROJECT_ONLY=true
  # Custom Node.js version format.
  typeset -g POWERLEVEL9K_NODE_VERSION_CONTENT_EXPANSION='📦${P9K_CONTENT}'

  ##################################[ go_version: go version ]##################################
  # Go version color.
  typeset -g POWERLEVEL9K_GO_VERSION_FOREGROUND=0
  typeset -g POWERLEVEL9K_GO_VERSION_BACKGROUND=4
  # Show Go version only when in a Go project.
  typeset -g POWERLEVEL9K_GO_VERSION_PROJECT_ONLY=true
  # Custom Go version format.
  typeset -g POWERLEVEL9K_GO_VERSION_CONTENT_EXPANSION='🔷${P9K_CONTENT}'

  ##################################[ rust_version: rustc version ]##################################
  # Rust version color.
  typeset -g POWERLEVEL9K_RUST_VERSION_FOREGROUND=0
  typeset -g POWERLEVEL9K_RUST_VERSION_BACKGROUND=208
  # Show Rust version only when in a Rust project.
  typeset -g POWERLEVEL9K_RUST_VERSION_PROJECT_ONLY=true
  # Custom Rust version format.
  typeset -g POWERLEVEL9K_RUST_VERSION_CONTENT_EXPANSION='🦀${P9K_CONTENT}'

  ##################################[ java_version: java version ]##################################
  # Java version color.
  typeset -g POWERLEVEL9K_JAVA_VERSION_FOREGROUND=1
  typeset -g POWERLEVEL9K_JAVA_VERSION_BACKGROUND=7
  # Show Java version only when in a Java project.
  typeset -g POWERLEVEL9K_JAVA_VERSION_PROJECT_ONLY=true
  # Custom Java version format.
  typeset -g POWERLEVEL9K_JAVA_VERSION_CONTENT_EXPANSION='☕${P9K_CONTENT}'

  ##################################[ package: name@version from package.json ]##################################
  # Package color.
  typeset -g POWERLEVEL9K_PACKAGE_FOREGROUND=0
  typeset -g POWERLEVEL9K_PACKAGE_BACKGROUND=6
  # Custom package format.
  typeset -g POWERLEVEL9K_PACKAGE_CONTENT_EXPANSION='📦${P9K_PACKAGE_NAME//\%/%%}@${P9K_PACKAGE_VERSION//\%/%%}'

  ##################################[ 增强 Python 配置 ]##################################

  # Python 版本显示增强配置
  # 优化颜色方案 - 使用更醒目的颜色
  typeset -g POWERLEVEL9K_PYTHON_VERSION_FOREGROUND=0        # 黑色文字
  typeset -g POWERLEVEL9K_PYTHON_VERSION_BACKGROUND=11       # 亮黄色背景

  # 虚拟环境颜色优化
  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=0            # 黑色文字
  typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND=2            # 绿色背景

  # Conda 环境颜色优化
  typeset -g POWERLEVEL9K_ANACONDA_FOREGROUND=0              # 黑色文字
  typeset -g POWERLEVEL9K_ANACONDA_BACKGROUND=6              # 青色背景

  # 自定义 Python 版本格式 - 添加蛇图标
  typeset -g POWERLEVEL9K_PYTHON_VERSION_CONTENT_EXPANSION='🐍${P9K_CONTENT}'
  typeset -g POWERLEVEL9K_VIRTUALENV_CONTENT_EXPANSION='🐍${P9K_CONTENT}'
  typeset -g POWERLEVEL9K_ANACONDA_CONTENT_EXPANSION='🐍${P9K_CONTENT}'
