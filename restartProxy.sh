#!/bin/bash
aws ec2 modify-instance-attribute --instance-id $T2Large_proxy --groups $DefaultSecurityGroup
aws ec2 terminate-instances --instance-ids $T2Large_proxy
#proxy node
curl https://raw.githubusercontent.com/aicha04/log8415eProject/main/setupProxy.sh > setupProxy.sh
T2Large_proxy="$(aws ec2 run-instances --image-id $DebianImageId --count 1 --instance-type t2.large --security-group-ids $SecurityGroup --key-name vockey --user-data file://setupProxy.sh --subnet-id=$SubnetId --tag-specifications 'ResourceType=instance,Tags= [ {Key=Name,Value=proxy}]' --query "Instances[].[InstanceId]" --output text)"
echo $T2Large_proxy