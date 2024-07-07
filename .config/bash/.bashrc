# Source functions
for file in $(find ~/.config/bash/functions -type f -name "*.sh"); do source $file; done

# asdf version manager
source $(brew --prefix asdf)/asdf.sh

# Bash completions
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# https://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# Prompt
export CLICOLOR=1
export LSCOLORS=ExGxDxCxBxdAcAfAbAgAeA
export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
source /opt/homebrew/etc/bash_completion.d/git-prompt.sh
PS1="\[\033[34m\]\W\[\033[32m\]\$(__git_ps1)\[\033[00m\] $ "

# Blastoff
eval "$(starship init bash)"
