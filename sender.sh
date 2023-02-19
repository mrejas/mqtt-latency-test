#!/bin/bash

#USER=
#PASS=
#HOST=

# Or define in .config
. .config


while true; do

        mosquitto_pub -i mqtttime.$$ -h $HOST -p 8883 -u $USER -P $PASS  --capath /etc/ssl/certs  -t tmp/time/test -m  $((`date +%s%N`))
        echo Sent $((`date +%s%N`))

        sleep 20
done
