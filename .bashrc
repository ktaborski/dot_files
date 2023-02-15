# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
PATH=$PATH:$HOME/.krew/bin:/home/ktaborski/repos/tools/bin
export PATH

export VISUAL='vim'
export EDITOR="$VISUAL"
export SVN_EDITOR="$VISUAL"
export NOEXT="--ignore-externals"
export DOCKER_BUILDKIT=1
# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc

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

cdwork() {
    mkdir -p "${HOME}/WORK/${1}"
    cd "${HOME}/WORK/${1}"
}

_cdwork_completions() {
    COMPREPLY=()
    COMPREPLY+=($(compgen -W "$(find "${HOME}/WORK/" -maxdepth 1 -type d | sed -e "s#${HOME}/WORK/##")" "${COMP_WORDS[1]}"))
}
_set_namespace_completions() {
    COMPREPLY=()
    COMPREPLY+=($(compgen -W "$(complete_ns.py)" "${COMP_WORDS[1]}"))
}

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias ps='ps xf'
alias mkdir='mkdir -pv'
alias where='find . -name'
alias wget='wget -c'
alias my-commits='git log --author=${USER}'
alias code='code -n'
alias aws_profile='export AWS_PROFILE=shareablee'
alias set_namespace='kubectl config set-context --current --namespace'
####################  ALIASES END  ########################

####################  COMPLETION START  ###################

source <(kubectl completion bash)
complete -F __start_kubectl kc

source <(helm completion bash)

complete -C /usr/local/bin/aws_completer aws

complete -F _cdwork_completions cdwork
complete -F _set_namespace_completions set_namespace

source <(gh completion -s bash)

####################  COMPLETION END    ###################

####################   PS1 START   ########################

__git_ps1() {
    local s=
	if git rev-parse --is-inside-work-tree >/dev/null 2>&1 ; then
        s=$(parse_git_branch)
    fi
    echo -n "$s"
}

parse_git_branch() {
    git rev-parse --symbolic-full-name --abbrev-ref HEAD
}

context() {
    namespace=$(kc config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
    if [ -z ${namespace} ]; then
        namespace='default'
    fi
    if [ -n "${KUBE_CONTEXT}" ]; then
        context=${KUBE_CONTEXT}
    else
        context=$(kc config current-context 2>/dev/null)
        if [[ -z ${context} ]]; then
            return 0
        fi
    fi
    echo "${context}:${namespace}"
}

PS1='(\t) \[\e[0;32m\]\u\[\e[m\]:\[\e[0;34m\][$(__git_ps1)]\[\e[0;31m\]<$(context)>\[\e[m\] \W $ '

####################    PS1 END    ########################
