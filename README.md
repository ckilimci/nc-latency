# nc-latency

Measure latency with netcat.

Usage:
------

First run server side:

```sh
$ ./server.sh
```

Then run client side with server side IP:

```sh
$ ./client.sh <Server IP>
```

Finally send start command via pipe at the client side:

```sh
$ echo start > pipe
```

Results are in the **timer.txt** file.
