# Detect ditribution
if [ "$(uname -s)" == "Linux" ]; then
    IS_OSX=false
else
    IS_OSX=true
fi

# Prompt
PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] '

# Force Homebrew binaries to take precedence on OSX default
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"

# Prefer US English and use UTF-8
export LANG="en_US"
export LC_ALL="en_US.UTF-8"

# Make vim the default editor
export EDITOR="vim"

# Setting history length
export HISTCONTROL="ignorespace:erasedups"
export HISTTIMEFORMAT="[%F %T] "
export HISTSIZE=99999
# Make some commands not show up in history
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

# append to the history file, don't overwrite it
shopt -s histappend
# Allow use to re-edit a faild history substitution.
shopt -s histreedit
# History expansions will be verified before execution.
shopt -s histverify

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Activate global colors
# OSX/Linux color translations generated with http://geoff.greer.fm/lscolors/
if $IS_OSX; then
    export CLICOLOR=1
    export LSCOLORS="GxFxCxDxBxegedabagaced"
else
    export LS_COLORS="di=1;;40:ln=1;;40:so=1;;40:pi=1;;40:ex=1;;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=34;43:"
fi

# Force colored output and good defaults
alias du='du -csh'
alias df='df -Th'
alias vi='vim'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias g="git"
alias h="history"
alias v="vim"
alias top="htop"
alias diff="colordiff -ru"
alias svn="colorsvn"
alias dmesg="dmesg --color"

# Use GRC for additionnal colorization
GRC=`which grc`
if [ -n GRC ]
then
    alias colourify="$GRC -es --colour=auto"
    alias configure='colourify ./configure'
    alias diff='colourify diff'
    alias make='colourify make'
    alias gcc='colourify gcc'
    alias g++='colourify g++'
    alias as='colourify as'
    alias gas='colourify gas'
    alias ld='colourify ld'
    alias netstat='colourify netstat'
    alias ping='colourify ping'
    alias traceroute='colourify /usr/sbin/traceroute'
fi

# Detect which `ls` flavor is in use
if $IS_OSX; then
    lsflags="-G"
else
    lsflags="--color --group-directories-first"
fi
alias ll="ls -lah ${lsflags}"
alias ls="ls -hFp ${lsflags}"

# Handy aliases for going up in a directory
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Tip from http://sourceforge.net/apps/trac/qlc/wiki/InstallationSubversionLinux#Optionalhelpers
export LESS="-erX"

# Python shell auto-completion and history
export PYTHONSTARTUP="$HOME/python-shell-enhancement/pythonstartup.py"
export PYTHON_HISTORY_FILE="$HOME/.python_history"

# Set virtualenv facilities
export WORKON_HOME=$HOME/virtualenvs
export VIRTUALENVWRAPPER_HOOK_DIR=$HOME/.virtualenv
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
export PIP_VIRTUALENV_BASE=$WORKON_HOME
source /usr/local/bin/virtualenvwrapper.sh
source /usr/local/bin/activate.sh

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh

# Extract most know archives with one command
extract () {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}


# Distribution-specific commands
if $IS_OSX; then

    # Opens current directory in apps
    alias f='open -a Finder ./'
    alias gitx='open -a ~/Applications/GitX.app ./'

    # Find executables
    alias which='type -all'

    # Replace netstat command on OSX to find ports used by apps
    alias netstat="sudo lsof -i -P"

    # Add tab completion for `defaults read|write NSGlobalDomain`
    # You could just use `-g` instead, but I like being explicit
    complete -W "NSGlobalDomain" defaults

else

    # I don't like being restricted to launch apps as root
    export DISPLAY=":0.0 xhost +"

fi


# If possible, add tab completion for many more commands
eval "`pip completion --bash`"
[ -f $(brew --prefix)/etc/bash_completion ] && source $(brew --prefix)/etc/bash_completion
[ -f /etc/bash_completion ] && source /etc/bash_completion
