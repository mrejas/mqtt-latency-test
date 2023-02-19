#!/bin/bash

#USER=
#PASS=
#HOST=

# Or define in .config
. .config

function check_timestamp() {
        data=$1
        now=$((`date +%s%N`))
        diff=`echo "scale=4; ($now-$data) / 1000000000" | bc`;
        >&2 echo  $now:$diff; # Send to stderr do allow redirecting of csv-output below

	# Send as Nagios passive check
        #if [ -e /opt/nagios2/var/rw/nagios.cmd ]; then
        #        timeout -s 9 -k 10 5 bash -c "/usr/bin/printf \"[$(($now / 1000000000))] PROCESS_SERVICE_CHECK_RESULT;EXT-lynx.alleato.se;MQTT - Latency;0;OK - Latency ${diff}s|Latency=${diff}s\n\" > /opt/nagios2/var/rw/nagios.cmd"
        #fi

	#
	# Send to stdout in csv
	#
	echo $(($now/1000000000)),$diff
}

export -f check_timestamp

while true; do  
                mosquitto_sub -i mqtttime.$$ -h $HOST -p 8883 -u $USER -P $PASS  --capath /etc/ssl/certs  -t tmp/time/test | xargs -P 10 -I {} bash -c 'check_timestamp "$@"' _ {} 
done
