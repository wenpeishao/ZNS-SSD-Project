import json
import glob
import matplotlib.pyplot as plt
import pandas as pd

# Initialize empty lists to store data
seq_reads = []
rand_reads = []
seq_writes = []
rand_writes = []

def block_size_to_bytes(block_size_str):
    size_str = block_size_str[:-1]
    unit = block_size_str[-1].upper()

    size = int(size_str)
    if unit == 'K':
        size *= 1024
    elif unit == 'M':
        size *= 1024 ** 2
    # Add more units if necessary

    return size

# Load and parse each JSON file
for filename in sorted(glob.glob("benchmark_*.json")):
    with open(filename, 'r') as f:
        data = json.load(f)
    
    flag = False
    op_type = data['jobs'][0]['job options']['rw']
    
    if op_type == 'randread':
        op_type = 'read'
        flag = True
    elif op_type == 'randwrite':
        op_type = 'write'
        flag = True

    block_size = data['jobs'][0]['job options']['bs']
    iops = data['jobs'][0][op_type]['iops']
    throughput = data['jobs'][0][op_type]['bw']  # In KB/s

    if op_type == "read":
        if flag:
            rand_reads.append((iops, throughput, block_size))
        else:
            seq_reads.append((iops, throughput, block_size))
    elif op_type == "write":
        if flag:
            rand_writes.append((iops, throughput, block_size))
        else:
            seq_writes.append((iops, throughput, block_size))

# Sort based on block size converted to bytes
seq_reads.sort(key=lambda x: block_size_to_bytes(x[2]))
rand_reads.sort(key=lambda x: block_size_to_bytes(x[2]))
seq_writes.sort(key=lambda x: block_size_to_bytes(x[2]))
rand_writes.sort(key=lambda x: block_size_to_bytes(x[2]))

# Extract sorted block sizes
BLOCK_SIZESS = [x[2] for x in seq_reads]  # assuming seq_reads covers all block sizes

# Create Pandas DataFrame
df = pd.DataFrame({
    'Block_Size': BLOCK_SIZESS,
    'Seq_Read_IOPS': [x[0] for x in seq_reads],
    'Seq_Read_Throughput': [x[1] for x in seq_reads],
    'Rand_Read_IOPS': [x[0] for x in rand_reads],
    'Rand_Read_Throughput': [x[1] for x in rand_reads],
    'Seq_Write_IOPS': [x[0] for x in seq_writes],
    'Seq_Write_Throughput': [x[1] for x in seq_writes],
    'Rand_Write_IOPS': [x[0] for x in rand_writes],
    'Rand_Write_Throughput': [x[1] for x in rand_writes],
})

# Plotting for IOPS
plt.figure()  # Create a new figure
ax = df.plot(x='Block_Size', y=['Seq_Read_IOPS', 'Rand_Read_IOPS', 'Seq_Write_IOPS', 'Rand_Write_IOPS'], kind='line')
plt.title('IOPS for Various Operations')
plt.ylabel('IOPS')
plt.savefig("IOPS_Plot.png")  # Save plot to PNG file
plt.show()

# Plotting for Throughput
plt.figure()  # Create a new figure
ax = df.plot(x='Block_Size', y=['Seq_Read_Throughput', 'Rand_Read_Throughput', 'Seq_Write_Throughput', 'Rand_Write_Throughput'], kind='line')
plt.title('Throughput for Various Operations')
plt.ylabel('Throughput (KB/s)')
plt.savefig("Throughput_Plot.png")  # Save plot to PNG file
plt.show()