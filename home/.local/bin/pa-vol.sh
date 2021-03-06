
#!/bin/bash


#mode=`pactl stat | grep -c hdmi-stereo`
#if [ $mode -eq 0 ]; then
#    SINK_NAME="alsa_output.pci-0000_00_1b.0.analog-stereo"
#else
#    SINK_NAME="alsa_output.pci-0000_00_1b.0.hdmi-stereo"
#fi 

eval $(pactl info | awk -F'[ ]' '{if (match($0, "Default Sink")) print "SINK_NAME="$3}')

VOL_STEP="0x01000"
VOL_NOW=`pacmd dump | grep -P "^set-sink-volume $SINK_NAME\s+" | perl -p -i -e 's/.+\s(.x.+)$/$1/'`

case "$1" in
	plus)
	VOL_NEW=$((VOL_NOW + VOL_STEP))
    [[ $VOL_NEW -gt $((0x10000)) ]] && VOL_NEW=$((0x10000))
	pactl set-sink-volume $SINK_NAME `printf "0x%X" $VOL_NEW`
	;;
	
    minus)
	VOL_NEW=$((VOL_NOW - VOL_STEP))
	[[ $(($VOL_NEW)) -lt $((0x00000)) ]] && VOL_NEW=$((0x00000))
	pactl set-sink-volume $SINK_NAME `printf "0x%X" $VOL_NEW`
	;;
	
    mute)
	MUTE_STATE=`pacmd dump | grep -P "^set-sink-mute $SINK_NAME\s+" | perl -p -i -e 's/.+\s(yes|no)$/$1/'`
	if [ $MUTE_STATE = no ];
	then
	        pactl set-sink-mute $SINK_NAME 1
	elif [ $MUTE_STATE = yes ];
	then
		pactl set-sink-mute $SINK_NAME 0
	fi
esac

