#!/usr/bin/env bash

set -e  # stop on first error

usage () {
    echo "                                                      "
    echo "Latency test Script - Server side.                    "
    echo "                                                      "
    echo "Usage: $0                                             "
    echo "After client started, write \"start\" to created pipe "
    echo "                                                      "
}


if [ $# -ne 0 ]; then
    usage
    exit 1
fi

PORT=2222
PIPE="pipe"
TEST=0
TESTCOUNT=10000
TIMER=""
TIMER_FILE="timer.txt"

mkfifo ${PIPE}
echo "Waiting client to connect Port ${PORT}.."
while read line
do
    if [ "$line" == "okey" ]; then
        # Get Time Diff.
        NOW=$(date +"%H:%M:%S.%N")
        if [ ! -z "$TIMER" ]; then
            StartDate=$(date -u -d "$TIMER" +"%s.%N")
            FinalDate=$(date -u -d "$NOW" +"%s.%N")
            date -u -d "0 $FinalDate sec - $StartDate sec" +"%N ns" >> ${TIMER_FILE}
        fi
        if [ $TEST -lt $TESTCOUNT ]; then
            TEST=$((TEST+1))
            # Set timer and send package
            TIMER=$(date +"%H:%M:%S.%N")
            echo "test" > ${PIPE}
        else
            # Time to exit
            echo "exit" > ${PIPE}
        fi 
    elif [ "$line" == "start" ]; then
        echo "Client is ready to $line"
        echo "test" > ${PIPE}
    elif [ "$line" == "exit" ]; then
        echo "Received 'exit'"
        break
    else
        echo "Received $line"
    fi
done < <((tail -f ${PIPE}) | nc -v -q -1 -l ${PORT})
rm ${PIPE}
echo "Good bye"
