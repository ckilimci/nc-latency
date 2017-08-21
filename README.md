# nc-latency
Measure latency with netcat

Usage:
First run server side:
$ ./server.sh

Then run client side with server side IP
$ ./client.sh <Server IP>

Finally send start command via pipe.
$ echo start > pipe

Results are in the timer.txt file.
