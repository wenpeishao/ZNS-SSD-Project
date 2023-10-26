#!/bin/bash

# Define the SSD device to test
DEVICE="/dev/sdb"

# Make sure only root can run the script
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# Define block sizes to test (e.g., 4k, 8k, 16k, etc.)
BLOCK_SIZES="4k 8k 16k 32k 64k 128k 256k 512k 1m 2m 4m"

# Operations to test (e.g., read, write)
OPERATIONS="randread randwrite"

# Benchmark configurations
NUM_JOBS=4  # Number of parallel jobs
RUN_TIME=30s  # Each test runs for 30 seconds

# Loop over each operation and block size to run the benchmark
for op in $OPERATIONS; do
  for bs in $BLOCK_SIZES; do
    echo "Running benchmark with operation $op and block size $bs"

    JSON_OUTPUT="benchmark_${op}_${bs}.json"

    fio --name=mytest \
        --ioengine=io_uring \
        --rw=$op \
        --bs=$bs \
        --numjobs=$NUM_JOBS \
        --time_based \
        --runtime=$RUN_TIME \
        --#!/bin/bash

# Define the SSD device to test
DEVICE="/dev/sdb"

# Make sure only root can run the script
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# Define block sizes to test (e.g., 4k, 8k, 16k)
BLOCK_SIZES="4k 8k 16k 32k 64k 128k 256k 512k 1m 2m 4m"

# Benchmark configurations
NUM_JOBS=4 # Number of parallel jobs
RUN_TIME=30s # Each test runs for 30 seconds

# Loop over each block size and run the benchmark
for bs in $BLOCK_SIZES; do
  echo "Running benchmark with block size $bs"
  
  JSON_OUTPUT="benchmark_${bs}.json"

  fio --name=mytest \
      --ioengine=io_uring \
      --rw=randread \
      --bs=$bs \
      --numjobs=$NUM_JOBS \
      --time_based \
      --runtime=$RUN_TIME \
      --filename=$DEVICE \
      --output-format=json \
      --output=$JSON_OUTPUT
  
  echo "Benchmark complete for block size $bs. Results saved in $JSON_OUTPUT"

  # Extract and print the read throughput from the JSON output
  READ_BW=$(jq '.jobs[0].read.bw' $JSON_OUTPUT)
  echo "Read throughput for block size $bs is $READ_BW KB/s"

done

echo "All benchmarks complete."
filename=$DEVICE \
        --output-format=json \
        --output=$JSON_OUTPUT

    echo "Benchmark complete for operation $op and block size $bs. Results saved in $JSON_OUTPUT"

    # Extract and print the throughput from the JSON output
    THROUHPUT=$(jq ".jobs[0].${op:4}.bw" $JSON_OUTPUT)
    echo "Throughput for operation $op and block size $bs is $THROUHPUT KB/s"
  done
done

echo "All benchmarks complete."
