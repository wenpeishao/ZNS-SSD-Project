import sys
import pandas as pd
import matplotlib.pyplot as plt

# Adjustments to handle large number of data points
plt.rcParams['agg.path.chunksize'] = 10000  # Increase the chunksize
plt.rcParams['path.simplify_threshold'] = 0.2  # Increase the path simplification threshold

# Read CSV file path from command line argument
csv_file = sys.argv[1]

# Determine the test type from the filename
if "randwrite" in csv_file:
    test_type = "Random_Write"
elif "randread" in csv_file:
    test_type = "Random_Read"
elif "write" in csv_file:
    test_type = "Sequential_Write"
elif "read" in csv_file:
    test_type = "Sequential_Read"
elif "randrw" in csv_file:
    test_type = "Mixed_Random_Read_Write"
else:
    test_type = "Unknown Test Type"

# Load the data
data = pd.read_csv(csv_file)

# Convert time from milliseconds to minutes for plotting
data['Time (minutes)'] = data['Time (ms)'] / 60000

# Plotting with a larger figure size
plt.figure(figsize=(15, 10))
for bs in data['Block Size (KB)'].unique():
    subset = data[data['Block Size (KB)'] == bs]
    plt.plot(subset['Time (minutes)'], subset['Throughput (MiB/s)'], label=f'BS: {bs}KB', linewidth=1)

plt.title(f'SSD Performance: {test_type} Throughput vs Time')
plt.xlabel('Time (minutes)')
plt.ylabel('Throughput (MiB/s)')
plt.legend()
plt.grid(True)

# Save the plot to a file
plt.savefig(f'performance_plot_{test_type}.png', dpi=1000)

# Uncomment the line below if you want to display the plot
# plt.show()
