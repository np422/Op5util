# rubocop:disable LineLength, MethodLength, AccessorMethodName
# Foo
module Op5util
  # Foo
  class Monitor
    def autocomplete
      s = '
# Add this to suitable shell startup file to get tab autocomplete for op5util.
# op5util autocomplete >> ~/.bashrc
# ZSH-users should uncomment the line below
# autoload -U +X bashcompinit && bashcompinit

_op5util()
{
    local cur prev opts base
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    op5command="${COMP_WORDS[1]}"
    opts="acknowledge add add_hostgroups downtime help hostgroups schedule status"

    case "${op5command}" in
        acknowledge)
            COMPREPLY=( $(compgen -W "-c --comment=Work_in_Progress -p --persistent --no-persistent -v --verbose --no-verbose $(op5util hosts)" -- ${cur}) )
            ;;
        add)
            COMPREPLY=( $(compgen -W "-a --alias=\" -c --contactgroups=\" -g --hostgroups=\" -i --ipaddr=\" HOST_TO_ADD  $(op5util hostgroups)" -- ${cur}) )
            ;;
        add_hostgroups)
            COMPREPLY=( $(compgen -W "-g --hostgroup=  $(op5util hosts)" -- ${cur}) )
            ;;
        autocomplete)
            COMPREPLY=( $(compgen -W "ENTER" -- ${cur}) )
            ;;
        downtime)
            COMPREPLY=( $(compgen -W "-t --time=n_hour_duration_of_downtime -w --wait=n_hours_before_downtime_start -c --comment=  $(op5util hosts)" -- ${cur}) )
            ;;
        hostgroups)
            COMPREPLY=( $(compgen -W "-l --long  $(op5util hostgroups)" -- ${cur}) )
            ;;
        schedule)
            COMPREPLY=( $(compgen -W "-v --verbose  $(op5util hosts)" -- ${cur}) )
            ;;
        status)
            COMPREPLY=( $(compgen -W "-l --long -s --short  $(op5util hosts)" -- ${cur}) )
            ;;
        *)
            ;;
    esac
    if [ -z $COMPREPLY ]; then
        COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
    fi
    return 0
}
complete -F _op5util op5util
'
      puts s
    end
  end
end
