autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

###-begin-nps-completions-###
#
# yargs command completion script
#
# Installation: node_modules/.bin/nps completion >> ~/.bashrc
#    or node_modules/.bin/nps completion >> ~/.bash_profile on OSX.
#
_yargs_completions()
{
    local cur_word args type_list

    cur_word="${COMP_WORDS[COMP_CWORD]}"
    args=("${COMP_WORDS[@]}")

    # ask yargs to generate completions.
    type_list=$(node_modules/.bin/nps --get-yargs-completions "${args[@]}")
    COMPREPLY=( $(compgen -W "${type_list}" -- ${cur_word}) )

    # if no match was found, fall back to filename completion
    if [ ${#COMPREPLY[@]} -eq 0 ]; then
      COMPREPLY=( $(compgen -f -- "${cur_word}" ) )
    fi

    return 0
}
complete -F _yargs_completions nps
###-end-nps-completions-###
