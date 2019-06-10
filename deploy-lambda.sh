#!/bin/bash

echo "Loading configurations..."
. config.sh

echo "Creating the S3 bucket for the lambda ZIP..."
aws s3api create-bucket --bucket $s3_bucket --region $aws_region --create-bucket-configuration LocationConstraint=$aws_region

echo "Building a ZIP with all the sources of the Lambda..."
mkdir -p target
cd src
zip -r9 ../target/$s3_key .

echo "Uploading the Lambda ZIP to S3"
cd ..
aws s3 cp ./target/$s3_key s3://$s3_bucket/$s3_key

echo "Uploading the CloudFormation template to S3"
aws s3 cp ./cloudformation/rds_cron_lambda_cf.json s3://$s3_bucket/rds_cron_lambda_cf.json

echo "Creating the CloudFormation Stack to create the Lambda and all relevant resources..."
aws cloudformation create-stack --stack-name $my_prefix \
--template-body file://./cloudformation/rds_cron_lambda_cf.json \
--parameters \
ParameterKey=Prefix,ParameterValue="$my_prefix" \
ParameterKey=VpcId,ParameterValue="$my_vpc" \
ParameterKey=Subnets,ParameterValue="$my_subnets" \
ParameterKey=Schedule,ParameterValue="$my_schedule" \
ParameterKey=S3Bucket,ParameterValue="$s3_bucket" \
ParameterKey=S3Key,ParameterValue="$s3_key" \
ParameterKey=DBENDPOINT,ParameterValue="$my_db_endpoint" \
ParameterKey=DBPORT,ParameterValue="$my_db_port" \
ParameterKey=DATABASE,ParameterValue="$my_database" \
ParameterKey=DBUSER,ParameterValue="$my_dbuser" \
ParameterKey=DBPASSWORD,ParameterValue="$my_dbpassword" \
ParameterKey=DBQUERY,ParameterValue="$my_query" \
--tags \
Key=Owner,Value="$tag_owner" \
Key=Team,Value="$tag_team" \
--capabilities CAPABILITY_NAMED_IAM


