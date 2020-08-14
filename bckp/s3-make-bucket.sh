#!/bin/bash
#
# Make bucket, put encryption, logging, versioning and life cycle
#

source /home/joppelt/playground/amazonS3/bin/activate

#i=ribothrypsis-analysis-jan 
i=$1

echo "Making S3 bucket: $i"

aws s3 mb s3://$i --region us-east-1

aws s3api put-bucket-encryption --bucket $i --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'

aws s3api put-bucket-logging --bucket $i --bucket-logging-status '{"LoggingEnabled":{"TargetPrefix":"S3logs/'$i'/","TargetBucket":"'mourelatos-lab-general'"}}'

aws s3api put-bucket-versioning --bucket $i --versioning-configuration Status=Enabled

# Add archiving after 3 day from upload
#aws s3api put-bucket-lifecycle-configuration --bucket $i --lifecycle-configuration '{"Rules": [{"Status": "Enabled", "Prefix": "", "Transitions": [{"Days": 3, "StorageClass": "GLACIER"}], "ID": "Move files to Glacier after one day."}]}'
# Add archiving after 3 days from upload and add move of noncurrent version to deep glacier after 90 days and expiration of non-current version after 365 days
aws s3api put-bucket-lifecycle-configuration --bucket $i \
--lifecycle-configuration '{"Rules": [{"Status": "Enabled", "ID": "Move files to Glacier after 3 days,  non-current version to Deep Glacier after 90 days, remove non-current versions after 365 days.", "Prefix": "", "Transitions": [{"Days": 3, "StorageClass": "GLACIER"}], "NoncurrentVersionTransitions": [{"NoncurrentDays": 90, "StorageClass": "DEEP_ARCHIVE"}], "NoncurrentVersionExpiration": {"NoncurrentDays": 365}}]}'