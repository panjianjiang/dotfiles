#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias vim=/usr/bin/nvim
export EDITOR=/usr/bin/nvim
export SUDO_EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim

PS1='[\u@\h \W]\$ '

# 开启 fzf 快捷键支持 (CTRL-T, CTRL-R, ALT-C)
source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

# 2. 补全不区分大小写 (对路径补全非常有用)
bind "set completion-ignore-case on"

# 3. 按一次 Tab 就列出所有候选，而不是按两次
bind "set show-all-if-ambiguous on"

# 4. 目录补全时，如果是符号链接，自动加上斜杠
bind "set mark-symlinked-directories on"

# 5. 增强型历史搜索：输入命令开头，按上下键只搜索匹配该开头的历史
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# fnm
FNM_PATH="/home/panjj/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --shell bash)"
fi

export PATH="$HOME/.local/bin:$PATH"
# 强制开启 ls 颜色
# 如果是 Linux (GNU ls)
alias ls='ls --color=always'
# 如果是 macOS (BSD ls)
# alias ls='ls -G'

alias ll='ls -alF'
alias grep='grep --color=auto'
# 核心区分逻辑：
# di=1;33 (加粗黄 - 目录)
# ln=1;35 (加粗洋红 - 链接)
# ex=1;32 (加粗绿 - 可执行文件)
# bd=1;33, cd=1;33 (移除背景色，设为加粗黄 - 设备文件)
# fi=0    (白色 - 普通文件)
# 修正后的 LS_COLORS 逻辑：
# di=1;33  -> 目录：加粗天蓝 (bright3)
# bd=1;31  -> 块设备：加粗红色 (bright1) - 明显区分
# cd=1;31  -> 字符设备：加粗红色 (bright1)
# ow=30;43 -> 其它用户可写目录 (777)：黑字 + 天蓝背景 (模拟粉笔重点)
# tw=30;42 -> 带有 sticky bit 的 777 目录：黑字 + 绿色背景
# ex=1;32  -> 可执行文件：加粗绿色
# 1. 更新 LS_COLORS：将 cd (字符设备) 改为 1;34 (即 Claude 色)
export LS_COLORS="di=1;33:ln=0;35:so=1;32:pi=31:ex=1;32:bd=1;36:cd=1;34:su=1;31:sg=1;36:tw=30;42:ow=30;43:or=31:mi=31:fi=0"
export GREP_COLORS="mt=01;30;43"

PS1='[\[\e[38;2;162;134;197m\]\u\[\e[0m\]@\[\e[38;2;181;232;176m\]\h\[\e[0m\] \[\e[1;33m\]\W\[\e[0m\]]\$ '

__set_window_title() {
  printf '\033]0;%s@%s:%s\007' "$USER" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"
}

PROMPT_COMMAND="__set_window_title${PROMPT_COMMAND:+;$PROMPT_COMMAND}"

. "$HOME/.local/share/../bin/env"
