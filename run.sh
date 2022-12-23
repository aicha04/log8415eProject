#!/bin/bash
# curl https://raw.githubusercontent.com/aicha04/log8415eProject/main/run.sh > run.sh && bash run.sh
ECSImageId=ami-0574da719dca65348
DebianImageId=ami-050406429a71aaa64
SubnetId=$(aws ec2 describe-subnets --query 'Subnets'[0].SubnetId --output text) #default Subnet
echo $SubnetId

DefaultSecurityGroup=$(aws ec2 describe-security-groups --query "SecurityGroups[].GroupId" --filters Name=group-name,Values=default --output text)
echo $DefaultSecurityGroup

OldInstances=$(aws ec2 describe-instances --filters Name=instance-state-name,Values=running --query "Reservations[].Instances[].[InstanceId]" --output text)
echo $OldInstances
if [ "$OldInstances" != "" ]; then
    for instance in $OldInstances
    do
        # remove dependency to sg (which means we cant delete sg), this has to be done while the instance is running or stopped (not terminating)
        aws ec2 modify-instance-attribute --instance-id $instance --groups $DefaultSecurityGroup
    done
    aws ec2 terminate-instances --instance-ids $OldInstances
    aws ec2 wait instance-terminated --instance-ids $OldInstances
fi
SecurityGroup=$(aws ec2 describe-security-groups --query "SecurityGroups[].GroupId" --filter "Name=group-name,Values=projet" --output text)

if [ "$SecurityGroup" != "" ]; then
    aws ec2 delete-security-group --group-id $SecurityGroup
fi
    SecurityGroup=$(aws ec2 create-security-group --description "projet" --group-name projet --output text)
    # enable inbound ssh to debug and http for us to view the webapp
    aws ec2 authorize-security-group-ingress --group-id $SecurityGroup --protocol tcp --port 22   --cidr 0.0.0.0/0
    aws ec2 authorize-security-group-ingress --group-id $SecurityGroup --protocol tcp --port 80   --cidr 0.0.0.0/0
    aws ec2 authorize-security-group-ingress --group-id $SecurityGroup --protocol tcp --port 443  --cidr 0.0.0.0/0
    # for downloads, enable http/https outbound
    aws ec2 authorize-security-group-egress  --group-id $SecurityGroup --protocol tcp --port 80   --cidr 0.0.0.0/0
    aws ec2 authorize-security-group-egress  --group-id $SecurityGroup --protocol tcp --port 443  --cidr 0.0.0.0/0
    # for MySQL
    aws ec2 authorize-security-group-egress  --group-id $SecurityGroup --protocol tcp --port 1186  --cidr 0.0.0.0/0
    aws ec2 authorize-security-group-ingress --group-id $SecurityGroup --protocol tcp --port 1186  --cidr 0.0.0.0/0
    aws ec2 authorize-security-group-egress  --group-id $SecurityGroup --protocol tcp --port 3306  --cidr 0.0.0.0/0
    aws ec2 authorize-security-group-ingress --group-id $SecurityGroup --protocol tcp --port 3306  --cidr 0.0.0.0/0
    

#master node
curl https://raw.githubusercontent.com/aicha04/log8415eProject/main/setupMaster.sh > setupMaster.sh
T2Micro_master="$(aws ec2 run-instances --image-id $ECSImageId --count 1 --instance-type t2.micro --security-group-ids $SecurityGroup --key-name vockey --subnet-id=$SubnetId --private-ip-address 172.31.30.98 --tag-specifications 'ResourceType=instance,Tags= [ {Key=Name,Value=master}]' --query "Instances[].[InstanceId]" --output text)"
echo $T2Micro_master

#slave node 1
curl https://raw.githubusercontent.com/aicha04/log8415eProject/main/setupSlave.sh > setupSlave.sh
T2Micro_slaves="$(aws ec2 run-instances --image-id $ECSImageId --count 1 --instance-type t2.micro --security-group-ids $SecurityGroup --key-name vockey --subnet-id=$SubnetId --private-ip-address 172.31.30.99 --tag-specifications 'ResourceType=instance,Tags= [ {Key=Name,Value=slave}]' --query "Instances[].[InstanceId]" --output text)"
echo $T2Micro_slaves
#slave node 2
curl https://raw.githubusercontent.com/aicha04/log8415eProject/main/setupSlave.sh > setupSlave.sh
T2Micro_slaves="$(aws ec2 run-instances --image-id $ECSImageId --count 1 --instance-type t2.micro --security-group-ids $SecurityGroup --key-name vockey --subnet-id=$SubnetId --private-ip-address 172.31.30.100 --tag-specifications 'ResourceType=instance,Tags= [ {Key=Name,Value=slave}]' --query "Instances[].[InstanceId]" --output text)"
echo $T2Micro_slaves
#slave node 3
curl https://raw.githubusercontent.com/aicha04/log8415eProject/main/setupSlave.sh > setupSlave.sh
T2Micro_slaves="$(aws ec2 run-instances --image-id $ECSImageId --count 1 --instance-type t2.micro --security-group-ids $SecurityGroup --key-name vockey --subnet-id=$SubnetId --private-ip-address 172.31.30.101 --tag-specifications 'ResourceType=instance,Tags= [ {Key=Name,Value=slave}]' --query "Instances[].[InstanceId]" --output text)"
echo $T2Micro_slaves

#stand alone instance
curl https://raw.githubusercontent.com/aicha04/log8415eProject/main/setupStandAlone.sh > setupInstance.sh
T2Micro="$(aws ec2 run-instances --image-id $ECSImageId --count 1 --instance-type t2.micro --security-group-ids $SecurityGroup --key-name vockey --user-data file://setupInstance.sh --subnet-id=$SubnetId --tag-specifications 'ResourceType=instance,Tags= [ {Key=Name,Value=StandAlone}]' --query "Instances[].[InstanceId]" --output text)"
echo $T2Micro

#proxy node
curl https://raw.githubusercontent.com/aicha04/log8415eProject/main/setupProxy.sh > setupProxy.sh
T2Large_proxy="$(aws ec2 run-instances --image-id $DebianImageId --count 1 --instance-type t2.large --security-group-ids $SecurityGroup --key-name vockey --user-data file://setupProxy.sh --subnet-id=$SubnetId --tag-specifications 'ResourceType=instance,Tags= [ {Key=Name,Value=proxy}]' --query "Instances[].[InstanceId]" --output text)"
echo $T2Large_proxy

#benchmark node
curl https://raw.githubusercontent.com/aicha04/log8415eProject/main/benchmark.sh > setupBenchmark.sh
T2Micro_benchmark="$(aws ec2 run-instances --image-id $ECSImageId --count 1 --instance-type t2.micro --security-group-ids $SecurityGroup --key-name vockey --user-data file://setupBenchmark.sh --subnet-id=$SubnetId --tag-specifications 'ResourceType=instance,Tags= [ {Key=Name,Value=benchmark}]' --query "Instances[].[InstanceId]" --output text)"
echo $T2Micro_benchmark
