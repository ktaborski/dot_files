# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

eval "$(dircolors $d)"

# User specific environment
if ! [[ "$PATH" =~ "$HOME/bin:$HOME/.local/bin:" ]]
then
    PATH="$HOME/bin:$PATH:$HOME/.local/bin:"
fi
PATH=$PATH:$HOME/.krew/bin
export PATH


export VISUAL='vim'
export EDITOR="code -nw"
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

# retry() {
#     local max_tries=$1
#     shift
#     local cmd=$@
#     for ((tries=0; tries < max_tries; tries++)); do
#             (set +e; eval "$cmd") && break
#             sleep 10
#     done
#     if [[ $tries -eq $max_tries ]]; then
#         echo "'$1' failed after $tries tries, aborting." >&2
#         return 1
#     else
#         return 0
#     fi
# }
# export -f retry

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

alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias ps='ps xf'
alias mkdir='mkdir -pv'
alias where='find . -name'
alias wget='wget -c'
alias my-commits='git log --author="Krzysztof Taborski"'
alias code='code -n'
alias aws_profile='export AWS_PROFILE=$(aws configure list-profiles | fzf)'
alias awp='export AWS_PROFILE=$(aws configure list-profiles | fzf)'
alias set_namespace='kubectl config set-context --current --namespace'
alias grep='grep --color=auto --line-buffered'
####################  ALIASES END  ########################

####################  COMPLETION START  ###################

source <(kubectl completion bash)
complete -F __start_kubectl kc

source <(helm completion bash)

if which flux >/dev/null 2>&1; then
    source <(flux completion bash)
fi


complete -C aws_completer aws

complete -F _cdwork_completions cdwork
complete -F _set_namespace_completions set_namespace

if which gh >/dev/null 2>&1; then
    source <(gh completion -s bash)
fi

if which eksctl >/dev/null 2>&1; then
    source <(eksctl completion bash)
fi

complete -C /usr/bin/terraform terraform

if which az.completion.sh >/dev/null 2>&1; then
    source az.completion.sh
fi
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

PS1='(\t) \[\e[0;32m\]\u\[\e[m\]:\[\e[0;34m\][$(__git_ps1)]\[\e[0;31m\]<$(context)>\[\e[0;33m\]<${AWS_PROFILE}>\[\e[m\] \W $ '

####################    PS1 END    ########################

function kubectlgetall {
  for i in $(kubectl api-resources --verbs=list --namespaced -o name | grep -v "events.events.k8s.io" | grep -v "events" | sort | uniq); do
    echo "Resource:" $i
    kubectl -n ${1} get --ignore-not-found ${i}
  done
}
