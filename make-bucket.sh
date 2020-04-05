#!/bin/bash
#
# Make bucket, put encryption, logging, versioning and life cycle
#

#i=ribothrypsis-analysis-jan 
i=$1

echo "Making S3 bucket: $i"

aws s3 mb s3://$ribothrypsis-analysis-jan --region us-east-1

aws s3api put-bucket-encryption --bucket $i --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'

aws s3api put-bucket-logging --bucket $i --bucket-logging-status '{"LoggingEnabled":{"TargetPrefix":"S3logs/'$i'/","TargetBucket":"'mourelatos-lab-general'"}}'

aws s3api put-bucket-versioning --bucket $i --versioning-configuration Status=Enabled

aws s3api put-bucket-lifecycle-configuration --bucket $i --lifecycle-configuration '{"Rules": [{"Status": "Enabled", "Prefix": "", "Transitions": [{"Days": 1, "StorageClass": "GLACIER"}], "ID": "Move files to Glacier after one day."}]}'

