#!/bin/bash
#
# Make bucket, put encryption, logging, versioning and life cycle
# Loggin is optional and only turned on if the second argument for the script is set as 'true'
# keeping non-current version is optional, for example for data which you never want to delete 
#   (non-current version are kept forever to avoid losing the data) - third argument to 'true'
#

source /home/joppelt/tools/amazonS3/bin/activate

#i=ribothrypsis-analysis-jan
i=$1 # bucket name
if [[ $# == 2 ]]; then # AWS logs
    log=$2
else
    log='false' # default
fi
if [[ $# == 3 ]]; then # keeping all version forever
    keep=$3
else
    keep='false' # default
fi

echo "Making S3 bucket: $i"

# Note: If you get error "make_bucket failed: s3://jan-test An error occurred (IllegalLocationConstraintException) when calling the CreateBucket operation: The unspecified location constraint is incompatible for the region specific endpoint this request was sent to."
#           it's very likely a bucket with this name already exists somewhere on AWS cloud and you'll have to change the name. Bucket names HAS to be unique across AWS cloud.
if [[ `aws s3 mb s3://$i --region us-east-1` ]]; then
    echo "Bucket created successfully or already existed, continue."
else
    echo "Something happened during the bucket initiation/creation. First, please check the name which has to be unique across the AWS (for everyone), exiting."; exit 1
fi

aws s3api put-bucket-encryption --bucket $i --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'

if [[ $log == "true" ]]; then
    echo "Logging: enabled."
    aws s3api put-bucket-logging --bucket $i --bucket-logging-status '{"LoggingEnabled":{"TargetPrefix":"S3logs/'$i'/","TargetBucket":"'mourelatos-lab-general'"}}'
elif [[ $log == "false" ]]; then
    echo "Logging: disabled (default)."
else
    echo "Don't know if logging should be enabled. Please use only 'true' or 'false' as a second argument for the script or use only one argument (defauls to 'false')"
    exit 1
fi

aws s3api put-bucket-versioning --bucket $i --versioning-configuration Status=Enabled

# Add archiving after 3 day from upload to glacier
# The timing (90 to deep glacier and 270 to delete) is based on minimum time in storages - for glacier it's 90 days, for deep glacier it's 180 days
#aws s3api put-bucket-lifecycle-configuration --bucket $i --lifecycle-configuration '{"Rules": [{"Status": "Enabled", "Prefix": "", "Transitions": [{"Days": 3, "StorageClass": "GLACIER"}], "ID": "Move files to Glacier after one day."}]}'
# Add archiving after 3 days from upload and add move of noncurrent version to deep glacier after 90 days and expiration of non-current version after 180 days
if [[ $keep == "true" ]]; then
    echo "Never deleting non-current version."
    # never deleting non-current (precious data)
    aws s3api put-bucket-lifecycle-configuration --bucket $i \
    --lifecycle-configuration '{"Rules": [{"Status": "Enabled", "ID": "Move files to Glacier after 3 days,  non-current version to Deep Glacier after 90 days, never remove non-current versions.", "Prefix": "", "Transitions": [{"Days": 3, "StorageClass": "GLACIER"}], "NoncurrentVersionTransitions": [{"NoncurrentDays": 90, "StorageClass": "DEEP_ARCHIVE"}]}]}'
elif [[ $keep == "false" ]]; then
    # deleting non-current version after 270 days (limit of Glacier 90 + Deep Glacier 180)
    echo "Deleting non-current version after 270 days (default)."
    aws s3api put-bucket-lifecycle-configuration --bucket $i \
    --lifecycle-configuration '{"Rules": [{"Status": "Enabled", "ID": "Move files to Glacier after 3 days,  non-current version to Deep Glacier after 90 days, remove non-current versions after 270 days.", "Prefix": "", "Transitions": [{"Days": 3, "StorageClass": "GLACIER"}], "NoncurrentVersionTransitions": [{"NoncurrentDays": 90, "StorageClass": "DEEP_ARCHIVE"}], "NoncurrentVersionExpiration": {"NoncurrentDays": 270}}]}'
fi