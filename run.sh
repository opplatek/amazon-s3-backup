#!/bin/bash
#
# General script to run the backup to S3
#

cd /home/joppelt/playground/amazon_backup/

####################################################################################################
echo "Jan"

#echo "ribothrypsis" # Set to archive on 02/14/2022 - not updated anymore; not deleted locally yet
#echo "Data local"
#./s3-sync-general.sh configs/s3-sync-data-local.ribothrypsis.config ribothrypsis-data-local
#echo "Analysis"
#./s3-sync-general.sh configs/s3-sync-analysis.ribothrypsis.config
#echo "Samples"
#./s3-sync-general.sh configs/s3-sync-samples.ribothrypsis.config
#echo "Data"
#./s3-sync-general.sh configs/s3-sync-data.ribothrypsis.config
#echo "Main"
#./s3-sync-general.sh configs/s3-sync-main.ribothrypsis.config

echo "rna_degradation"
echo "Data local"
./s3-sync-general.sh configs/s3-sync-data-local.rna_degradation.config rna_degradation-data-local
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
./s3-sync-general.sh configs/s3-sync-data-local.pirna_mouse.config pirna_mouse-data-local
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

#echo "All directories - deep" # Set to archive on 02/14/2022 - not updated anymore; not deleted locally yet
#./s3-sync-general.sh configs/mns/s3-sync-all.deep.config

#echo "ribothrypsis" # Set to archive on 02/14/2022 - not updated anymore; not deleted locally yet
#echo "Data local"
#./s3-sync-general.sh configs/mns/s3-sync-data-local.ribothrypsis.config ribothrypsis-data-local
#echo "Main"
#./s3-sync-general.sh configs/mns/s3-sync-main.ribothrypsis.config
#echo "Analysis"
#./s3-sync-general.sh configs/mns/s3-sync-analysis.ribothrypsis.config
#echo "Data"
#./s3-sync-general.sh configs/mns/s3-sync-data.ribothrypsis.config
#echo "Samples"
#./s3-sync-general.sh configs/mns/s3-sync-samples.ribothrypsis.config

#echo "ribothrypsis_pirnas" # Set to archive on 02/14/2022 - not updated anymore; not deleted locally yet
#echo "Main"
#./s3-sync-general.sh configs/mns/s3-sync-main.ribothrypsis_pirnas.config
#echo "Analysis"
#./s3-sync-general.sh configs/mns/s3-sync-analysis.ribothrypsis_pirnas.config
#echo "Data"
#./s3-sync-general.sh configs/mns/s3-sync-data.ribothrypsis_pirnas.config
#echo "Samples"
#./s3-sync-general.sh configs/mns/s3-sync-samples.ribothrypsis_pirnas.config

#echo "fly_kc167" # Set to archive on 04/27/2022 - not updated anymore; not deleted locally yet
#echo "Data local"
#./s3-sync-general.sh configs/mns/s3-sync-data-local.fly_kc167.config fly_kc167-data-local
#echo "Main"
#./s3-sync-general.sh configs/mns/s3-sync-main.fly_kc167.config
#echo "Analysis"
#./s3-sync-general.sh configs/mns/s3-sync-analysis.fly_kc167.config
#echo "Data"
#./s3-sync-general.sh configs/mns/s3-sync-data.fly_kc167.config
#echo "Samples"
#./s3-sync-general.sh configs/mns/s3-sync-samples.fly_kc167.config

#echo "fly_RK" # Set to archive on 04/27/2022 - not updated anymore; not deleted locally yet
#echo "Data local"
#./s3-sync-general.sh configs/mns/s3-sync-data-local.fly_RK.config fly_RK-data-local
#echo "Main"
#./s3-sync-general.sh configs/mns/s3-sync-main.fly_RK.config
#echo "Analysis"
#./s3-sync-general.sh configs/mns/s3-sync-analysis.fly_RK.config
#echo "Data"
#./s3-sync-general.sh configs/mns/s3-sync-data.fly_RK.config
#echo "Samples"
#./s3-sync-general.sh configs/mns/s3-sync-samples.fly_RK.config

#echo "mouse_FUS" # Set to archive on 02/14/2022 - not updated anymore; not deleted locally yet
#echo "Data local"
#./s3-sync-general.sh configs/mns/s3-sync-data-local.mouse_FUS.config mouse_FUS-data-local
#echo "Main"
#./s3-sync-general.sh configs/mns/s3-sync-main.mouse_FUS.config
#echo "Analysis"
#./s3-sync-general.sh configs/mns/s3-sync-analysis.mouse_FUS.config
#echo "Data"
#./s3-sync-general.sh configs/mns/s3-sync-data.mouse_FUS.config
#echo "Samples"
#./s3-sync-general.sh configs/mns/s3-sync-samples.mouse_FUS.config

#echo "human_HRI" # Set to archive on 02/14/2022 - not updated anymore; not deleted locally yet
#echo "Data local"
#./s3-sync-general.sh configs/mns/s3-sync-data-local.human_HRI.config human_HRI-data-local
#echo "Main"
#./s3-sync-general.sh configs/mns/s3-sync-main.human_HRI.config
#echo "Analysis"
#./s3-sync-general.sh configs/mns/s3-sync-analysis.human_HRI.config
#echo "Data"
#./s3-sync-general.sh configs/mns/s3-sync-data.human_HRI.config
#echo "Samples"
#./s3-sync-general.sh configs/mns/s3-sync-samples.human_HRI.config

#echo "akron" # Set to archive on 02/14/2022 - not updated anymore; not deleted locally yet
#echo "Data local"
#./s3-sync-general.sh configs/mns/s3-sync-data-local.akron.config akron-data-local
#echo "Main"
#./s3-sync-general.sh configs/mns/s3-sync-main.akron.config
#echo "Analysis"
#./s3-sync-general.sh configs/mns/s3-sync-analysis.akron.config
#echo "Data"
#./s3-sync-general.sh configs/mns/s3-sync-data.akron.config
#echo "Samples"
#./s3-sync-general.sh configs/mns/s3-sync-samples.akron.config

####################################################################################################
echo "Panos"

#echo "All directories - Ago, Akron, tools" # Set to archive on 02/14/2022 - not updated anymore; not deleted locally yet
#./s3-sync-general.sh configs/pan.alexiou/s3-sync-all.ago.config
#./s3-sync-general.sh configs/pan.alexiou/s3-sync-all.akron.config
#./s3-sync-general.sh configs/pan.alexiou/s3-sync-all.tools.config
#./s3-sync-general.sh configs/pan.alexiou/s3-sync-all.simulation.config

#echo " Miwi" # Set to archive on 04/27/2022 - not updated anymore; not deleted locally yet
#echo "Data local"
#./s3-sync-general.sh configs/pan.alexiou/s3-sync-data-local.miwi.config miwi-data-local
#echo "Data"
#./s3-sync-eneral.sh configs/pan.alexiou/s3-sync-data.miwi.config
#echo "Main"
#./s3-sync-general.sh configs/pan.alexiou/s3-sync-main.miwi.config
#echo "Analysis"
#./s3-sync-general.sh configs/pan.alexiou/s3-sync-analysis.miwi.config
#echo "Samples"
#./s3-sync-general.sh configs/pan.alexiou/s3-sync-samples.miwi.config

#echo "DDX3" # Set to archive on 06/02/2021 - not updated anymore & deleted locally
#echo "Data local"
#./s3-sync-general.sh configs/pan.alexiou/s3-sync-data-local.ddx3.config ddx3-data-local
#echo "Main"
#./s3-sync-general.sh configs/pan.alexiou/s3-sync-main.ddx3.config
#echo "Analysis"
#./s3-sync-general.sh configs/pan.alexiou/s3-sync-analysis.ddx3.config
#echo "Samples"
#./s3-sync-general.sh configs/pan.alexiou/s3-sync-samples.ddx3.config
#echo "Data"
#./s3-sync-general.sh configs/pan.alexiou/s3-sync-data.ddx3.config

#echo "Small projects"
#echo "JWYG-Mov10CLIP" # Set to archive on 06/01/2021 - not updated anymore & deleted locally
#echo "Data local"
#./s3-sync-general.sh configs/pan.alexiou/s3-sync-data-local.small_projects-JWYG-Mov10CLIP.config jwyg-mov10clip-data-local
#echo "Data"
#./s3-sync-general.sh configs/pan.alexiou/s3-sync-data.small_projects-JWYG-Mov10CLIP.config
#echo "Main"
#./s3-sync-general.sh configs/pan.alexiou/s3-sync-main.small_projects-JWYG-Mov10CLIP.config
#echo "Analysis"
#./s3-sync-general.sh configs/pan.alexiou/s3-sync-analysis.small_projects-JWYG-Mov10CLIP.config
#echo "Samples"
#./s3-sync-general.sh configs/pan.alexiou/s3-sync-samples.small_projects-JWYG-Mov10CLIP.config
#echo "KE-Mov10CLIP" # Set to archive on 05/27/2021 - not updated anymore & deleted locally
#./s3-sync-general.sh configs/pan.alexiou/s3-sync-all.small_projects-KE-Mov10CLIP.config
#echo "star_chimeric" # Set to archive on 05/27/2021 - not updated anymore & deleted locally
#./s3-sync-general.sh configs/pan.alexiou/s3-sync-all.small_projects-star_chimeric.config
#echo "m1A_peaks" # Set to archive on 05/27/2021 - not updated anymore & deleted locally
#./s3-sync-general.sh configs/pan.alexiou/s3-sync-all.small_projects-m1A_peaks.config
#echo "chimeric_reads_paper" # Set to archive on 05/27/2021 - not updated anymore & deleted locally
#echo "Data"
#./s3-sync-general.sh configs/pan.alexiou/s3-sync-data.small_projects-chimeric_reads_paper.config
#echo "Main"
#./s3-sync-general.sh configs/pan.alexiou/s3-sync-main.small_projects-chimeric_reads_paper.config
#echo "Analysis"
#./s3-sync-general.sh configs/pan.alexiou/s3-sync-analysis.small_projects-chimeric_reads_paper.config # = results
