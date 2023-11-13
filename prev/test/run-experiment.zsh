#!/bin/zsh

# Define the range of write loads (e.g., write percentage)
for write_percentage in 10 20 30 40 50
do
    # Update the fio configuration file with the current write load
    sed -i '' "s/rwmixread=[0-9]*/rwmixread=$write_percentage/" mixed-workload.fio
    
    # Run fio with the updated configuration
    fio mixed-workload.fio > output_$write_percentage.json
    
    # Extract and record the read latency from the fio output
    read_latency=$(jq '.jobs[0].read.clat_ns.mean' output_$write_percentage.json)
    echo "Write Percentage: $write_percentage, Read Latency (ns): $read_latency" >> experiment_results.txt
done

# Optional: Restore the original fio configuration file
mv mixed-workload.fio.bak mixed-workload.fio

