export LANGUAGE=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8
export LC_CTYPE=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8

export AUTOENV_FILE_ENTER=.env

export DOCKER_BUILDKIT=1

function github() {
  cd ~/Code/src/github.com/$1
}

alias gh=" github"

function gitlab() {
  cd ~/Code/src/gitlab.com/$1
}

alias gl=" gitlab"

function gt8() {
  cd ~/Code/src/code.devtech.gt8.online/$1
}

alias bb=" bitbucket"

function bitbucket() {
  cd ~/Code/src/bitbucket.org/$1
}

# Set GPG TTY
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ];
then
  export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh"
fi

export EDITOR="code --wait"
export PAGER=less
export MANPAGER=less
export MANWIDTH=${MANWIDTH:-80}
export COLORTERM="yes"

export NNN_DE_FILE_MANAGER="code"
export NNN_BMS='c:/code/src;s:/code/sandbox;j:/code/src/gitlab.jaumo.com/;g:/code/src/code.devtech.gt8.online;gl:/code/src/gitlab.com;gh:/code/src/github.com'

# Additional characters to respect as word delimeter
backward-kill-not-greedy () {
    local WORDCHARS=${WORDCHARS:s,/,,}
    WORDCHARS=${WORDCHARS:s,\.,,}
    WORDCHARS=${WORDCHARS:s,_,,}
    zle backward-kill-word
}

zle -N backward-kill-not-greedy
bindkey '^[w' backward-kill-not-greedy

# Report how long a command took, if it took more than a second
export REPORTTIME=5

# Enable color support of ls
if [[ "$TERM" != "dumb" ]]; then
  if [[ -x `which dircolors 2> /dev/null` ]]; then
    eval `dircolors -b`
  fi
fi

DIRSTACKSIZE=9
DIRSTACKFILE=~/.zdirs
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
  dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
  [[ -d $dirstack[1] ]] && cd $dirstack[1] && cd $OLDPWD
fi
chpwd() {
  print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}

POWERLEVEL9K_OK_ICON='✓'

POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_DELIMITER=""
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"

POWERLEVEL9K_PROMPT_ON_NEWLINE=true

POWERLEVEL9K_BATTERY_DISCONNECTED_BACKGROUND="008"
POWERLEVEL9K_BATTERY_DISCONNECTED_FOREGROUND="007"
DEFAULT_USER="rawkode"

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(status dir dir_writable vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()
POWERLEVEL9K_TIME_FORMAT="%D{%H:%M:%S %d/%m/%Y}"

POWERLEVEL9K_DISABLE_RPROMPT=true

POWERLEVEL9K_MODE="nerdfont-complete"

setopt COMPLETE_IN_WORD    # Complete from both ends of a word.
setopt ALWAYS_TO_END       # Move cursor to the end of a completed word.
setopt PATH_DIRS           # Perform path search even on command names with slashes.
setopt AUTO_MENU           # Show completion menu on a successive tab press.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt AUTO_PARAM_SLASH    # If completed parameter is a directory, add a trailing slash.
unsetopt MENU_COMPLETE     # Do not autoselect the first completion entry.
unsetopt FLOW_CONTROL      # Disable start/stop characters in shell editor

# You can cd into a directory by typing its name, no cd required
setopt AUTOCD
setopt autopushd pushdignoredups PUSHD_SILENT PUSHD_TO_HOME

# No completion for backup files
zstyle ':completion:*:complete:-command-::*' ignored-patterns '*\~'

# Fuzzy completion
zstyle ':completion:*' matcher-list '' \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'

autoload -Uz compinit
compinit -u

export FZF_DEFAULT_COMMAND='ag -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
