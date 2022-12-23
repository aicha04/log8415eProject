#!/bin/bash
# curl https://raw.githubusercontent.com/aicha04/log8415eProject/main/restartProxy.sh > restartProxy.sh && bash restartProxy.sh
ECSImageId=ami-0574da719dca65348
DebianImageId=ami-050406429a71aaa64
DefaultSecurityGroup=$(aws ec2 describe-security-groups --query "SecurityGroups[].GroupId" --filters Name=group-name,Values=default --output text)
SecurityGroup=$(aws ec2 describe-security-groups --query "SecurityGroups[].GroupId" --filter "Name=group-name,Values=proxy" --output text)
T2Large_proxy=$(aws ec2 describe-instances --filters Name=tag:Name,Values=running --query "Reservations[].Instances[].[InstanceId]" --output text)
SubnetId=$(aws ec2 describe-subnets --query 'Subnets'[0].SubnetId --output text) #default Subnet
echo $SubnetId
aws ec2 modify-instance-attribute --instance-id $T2Large_proxy --groups $DefaultSecurityGroup
aws ec2 terminate-instances --instance-ids $T2Large_proxy
#proxy node
curl https://raw.githubusercontent.com/aicha04/log8415eProject/main/setupProxy.sh > setupProxy.sh
T2Large_proxy="$(aws ec2 run-instances --image-id $DebianImageId --count 1 --instance-type t2.large --security-group-ids $SecurityGroup --key-name vockey --user-data file://setupProxy.sh --subnet-id=$SubnetId --tag-specifications 'ResourceType=instance,Tags= [ {Key=Name,Value=proxy}]' --query "Instances[].[InstanceId]" --output text)"
echo $T2Large_proxy