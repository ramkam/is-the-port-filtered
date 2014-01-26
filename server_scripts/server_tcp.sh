#!/bin/bash

# Run in sudo
# outputs are updated in report folder

ts="$(date "+%Y-%m-%d %H:%M:%S")";
reports="reports"
masterreport="tests_history.log"; 
mode="tcp"	# default netcat option, printed in logs

if [ -z "$1" ]; then
	exit 1
fi

touch "$masterreport"; 
chmod a+rw "$masterreport"
mkdir -p "$reports"

thisreport="$reports/port_${mode}_$port.log"
port="$1"
touch "$thisreport"
chmod a+rw "$thisreport"
echo "#TEST PORT $port" >> "$thisreport"

nc -l $port > "$thisreport" &
pid=$!
#DEBUG# echo "netcat launched on port $port"

test=$(kill -0 $pid | wc -l)
maxiterations=5;
sleeptime=1;
n=0;
while [ $test -eq 0 ]&&[ $n -lt $maxiterations ]; do
	test=$(kill -0 $pid 2>&1 | wc -l)
	kill -0 $pid 
	#DEBUG# echo "$n : $test"
	n=$(( $n + 1 ))
	sleep $sleeptime
done

kill $pid 2> /dev/null 1> /dev/null
#DEBUG# echo "netcat stopped"

nn=$(cat "$reports/port_${mode}_$port" | wc -l)
if [ $nn -gt 1 ]; then
	echo "$ts|$port|$mode|OPEN" >> "$masterreport"
	echo "OPEN"
else
	echo "$ts|$port|$mode|CLOSED" >> "$masterreport"
	echo "CLOSED"
fi

