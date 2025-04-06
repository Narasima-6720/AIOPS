#!/bin/bash

# VM Health Status Monitor
# This script analyzes CPU, Memory, and Disk usage of Ubuntu VMs

# Function to get CPU usage
get_cpu_usage() {
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d. -f1)
    echo "$cpu_usage"
}

# Function to get Memory usage
get_memory_usage() {
    memory_usage=$(free | grep Mem | awk '{print int($3/$2 * 100)}')
    echo "$memory_usage"
}

# Function to get Disk usage
get_disk_usage() {
    disk_usage=$(df -h / | awk 'NR==2 {print int($5)}')
    echo "$disk_usage"
}

# Function to check if system is Ubuntu
check_ubuntu() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [[ "$ID" == "ubuntu" ]]; then
            return 0
        fi
    fi
    return 1
}

# Main execution
main() {
    # Check if running on Ubuntu
    if ! check_ubuntu; then
        echo "Error: This script only supports Ubuntu systems"
        exit 1
    fi

    # Get resource usage
    cpu=$(get_cpu_usage)
    memory=$(get_memory_usage)
    disk=$(get_disk_usage)

    # Initialize health status
    health_status="healthy"
    reasons=""

    # Check CPU
    if [ "$cpu" -gt 60 ]; then
        health_status="unhealthy"
        reasons="$reasons\nCPU usage is high at ${cpu}%"
    fi

    # Check Memory
    if [ "$memory" -gt 60 ]; then
        health_status="unhealthy"
        reasons="$reasons\nMemory usage is high at ${memory}%"
    fi

    # Check Disk
    if [ "$disk" -gt 60 ]; then
        health_status="unhealthy"
        reasons="$reasons\nDisk usage is high at ${disk}%"
    fi

    # Output results
    echo "VM Health Status: $health_status"
    echo "Current Usage:"
    echo "CPU: ${cpu}%"
    echo "Memory: ${memory}%"
    echo "Disk: ${disk}%"

    # If explain argument is provided, show detailed explanation
    if [ "$1" == "explain" ]; then
        if [ "$health_status" == "healthy" ]; then
            echo -e "\nExplanation: All resources are below 60% utilization threshold:"
            echo "- CPU usage is ${cpu}% (threshold: 60%)"
            echo "- Memory usage is ${memory}% (threshold: 60%)"
            echo "- Disk usage is ${disk}% (threshold: 60%)"
        else
            echo -e "\nExplanation: System is unhealthy due to:"
            echo -e "$reasons"
        fi
    fi
}

# Execute main function with all arguments
main "$@"
