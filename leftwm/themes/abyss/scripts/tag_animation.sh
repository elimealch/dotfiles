#!/bin/sh

n_frames=6
while [ true ]; do
    busy_sequence="󰜋󰣏󰤃󰣏󰜋"
    idx=1
    while [ $idx -lt $n_frames ]; do
        state=$(tail -n 1 $STATEFILE)
        busy_frame=$(echo $busy_sequence | awk -v i=$idx '{ print substr($0, i, 1) }')
        output=$(echo $state | sed -e "s/ACTIVE_BUSY/$busy_frame/g")
        echo $output

        idx=$((idx + 1))
        sleep 0.1
    done
done

