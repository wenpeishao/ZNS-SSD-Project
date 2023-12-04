# SSD Performance Benchmark

## Overview

This document outlines the process and methodology for conducting a performance benchmark of an SSD using the fio tool. The goal is to measure the SSD's performance under various conditions, with a focus on understanding the impact of different block sizes and observing how the SSD manages garbage collection.

## Prerequisites

- **SSD Preparation**: Ensure the SSD is properly connected to the system and recognized by the operating system.
- **Benchmarking Tool**: We will use `fio` (Flexible I/O Tester), a versatile tool for measuring and analyzing I/O performance.
- **System State**: Close unnecessary applications and services that might affect the benchmarking results.

## Environments

- **OS**: ULinux version 6.2.0-34-generic (buildd@lcy02-amd64-025) (x86_64-linux-gnu-gcc-12 (Ubuntu 12.3.0-1ubuntu1~23.04) 12.3.0, GNU ld (GNU Binutils for Ubuntu) 2.40)
- **SSD**: samsung 970 evo plus 2TB
- **Processor**: 8th Generation Intel® Core™ i7-8750H Processor (2.20 GHz, up to 4.10 GHz with Turbo Boost, 6 Cores, 12 Threads, 9 MB Cache)
- **Graphics**: NVIDIA® GeForce® GTX 1050 Ti Max-Q 4GB
- **Memory**: 32 GB DDR4 2667MHz

## Benchmark Procedure

### 1. Preparation

The SSD is first reset using the blkdiscard command to ensure a consistent starting state for each test.
The device used for the tests is identified as SSD_DEVICE, set to /dev/nvme0n1.

### 2. Test Parameters

Block Sizes Tested: 4 KB, 128 KB, 512 KB, 1024 KB.
I/O Engine: io_uring, chosen for its efficiency and modern approach to handling I/O operations.
Read/Write Pattern: Random write (randwrite) to simulate a workload that is more demanding and representative of real-world usage.
I/O Depth: Set to 1 for simplicity and to mimic common single-user operational loads.
Runtime: Each test runs for 900 seconds (15 minutes) to provide enough time for performance trends to emerge.
Logging: Bandwidth logs are captured every 1000 milliseconds to monitor throughput over time.

### 3. Test Execution

For each block size in BLOCK_SIZES, the following process is executed:
Reset the SSD using reset_ssd function.
Execute the fio test with the specified parameters.
Capture and log the performance data in individual log files named according to the block size.
Clean up the log files after processing.

### 4. Data Processing and Analysis

The performance data from each test are compiled into a CSV file, fio_results.csv.
A Python script, plot_fio_results.py, is used to plot the results for visualization and analysis.

### 5. Observations

- TODO

## Conclusion

This benchmark provides valuable insights into the performance characteristics of the SSD under different operational conditions, particularly regarding how block size affects performance and how the SSD handles sustained random write workloads.
