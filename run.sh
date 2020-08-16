#!/bin/bash
#
# General script to run the backup to S3
#

cd /home/joppelt/playground/amazon_backup/

echo "rna_degradation"

echo "Data local"
./s3-sync-general.sh s3-sync-data-local.rna_degradation.config
echo "Analysis"
./s3-sync-general.sh s3-sync-analysis.rna_degradation.config
echo "Samples"
./s3-sync-general.sh s3-sync-samples.rna_degradation.config
echo "Data"
./s3-sync-general.sh s3-sync-data.rna_degradation.config
echo "Main"
./s3-sync-general.sh s3-sync-main.rna_degradation.config

exit

echo "pirna_mouse"

echo "Data local"
./s3-sync-general.sh s3-sync-data-local.config
echo "Analysis"
./s3-sync-general.sh s3-sync-analysis.config
echo "Samples"
./s3-sync-general.sh s3-sync-samples.config
echo "Data"
./s3-sync-general.sh s3-sync-data.config
echo "Main"
./s3-sync-general.sh s3-sync-main.config
