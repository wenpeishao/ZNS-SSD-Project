#!/bin/bash

# Define SSD device and output file
SSD_DEVICE="/dev/nvme0n1"  # Replace with your SSD device
OUTPUT_FILE="fio_results.csv"

# Define block sizes for testing (in KB)
#BLOCK_SIZES=(128 256 512 1024)
BLOCK_SIZES=(512)

# Function to perform a fast reset of the SSD
reset_ssd() {
    echo "Performing a fast reset of the SSD: $SSD_DEVICE"
    sudo blkdiscard $SSD_DEVICE
}

# Header for the output CSV file
echo "Block Size (KB),Throughput (MiB/s),Data Written (GB)" > $OUTPUT_FILE

# Run fio tests for each block size
for BS in "${BLOCK_SIZES[@]}"; do
    # Reset the SSD after each block size test
    reset_ssd
    LOG_PREFIX="test_bs_${BS}_bw"
    echo "Running fio test for block size: $BS KB"

    # # Run fio with a log file to capture throughput at different intervals
    # sudo fio --name=seq-write-test --filename=$SSD_DEVICE --size=10G --time_based \
    #          --runtime= --ioengine=io_uring --direct=1 --rw=write --bs=${BS}k \
    #          --iodepth=1 --write_bw_log=$LOG_PREFIX --log_avg_msec=100

    # fio --name=seq-write-test --filename=$SSD_DEVICE --size=3000G --time_based \
    #     --runtime=3000 --ioengine=io_uring --direct=1 --rw=write --bs=${BS}k \
    #     --iodepth=32 --write_bw_log=$LOG_PREFIX --log_avg_msec=100

    fio --name=garbage_collection_test --filename=$SSD_DEVICE --size=10G --ioengine=io_uring \
    --rw=randwrite --bs=4k --iodepth=32 --direct=1 --runtime=3600 --group_reporting \
    --write_bw_log=$LOG_PREFIX --log_avg_msec=100 --time_based


    # Find and process all matching log files
    for LOG_FILE in ${LOG_PREFIX}*.log; do
        chmod 777 $LOG_FILE

        if [ -f "$LOG_FILE" ]; then
            awk -v bs=$BS '{print bs","$2/1024","$1/1024}' $LOG_FILE >> $OUTPUT_FILE
            #rm $LOG_FILE
        else
            echo "Log file $LOG_FILE not created or not accessible. Skipping..."
        fi
    done
done

# Run the Python script for plotting
python3 plot_fio_results.py $OUTPUT_FILE
