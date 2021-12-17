#!/bin/sh

# Bar script for Spectrwm Flammable Duck 2021, MIT License

player() {
    player_status=$(playerctl --player=%any,firefox,chromium status 2> /dev/null)

    if [ "$player_status" = "Playing" ]; then
        echo " $(playerctl metadata --player=%any,firefox,chromium --format '{{artist}} - {{title}}')"
    elif [ "$player_status" = "Paused" ]; then
        echo " $(playerctl metadata --player=%any,firefox,chromium --format '  {{artist}} - {{title}}')"
    else
        echo ""
    fi
}

volume() {
    if [ "$(pamixer --get-mute)" = "true" ]; then
        echo 'M'
    else
        echo $(pamixer --get-volume)
    fi

}

bat_per() {
    cat /sys/class/power_supply/BAT1/capacity
}
bat_stat() {
    cat /sys/class/power_supply/BAT1/status
}

bat_icon() {
    case "$(bat_stat)" in
        'Charging') echo ''
        ;;
        'Not Charging') echo ''
        ;;
        'Discharging')
            case "$(bat_per)" in
                '100') echo ''
                ;;
                '9'*) echo ''
                ;;
                '8'*) echo ''
                ;;
                '7'*) echo ''
                ;;
                '6'*) echo ''
                ;;
                '5'*) echo ''
                ;;
                '4'*) echo ''
                ;;
                '3'*) echo ''
                ;;
                '2'*) echo ''
                ;;
                '1'*) echo ''
                ;;
                '0'*) echo ''
                ;;
                *) echo ''
                ;;

            esac
        ;;
        *) echo ''
        ;;
    esac

}


memory() {
    while IFS=':k '  read -r key val _; do
        case $key in
            MemTotal)
                mem_used=$((mem_used + val))
                mem_full=$val;;
            Shmem) mem_used=$((mem_used + val));;
            MemFree|Buffers|Cached|SReclaimable) mem_used=$((mem_used - val));;
        esac
    done < /proc/meminfo
    mem_used=$((mem_used / 1024))
    mem_full=$((mem_full / 1024))
    memstat="${mem_used}/${mem_full} MB"
	mempercent="$(echo 100 ${mem_used} \* ${mem_full} / p | dc)"
    echo ${mempercent}
}



while true; do
    echo "+|1C $(player) +|1R +@fg=3;[B:+@fg=0;$(bat_per)%+@fg=3;] [V:+@fg=0;$(volume)+@fg=3;] [+@fg=0;$(date +'%I:%M %p')+@fg=3;]"
    sleep 0.25
done
