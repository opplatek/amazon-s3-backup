#!/bin/bash
#
# General script to run the backup to S3
#

cd /home/joppelt/playground/amazon_backup/

echo " Miwi"
echo "data-local"
./s3-sync-general.sh configs/pan.alexiou/s3-sync-data-local.miwi.config
echo "data"
./s3-sync-eneral.sh configs/pan.alexiou/s3-sync-data.miwi.config
echo "main"
./s3-sync-general.sh configs/pan.alexiou/s3-sync-main.miwi.config
echo "analysis"
./s3-sync-general.sh configs/pan.alexiou/s3-sync-analysis.miwi.config
echo "samples"
./s3-sync-general.sh configs/pan.alexiou/s3-sync-samples.miwi.config

echo "JWYG-Mov10CLIP"
echo "data"
./s3-sync-general.sh configs/pan.alexiou/s3-sync-data.small_projects-JWYG-Mov10CLIP.config
echo "main"
./s3-sync-general.sh configs/pan.alexiou/s3-sync-main.small_projects-JWYG-Mov10CLIP.config
echo "Analysis"
./s3-sync-general.sh configs/pan.alexiou/s3-sync-analysis.small_projects-JWYG-Mov10CLIP.config
echo "samples"
./s3-sync-general.sh configs/pan.alexiou/s3-sync-samples.small_projects-JWYG-Mov10CLIP.config

echo "Small projects"
echo "KE-Mov10CLIP"
./s3-sync-general.sh configs/pan.alexiou/s3-sync-all.small_projects-KE-Mov10CLIP.config
echo "m1A_peaks"
./s3-sync-general.sh configs/pan.alexiou/s3-sync-all.small_projects-m1A_peaks.config
# echo "star_chimeric"
# ./s3-sync-general.sh configs/pan.alexiou/s3-sync-all.small_projects-star_chimeric.config
# echo "chimeric_reads_paper"
# echo "data"
# ./s3-sync-general.sh configs/pan.alexiou/s3-sync-data.small_projects-chimeric_reads_paper.config
# echo "main"
# ./s3-sync-general.sh configs/pan.alexiou/s3-sync-main.small_projects-chimeric_reads_paper.config
# echo "analysis"
# ./s3-sync-general.sh configs/pan.alexiou/s3-sync-analysis.small_projects-chimeric_reads_paper.config

echo "DDX3"
echo "data-local"
./s3-sync-general.sh configs/pan.alexiou/s3-sync-data-local.ddx3.config
echo "main"
./s3-sync-general.sh configs/pan.alexiou/s3-sync-main.ddx3.config
echo "analysis"
./s3-sync-general.sh configs/pan.alexiou/s3-sync-analysis.ddx3.config
echo "samples"
./s3-sync-general.sh configs/pan.alexiou/s3-sync-samples.ddx3.config
echo "data"
./s3-sync-general.sh configs/pan.alexiou/s3-sync-data.ddx3.config