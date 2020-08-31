#!/bin/bash
#
# General script to run the backup to S3
#

cd /home/joppelt/playground/amazon_backup/

echo "Manolis"

echo "fly_RK"
echo "data-local"
./s3-sync-general.sh configs/mns/s3-sync-data-local.fly_RK.config
echo "main"
./s3-sync-general.sh configs/mns/s3-sync-main.fly_RK.config
echo "analysis"
./s3-sync-general.sh configs/mns/s3-sync-analysis.fly_RK.config
echo "data"
./s3-sync-general.sh configs/mns/s3-sync-data.fly_RK.config
echo "samples"
./s3-sync-general.sh configs/mns/s3-sync-samples.fly_RK.config

echo "mouse_FUS"
echo "data-local"
./s3-sync-general.sh configs/mns/s3-sync-data-local.mouse_FUS.config
echo "main"
./s3-sync-general.sh configs/mns/s3-sync-main.mouse_FUS.config
echo "analysis"
./s3-sync-general.sh configs/mns/s3-sync-analysis.mouse_FUS.config
echo "data"
./s3-sync-general.sh configs/mns/s3-sync-data.mouse_FUS.config
echo "samples"
./s3-sync-general.sh configs/mns/s3-sync-samples.mouse_FUS.config

echo "human_HRI"
echo "data-local"
./s3-sync-general.sh configs/mns/s3-sync-data-local.human_HRI.config
echo "main"
./s3-sync-general.sh configs/mns/s3-sync-main.human_HRI.config
echo "analysis"
./s3-sync-general.sh configs/mns/s3-sync-analysis.human_HRI.config
echo "data"
./s3-sync-general.sh configs/mns/s3-sync-data.human_HRI.config
echo "samples"
./s3-sync-general.sh configs/mns/s3-sync-samples.human_HRI.config

# echo "akron"
# echo "data-local"
# ./s3-sync-general.sh configs/mns/s3-sync-data-local.akron.config
# echo "main"
# ./s3-sync-general.sh configs/mns/s3-sync-main.akron.config
# echo "analysis"
# ./s3-sync-general.sh configs/mns/s3-sync-analysis.akron.config
# echo "data"
# ./s3-sync-general.sh configs/mns/s3-sync-data.akron.config
# echo "samples"
# ./s3-sync-general.sh configs/mns/s3-sync-samples.akron.config


####################################################################################################
echo "Panos"

echo "All directories - Ago, Akron, tools"
./s3-sync-general.sh configs/pan.alexiou/s3-sync-all.ago.config
./s3-sync-general.sh configs/pan.alexiou/s3-sync-all.akron.config
./s3-sync-general.sh configs/pan.alexiou/s3-sync-all.tools.config
./s3-sync-general.sh configs/pan.alexiou/s3-sync-all.simulation.config

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