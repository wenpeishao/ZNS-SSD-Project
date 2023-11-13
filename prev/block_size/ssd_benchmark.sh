#!/bin/bash

# Define the SSD device to test
DEVICE="/dev/sdb"

# Ensure only root can run the script
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# Define block sizes to test
BLOCK_SIZES="512 1k 4k 8k 16k 32k 64k 128k 256k 512k 1M"

# Operations to test
OPERATIONS="read randread write randwrite"

# Benchmark configurations
NUM_JOBS=4
RUN_TIME=30s

# Run the benchmark for each operation and block size
for op in $OPERATIONS; do
  for bs in $BLOCK_SIZES; do
    JSON_OUTPUT="benchmark_${op}_${bs}.json"

    fio --name=mytest \
        --ioengine=io_uring \
        --rw=$op \
        --bs=$bs \
        --numjobs=$NUM_JOBS \
        --time_based \
        --runtime=$RUN_TIME \
        --filename=$DEVICE \
        --output-format=json \
        --direct=1 \
        --output=$JSON_OUTPUT
  done
done
