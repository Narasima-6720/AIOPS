#!/bin/bash

####################

# Author: Narasimha Reddy
# Date: 2025-04-11
# Description: This script creates a VPC with public subnets in AWS or deletes them.
# Usage: ./aws_vpc_creation.sh create (Create the VPC and subnet)
#        ./aws_vpc_creation.sh delete (Delete the VPC and subnet)

#######################

# Variables
VPC_NAME="MyVPC"
VPC_CIDR="10.0.0.0/16"
SUBNET_CIDR="10.0.1.0/24"
REGION="ap-south-1"
SUBNET_NAME="MySubnet"
IGW_NAME="MyInternetGateway"

############################

# Check if the AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI could not be found. Please install it to use this script."
    exit 1
fi

# Check if AWS CLI is configured
if ! aws sts get-caller-identity &> /dev/null; then
    echo "AWS CLI is not configured. Please configure it to use this script."
    exit 1
fi

# Function to create VPC and Subnet
create_vpc_subnet() {
    # Check if a VPC with the same name already exists
    EXISTING_VPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=$VPC_NAME" --region $REGION --query 'Vpcs[0].VpcId' --output text)
    if [ "$EXISTING_VPC_ID" != "None" ]; then
        echo "A VPC with the name $VPC_NAME already exists with ID: $EXISTING_VPC_ID"
        exit 1
    fi

    # Create VPC
    echo "Creating VPC..."
    VPC_ID=$(aws ec2 create-vpc --cidr-block $VPC_CIDR --region $REGION --query 'Vpc.VpcId' --output text)
    if [ "$VPC_ID" == "None" ]; then
        echo "Failed to create VPC."
        exit 1
    fi
    echo "VPC created with ID: $VPC_ID"

    # Tag the VPC
    aws ec2 create-tags --resources $VPC_ID --tags Key=Name,Value=$VPC_NAME --region $REGION

    # Create Subnet
    echo "Creating Subnet..."
    SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $SUBNET_CIDR --region $REGION --query 'Subnet.SubnetId' --output text)
    if [ "$SUBNET_ID" == "None" ]; then
        echo "Failed to create Subnet."
        exit 1
    fi
    echo "Subnet created with ID: $SUBNET_ID"

    # Tag the Subnet
    aws ec2 create-tags --resources $SUBNET_ID --tags Key=Name,Value=$SUBNET_NAME --region $REGION
    echo "VPC and Subnet created and tagged successfully."
}

# Function to delete VPC and Subnet
delete_vpc_subnet() {
    # Fetch the VPC ID dynamically
    VPC_ID=$(aws ec2 describe-vpcs --filters "Name=tag:Name,Values=$VPC_NAME" --region $REGION --query 'Vpcs[0].VpcId' --output text)
    if [ "$VPC_ID" == "None" ]; then
        echo "No VPC found with the name $VPC_NAME."
        exit 1
    fi

    # Fetch the Subnet ID dynamically
    SUBNET_ID=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=$SUBNET_NAME" --region $REGION --query 'Subnets[0].SubnetId' --output text)
    if [ "$SUBNET_ID" == "None" ]; then
        echo "No Subnet found with the name $SUBNET_NAME."
        exit 1
    fi

    # Delete Subnet
    echo "Deleting Subnet..."
    aws ec2 delete-subnet --subnet-id $SUBNET_ID --region $REGION
    echo "Subnet deleted with ID: $SUBNET_ID"

    # Delete VPC
    echo "Deleting VPC..."
    aws ec2 delete-vpc --vpc-id $VPC_ID --region $REGION
    echo "VPC deleted with ID: $VPC_ID"

    echo "VPC and Subnet deleted successfully."
}

# Main logic
if [ "$1" == "create" ]; then
    create_vpc_subnet
elif [ "$1" == "delete" ]; then
    delete_vpc_subnet
else
    echo "Invalid argument. Use 'create' to create the VPC and Subnet or 'delete' to delete them."
    echo "Usage: $0 create|delete"
    exit 1
fi
