#!/bin/bash
NUMBER_OF_WORKERS=2

workers=${1:-$NUMBER_OF_WORKERS}

source venv/bin/activate

for i in $(seq 1 $workers); do
    x-terminal-emulator -e celery -A worker worker -l info -n worker$i &
done

x-terminal-emulator -e python3 server.py 

