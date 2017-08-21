#!/usr/bin/env bash

set -e  # stop on first error

usage () {
    echo "                                              "
    echo "Latency test Script - Client side.            "
    echo "                                              "
    echo "Usage: $0 <Server side IP>					"
    echo "                                              "
}

if [ $# -ne 1 ]; then
	usage
	exit 1
fi

IP="${1}"
PORT=2222
PIPE="pipe"

mkfifo ${PIPE}
echo "Connecting ${IP} Port ${PORT}.."
while read line
do
    if [ "$line" == "test" ]; then
        echo "okey" > ${PIPE}
    elif [ "$line" == "start" ]; then
        echo "Server is $line"
        echo "start" > ${PIPE}
    elif [ "$line" == "exit" ]; then
        echo "Received 'exit'"
        echo "exit" > ${PIPE}
        break
    else
        echo "Received $line"
    fi
done < <((tail -f ${PIPE}) | nc -v -q -1 ${IP} ${PORT} && echo "ready" > ${PIPE})
rm ${PIPE}
echo "Good bye"
