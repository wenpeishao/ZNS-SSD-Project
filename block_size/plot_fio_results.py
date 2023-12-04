import sys
import pandas as pd
import matplotlib.pyplot as plt

# Read CSV file path from command line argument
csv_file = sys.argv[1]

# Load the data
data = pd.read_csv(csv_file)

# Plotting
plt.figure(figsize=(10, 6))
for bs in data['Block Size (KB)'].unique():
    subset = data[data['Block Size (KB)'] == bs]
    plt.plot(subset['Data Written (GB)'], subset['Throughput (MiB/s)'], marker='o', label=f'BS: {bs}KB')

plt.title('SSD Performance: Throughput vs Data Written')
plt.xlabel('Data Written (GB)')
plt.ylabel('Throughput (MiB/s)')
plt.legend()
plt.grid(True)
plt.savefig('performance_plot.png')
plt.show()
