import pandas as pd
import matplotlib.pyplot as plt
import os

def read_fio_log(file_name):
    if not os.path.exists(file_name):
        print(f"File {file_name} not found.")
        return None
    
    # Reading the log file into a DataFrame
    data = pd.read_csv(file_name, sep=',', usecols=[0, 1], names=['Time', 'Throughput'], header=None)
    return data

def plot_throughput(data, title, file_name):
    plt.figure(figsize=(12, 6))
    plt.plot(data['Time'], data['Throughput'], label='Throughput over Time')
    plt.xlabel('Time (ms)')
    plt.ylabel('Throughput (KiB/s)')
    plt.title(title)
    plt.legend()
    plt.grid(True)
    plt.savefig(file_name)
    plt.close()

# Sizes array
#sizes = ["2G", "5G", "10G", "20G","50G", "100G", "200G", "500G", "1000G"]
#sizes = ["2G", "5G", "10G", "20G"]
#sizes = ["2G", "3G", "4G", "5G", "6G", "7G", "8G", "9G", "10G"]
#sizes = ["100G"]
sizes = ["1000G"]


# Loop through each size and plot the throughput
for size in sizes:
    log_file = f'write_test_bw_{size}.log_bw.1.log'
    bw_data = read_fio_log(log_file)

    if bw_data is not None:
        plot_title = f'SSD Throughput Over Time for {size}'
        png_file = f'throughput_{size}.png'
        plot_throughput(bw_data, plot_title, png_file)
        print(f"Plot saved as {png_file}")
    else:
        print(f"Error: Unable to read log file for size {size}.")
