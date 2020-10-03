#!/bin/bash
#
# General script to run the backup to S3
#

cd /home/joppelt/playground/amazon_backup/

####################################################################################################
echo "Jan"

echo "ribothrypsis"
echo "Data local"
./s3-sync-general.sh configs/s3-sync-data-local.ribothrypsis.config
echo "Analysis"
./s3-sync-general.sh configs/s3-sync-analysis.ribothrypsis.config
echo "Samples"
./s3-sync-general.sh configs/s3-sync-samples.ribothrypsis.config
echo "Data"
./s3-sync-general.sh configs/s3-sync-data.ribothrypsis.config
echo "Main"
./s3-sync-general.sh configs/s3-sync-main.ribothrypsis.config

echo "rna_degradation"
echo "Data local"
./s3-sync-general.sh configs/s3-sync-data-local.rna_degradation.config
echo "Analysis"
./s3-sync-general.sh configs/s3-sync-analysis.rna_degradation.config
echo "Samples"
./s3-sync-general.sh configs/s3-sync-samples.rna_degradation.config
echo "Data"
./s3-sync-general.sh configs/s3-sync-data.rna_degradation.config
echo "Main"
./s3-sync-general.sh configs/s3-sync-main.rna_degradation.config

echo "pirna_mouse"
echo "Data local"
./s3-sync-general.sh configs/s3-sync-data-local.pirna_mouse.config
echo "Analysis"
./s3-sync-general.sh configs/s3-sync-analysis.pirna_mouse.config
echo "Samples"
./s3-sync-general.sh configs/s3-sync-samples.pirna_mouse.config
echo "Data"
./s3-sync-general.sh configs/s3-sync-data.pirna_mouse.config
echo "Main"
./s3-sync-general.sh configs/s3-sync-main.pirna_mouse.config

####################################################################################################
echo "Manolis"

echo "All directories - deep "
./s3-sync-general.sh configs/mns/s3-sync-all.deep.config

echo "ribothrypsis"
echo "data-local"
./s3-sync-general.sh configs/mns/s3-sync-data-local.ribothrypsis.config
echo "main"
./s3-sync-general.sh configs/mns/s3-sync-main.ribothrypsis.config
echo "analysis"
./s3-sync-general.sh configs/mns/s3-sync-analysis.ribothrypsis.config
echo "data"
./s3-sync-general.sh configs/mns/s3-sync-data.ribothrypsis.config
echo "samples"
./s3-sync-general.sh configs/mns/s3-sync-samples.ribothrypsis.config

echo "ribothrypsis_pirnas"
echo "main"
./s3-sync-general.sh configs/mns/s3-sync-main.ribothrypsis_pirnas.config
echo "analysis"
./s3-sync-general.sh configs/mns/s3-sync-analysis.ribothrypsis_pirnas.config
echo "data"
./s3-sync-general.sh configs/mns/s3-sync-data.ribothrypsis_pirnas.config
echo "samples"
./s3-sync-general.sh configs/mns/s3-sync-samples.ribothrypsis_pirnas.config

echo "fly_kc167"
echo "data-local"
./s3-sync-general.sh configs/mns/s3-sync-data-local.fly_kc167.config
echo "main"
./s3-sync-general.sh configs/mns/s3-sync-main.fly_kc167.config
echo "analysis"
./s3-sync-general.sh configs/mns/s3-sync-analysis.fly_kc167.config
echo "data"
./s3-sync-general.sh configs/mns/s3-sync-data.fly_kc167.config
echo "samples"
./s3-sync-general.sh configs/mns/s3-sync-samples.fly_kc167.config

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

echo "akron"
echo "data-local"
./s3-sync-general.sh configs/mns/s3-sync-data-local.akron.config
echo "main"
./s3-sync-general.sh configs/mns/s3-sync-main.akron.config
echo "analysis"
./s3-sync-general.sh configs/mns/s3-sync-analysis.akron.config
echo "data"
./s3-sync-general.sh configs/mns/s3-sync-data.akron.config
echo "samples"
./s3-sync-general.sh configs/mns/s3-sync-samples.akron.config

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
echo "analysis"
./s3-sync-general.sh configs/pan.alexiou/s3-sync-analysis.small_projects-JWYG-Mov10CLIP.config
echo "samples"
./s3-sync-general.sh configs/pan.alexiou/s3-sync-samples.small_projects-JWYG-Mov10CLIP.config

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

echo "Small projects"
echo "KE-Mov10CLIP"
./s3-sync-general.sh configs/pan.alexiou/s3-sync-all.small_projects-KE-Mov10CLIP.config
echo "m1A_peaks"
./s3-sync-general.sh configs/pan.alexiou/s3-sync-all.small_projects-m1A_peaks.config
echo "star_chimeric"
./s3-sync-general.sh configs/pan.alexiou/s3-sync-all.small_projects-star_chimeric.config
echo "chimeric_reads_paper"
echo "data"
./s3-sync-general.sh configs/pan.alexiou/s3-sync-data.small_projects-chimeric_reads_paper.config
echo "main"
./s3-sync-general.sh configs/pan.alexiou/s3-sync-main.small_projects-chimeric_reads_paper.config
echo "analysis"
./s3-sync-general.sh configs/pan.alexiou/s3-sync-analysis.small_projects-chimeric_reads_paper.config
