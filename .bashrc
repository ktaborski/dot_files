# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

export VISUAL='vim'
export EDITOR="$VISUAL"
export SVN_EDITOR="$VISUAL"
export NOEXT="--ignore-externals"

#################### ALIASES START ########################

retry() {
    local max_tries=$1
    shift
    local cmd=$@
    for ((tries=0; tries < max_tries; tries++)); do
            sleep 10 
            (set +e; eval "$cmd") && break
    done
    if [[ $tries -eq $max_tries ]]; then
        echo "'$1' failed after $tries tries, aborting." >&2
        return 1
    else
        return 0
    fi
}

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias ps='ps xf'
alias mkdir='mkdir -pv'
alias where='find . -name'
alias wget='wget -c'
alias my-commits='git log --author=${USER}'


####################  ALIASES END  ########################

####################   PS1 START   ########################

__git_svn_ps1() {
    local s=
    if [ -d '.svn' ]; then
        local r=$(__svn_rev)
        local b=$(__svn_branch)
        s="$b@$r"
    elif git rev-parse --is-inside-work-tree >/dev/null 2>&1 ; then
        s=$(parse_git_branch)
    fi
    echo -n "$s"
}

# Outputs the current trunk, branch, or tag
__svn_branch() {
    local url=
    url=$(svn info | awk '/^URL:/ {print $2}')
    if [[ $url =~ /branches/ ]]; then
        echo $url | sed -e 's:.*branches\/::'
    elif [[ $url =~ trunk ]]; then
        echo trunk
    elif [[ $url =~ /tags/ ]]; then
        echo $url | sed -e 's:.*tags\/::'
    fi
}

# Outputs the current revision
__svn_rev() {
    local r=$(svn info | awk '/Revision:/ {print $2}')

    if [ ! -z $SVN_SHOWDIRTYSTATE ]; then
        local svnst flag
        svnst=$(svn status | grep '^\s*[?ACDMR?!]')
        [ -z "$svnst" ] && flag=*
        r=$r$flag
    fi
    echo $r
}

parse_git_branch() {
    git rev-parse --symbolic-full-name --abbrev-ref HEAD
}

PS1='\[\e[0;32m\]\u\[\e[m\]:\[\e[0;34m\][$(__git_svn_ps1)]\[\e[m\] \W $> '

####################    PS1 END    ########################