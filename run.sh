#!/bin/bash
#
# General script to run the backup to S3
#

cd /mnt/mourelatos11/playground/amazon_backup/

./s3-sync-general.sh s3-sync-data-local.config
./s3-sync-general.sh s3-sync-analysis.config
./s3-sync-general.sh s3-sync-samples.config
./s3-sync-general.sh s3-sync-data.config
./s3-sync-general.sh s3-sync-main.config