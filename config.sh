# The AWS region where the RDS is deployed and the Lambda should run
aws_region="eu-central-1"

# A bucket for the code of the lambda.
# The installation script will automatically upload the lambda code to the bucket
s3_bucket="dror-avinun-bucket"
s3_key="pg_cron_lambda.zip"

# The name of the stack and a prefix to the name of all the resources in this stack
my_prefix="drordel51"

# The VPC where the RDS is running and the Lambda should run
my_vpc="vpc-42096429"

# The subnets in the VPC where the RDS is running
my_subnets="subnet-a950c2d4\\,subnet-7759323a"

####################################
# Environment variables for the lambda
####################################
# A scheduled expression for the Lambda
# example: https://docs.aws.amazon.com/lambda/latest/dg/tutorial-scheduled-events-schedule-expressions.html
my_schedule="rate(1 hour)"

# Database connection data
my_db_endpoint="rdsrnd.example.com"
my_db_port="5432"
my_database="mydb"
my_dbuser="mydb"
my_dbpassword="mydb"

# A comma separated list of queries to run on the database
my_query="SELECT MERGE_INTO_TERMINAL_ACTIVE()\,SELECT REFRESH_TERMINAL_CNT()\,SELECT CLEAN_PURGE_UPD_FILE_TRACK()"

####################################
# Tags for the CloudFormation stack and its resources
####################################
tag_owner="Dror Avinun"
tag_team="Architects"