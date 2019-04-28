#!/bin/bash

cd src

zip -r9 ../pg_cron_lambda.zip .

cd ..

aws s3 cp pg_cron_lambda.zip s3://dror-avinun-bucket/pg_cron_lambda.zip

aws cloudformation create-stack --stack-name drordel23 \
--template-body file://./cloudformation/rds_cron_lambda_cf.json \
--parameters \
ParameterKey=Prefix,ParameterValue=drordel23 \
ParameterKey=VpcId,ParameterValue=vpc-0b0fa98e6f5394a83 \
ParameterKey=Subnets,ParameterValue=subnet-06fbcaf35b65cd731\\,subnet-0a77a9930f159ffb6 \
ParameterKey=S3Bucket,ParameterValue=dror-avinun-bucket \
ParameterKey=S3Key,ParameterValue=pg_cron_lambda.zip \
ParameterKey=DBENDPOINT,ParameterValue=myrds.example.com \
ParameterKey=DBPORT,ParameterValue=5432 \
ParameterKey=DATABASE,ParameterValue=dror \
ParameterKey=DBUSER,ParameterValue=dror \
ParameterKey=DBPASSWORD,ParameterValue=dror \
--capabilities CAPABILITY_NAMED_IAM

