#!/bin/bash

# Define SSD device
SSD_DEVICE="/dev/nvme0n1" 

# Define block sizes for testing (in KB)
BLOCK_SIZES=(4096)

# Function to perform a fast reset of the SSD
reset_ssd() {
    echo "Performing a fast reset of the SSD: $SSD_DEVICE"
    sudo blkdiscard $SSD_DEVICE
    sleep 600  # Allow the SSD some time to stabilize after reset
}

run_test() {
    local RW_TYPE=$1
    local OUTPUT_FILE="fio_results_${RW_TYPE}.csv"
    
    echo "Block Size (KB),Throughput (MiB/s),Time (ms)," > $OUTPUT_FILE

    for BS in "${BLOCK_SIZES[@]}"; do
        reset_ssd
        LOG_PREFIX="test_${RW_TYPE}_bs_${BS}_bw"

        fio --name=test_${RW_TYPE}_bs_${BS} --filename=$SSD_DEVICE --ioengine=io_uring \
            --rw=$RW_TYPE --rwmixread=50 --bs=${BS}k --iodepth=64 --direct=1 --runtime=10 --group_reporting \
            --write_bw_log=$LOG_PREFIX --log_avg_msec=500 --time_based
            
        for LOG_FILE in ${LOG_PREFIX}*.log; do
            chmod 777 $LOG_FILE

            if [ -f "$LOG_FILE" ]; then
                awk -v bs=$BS '{print bs","$2/1024","$1}' $LOG_FILE >> $OUTPUT_FILE
                rm $LOG_FILE
            else
                echo "Log file $LOG_FILE not created or not accessible. Skipping..."
            fi
        done
    done
}

# Run tests for random write, random read, sequential write, and sequential read
run_test "randwrite"
run_test "randread"
run_test "write"
run_test "read"
run_test "randrw"

# Plot results for each test type
python3 plot_fio_results.py fio_results_randwrite.csv
python3 plot_fio_results.py fio_results_randread.csv
python3 plot_fio_results.py fio_results_write.csv
python3 plot_fio_results.py fio_results_read.csv
