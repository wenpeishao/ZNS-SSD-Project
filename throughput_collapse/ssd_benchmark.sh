#!/bin/bash

# Define the SSD device to test
DEVICE="/dev/sdb"

# Define different sizes for testing
# SIZES=("2G" "5G" "10G" "20G" "50G" "100G" "200G" "500G" "1000G")
# SIZES=("2G" "5G" "10G" "20G")
# SIZES=("2G" "3G" "4G" "5G" "6G" "7G" "8G" "9G" "10G")
# SIZES=("100G")
 SIZES=("1000G")

# Loop through each size and run the fio command
for SIZE in "${SIZES[@]}"
do
    # Define the output files for the fio results
    OUTPUT_FILE="fio_output_${SIZE}.txt"
    BW_LOG_FILE="write_test_bw_${SIZE}.log"
    IOPS_LOG_FILE="write_test_iops_${SIZE}.log"
    LAT_LOG_FILE="write_test_lat_${SIZE}.log"

    # Define the fio command with the necessary parameters
    FIO_COMMAND="fio --name=write_test_${SIZE} \
                      --ioengine=io_uring \
                      --direct=1 \
                      --runtime=7200 \
                      --size=$SIZE \
                      --filename=$DEVICE \
                      --rw=write \
                      --bs=1M \
                      --log_avg_msec=1000 \
                      --write_bw_log=$BW_LOG_FILE \
                      --write_iops_log=$IOPS_LOG_FILE \
                      --write_lat_log=$LAT_LOG_FILE"

    # Run the fio command and save output to a file
    echo "Running fio benchmark for size $SIZE..."
    $FIO_COMMAND > "$OUTPUT_FILE"

    echo "Benchmark for size $SIZE completed. Output saved to $OUTPUT_FILE"
done

echo "All benchmarks completed. Running Python script for plotting..."

python3 draw.py

echo "Python script execution completed."
