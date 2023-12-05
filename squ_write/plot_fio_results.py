import sys
import pandas as pd
import matplotlib.pyplot as plt

# Read CSV file path from command line argument
csv_file = sys.argv[1]

# Determine the test type from the filename
test_type = "Random Write" if "randwrite" in csv_file else "Sequential Write"

# Load the data
data = pd.read_csv(csv_file)

# Convert time from milliseconds to minutes for plotting
data['Time (minutes)'] = data['Time (ms)'] / 60000

# Plotting
plt.figure(figsize=(10, 6))
for bs in data['Block Size (KB)'].unique():
    subset = data[data['Block Size (KB)'] == bs]
    plt.plot(subset['Time (minutes)'], subset['Throughput (MiB/s)'], marker='o', label=f'BS: {bs}KB')

plt.title(f'SSD Performance: {test_type} Throughput vs Time')
plt.xlabel('Time (minutes)')
plt.ylabel('Throughput (MiB/s)')
plt.legend()
plt.grid(True)
plt.savefig(f'performance_plot_{test_type}.png')
plt.show()
