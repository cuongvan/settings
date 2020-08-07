
# make ps more useful
# ps1: print all processed
# ps1 <filter>: filtered processed
# ps1 <filter> 1: show pids
# ps1 <filter> 2: kill filtered processs
function ps1 {
    if [[ $# == 0 ]]; then
        ps -ef
    elif [[ $# == 1 ]]; then
        filter=$1
        ps -ef | grep -v grep | grep "$filter"
    else
        if [[ $2 == "pid" || $2 == "p" ]]; then
            ps -ef | grep -v grep | grep "$filter" | awk '{print $2}'
        elif [[ $2 == "kill" || $2 == "k" ]]; then
            ps -ef | grep -v grep | grep "$filter" | awk '{print $2}' | xargs kill
        else
            echo "Unrecognized subcmd: $2"
        fi
    fi
}

alias lh='ls -d .!(|.)'
alias egrep='egrep --color=auto'