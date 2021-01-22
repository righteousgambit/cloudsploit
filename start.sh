cd /var/scan/cloudsploit

#If running ECS task or other AWS workload with appropriate execution/task role, then it will automatically assume the role
aws sts assume-role --role-arn $ASSUME_ROLE_ARN --external-id $EXTERNAL_ID --role-session-name $CLIENT_ID > assumed-role.txt


export AWS_ACCESS_KEY_ID=$(cat assumed-role.txt | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(cat assumed-role.txt | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(cat assumed-role.txt | jq -r '.Credentials.SessionToken')

#aws configure set aws_access_key_id $ACCESS_KEY_ID_ASSUMED_ROLE --profile $CLIENT_ID
#aws configure set aws_secret_access_key $SECRET_ACCESS_KEY_ASSUMED_ROLE --profile $CLIENT_ID
#aws configure set aws_session_token $SESSION_TOKEN_ASSUMED_ROLE --profile $CLIENT_ID
#aws configure set default.region us-east-1 --profile $CLIENT_ID



#Run CloudSploit
./index.js --output=csv --console=table

#Output Results to s3
aws s3 cp . s3://automatedscanresults/$CLIENT_ID/$PROJECT_ID/cloudsploit
