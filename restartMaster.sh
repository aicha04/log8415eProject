#!/bin/bash
# curl https://raw.githubusercontent.com/aicha04/log8415eProject/main/restartMaster.sh > restartMaster.sh && bash restartMaster.sh
ECSImageId=ami-0574da719dca65348
DebianImageId=ami-050406429a71aaa64
DefaultSecurityGroup=$(aws ec2 describe-security-groups --query "SecurityGroups[].GroupId" --filters Name=group-name,Values=default --output text)
SecurityGroup=$(aws ec2 describe-security-groups --query "SecurityGroups[].GroupId" --filter "Name=group-name,Values=projet" --output text)
echo $SecurityGroup
T2Large_master=$(aws ec2 describe-instances --filters Name=tag:Name,Values=master Name=instance-state-name,Values=running --query "Reservations[].Instances[].[InstanceId]" --output text)
echo $T2Large_master
SubnetId=$(aws ec2 describe-subnets --query 'Subnets'[0].SubnetId --output text) #default Subnet
echo $SubnetId
aws ec2 modify-instance-attribute --instance-id $T2Large_master --groups $DefaultSecurityGroup
aws ec2 terminate-instances --instance-ids $T2Large_master
aws ec2 wait instance-terminated --instance-ids $T2Large_master
#master node
curl https://raw.githubusercontent.com/aicha04/log8415eProject/main/setupMaster.sh > setupMaster.sh
T2Large_master="$(aws ec2 run-instances --image-id $ECSImageId --count 1 --instance-type t2.micro --security-group-ids $SecurityGroup --key-name vockey --user-data file://setupMaster.sh --subnet-id=$SubnetId --private-ip-address 172.31.5.98 --tag-specifications 'ResourceType=instance,Tags= [ {Key=Name,Value=master}]' --query "Instances[].[InstanceId]" --output text)"
echo $T2Large_master