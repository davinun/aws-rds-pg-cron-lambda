# aws-rds-pg-cron-lambda
## What is aws-rds-pg-cron-lambda?
An AWS lambda to replace the PostgreSQL [pg_cron extension](https://github.com/citusdata/pg_cron) when using AWS Postgres RDS.

AWS Postgres RDS does not support pg_cron.
[pg_cron](https://github.com/citusdata/pg_cron) is a simple cron-based job scheduler for PostgreSQL (9.5 or higher) that runs inside the database as an extension. It uses the same syntax as regular cron, but it allows you to schedule PostgreSQL commands directly from the database.

- The Lambda should run in the same VPC / subnets as the RDS DB
- The Lambda will be invoked by CloudWatch event every hour (todo - add flexible scheduling)
- The Lambda will connect to the RDS DB and execute a set of queries

## Deploying the Lambda
Prepare:
- an S3 bucket for the ZIP of the Lambda
- update the deploy-lambda.sh file with all the relevant parameters

run ./deploy-lambda.sh 

## Deployment will:
1. ZIP the Lambda sources to a file called **pg_cron_lambda.zip** under the **target** directory
2. Upload the ZIP to the given S3 bucket
3. Create a CloudFormation stack with:

* A Security Group allowing the Lambda to access the RDS
* An IAM Role allowing the Lambda to run in your VPC and access the RDS
* The Lambda itself with the ZIP above and the defined environment variables
* A CloudWatch event that will trigger the Lambda every hour





