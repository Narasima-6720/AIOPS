# VM Health Status Monitor

A shell script to monitor the health status of Ubuntu virtual machines based on CPU, Memory, and Disk usage.

## Features

- Monitors key system resources:
  - CPU usage
  - Memory usage
  - Disk usage
- Provides health status assessment (healthy/unhealthy)
- Supports detailed explanation mode
- Ubuntu-specific checks
- Threshold-based monitoring (60% utilization)

## Prerequisites

- Ubuntu operating system
- Bash shell
- Standard system utilities (`top`, `free`, `df`)

## Installation

1. Clone or download the script to your system
2. Make the script executable:
   ```bash
   chmod +x vm_health_status.sh
   ```

## Usage

### Basic Health Check

To perform a basic health check:

```bash
./vm_health_status.sh
```

This will display:
- Overall VM health status
- Current usage percentages for CPU, Memory, and Disk

### Detailed Explanation

To get a detailed explanation of the health status:

```bash
./vm_health_status.sh explain
```

This will show:
- All basic health check information
- Detailed explanation of why the system is healthy or unhealthy
- Comparison of current usage against thresholds

## How It Works

1. **Ubuntu Check**
   - Verifies if the system is running Ubuntu
   - Exits if not running on Ubuntu

2. **Resource Monitoring**
   - CPU Usage: Uses `top` command to get current CPU utilization
   - Memory Usage: Uses `free` command to calculate memory usage percentage
   - Disk Usage: Uses `df` command to get root partition usage

3. **Health Assessment**
   - Healthy: All resources are below 60% utilization
   - Unhealthy: Any resource exceeds 60% utilization

4. **Explanation Mode**
   - Activated with "explain" argument
   - Provides detailed reasoning for the health status
   - Shows comparison against thresholds

## Thresholds

- CPU Usage: 60%
- Memory Usage: 60%
- Disk Usage: 60%

If any of these thresholds are exceeded, the VM is considered unhealthy.

## Output Example

Basic output:
```
VM Health Status: healthy
Current Usage:
CPU: 25%
Memory: 45%
Disk: 38%
```

With explanation:
```
VM Health Status: healthy
Current Usage:
CPU: 25%
Memory: 45%
Disk: 38%

Explanation: All resources are below 60% utilization threshold:
- CPU usage is 25% (threshold: 60%)
- Memory usage is 45% (threshold: 60%)
- Disk usage is 38% (threshold: 60%)
```
