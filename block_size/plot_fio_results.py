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

# Plotting with a larger figure size
plt.figure(figsize=(60, 40))
for bs in data['Block Size (KB)'].unique():
    subset = data[data['Block Size (KB)'] == bs]
    # Adjusted linewidth for thinner lines
    plt.plot(subset['Time (minutes)'], subset['Throughput (MiB/s)'], label=f'BS: {bs}KB', linewidth=1)

plt.title(f'SSD Performance: {test_type} Throughput vs Time')
plt.xlabel('Time (minutes)')
plt.ylabel('Throughput (MiB/s)')
plt.legend()
plt.grid(True)

# Save the plot to a file
plt.savefig(f'performance_plot_{test_type}.png', dpi=300)

# Comment out or remove this line to prevent the plot from being displayed
# plt.show()
