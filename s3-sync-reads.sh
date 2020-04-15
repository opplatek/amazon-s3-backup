#!/bin/bash
#
# Somehow simple backup of directories to Amazon S3 storage
#

#main_dir="/home/mns/workspace/projects/ribothrypsis/data/minion"
main_dir="/home/joppelt/projects/ribothrypsis/data/minion"
sync_dir="/home/joppelt/playground/glacier_test"
bucket="s3://ribothrypsis-data-nanopore"
manifest="/home/joppelt/playground/logs/s3-sync-manifest.reads.log" # File to keep track of what was backed up

class="GLACIER" # ["GLACIER"|"STANDARD"] 
upload="cp" # ["sync"|"cp"] sync to upload only new/change files (slower but doesn't upload all) or cp to upload all the files (faster but uploads all)

bckp=(
"20180420_1610_RNA_Control/guppy/reads.fastq.gz"
"20180601_1847_RNA_Control_RL3/guppy/reads.fastq.gz"
"20180613_1856_hsa-dRNASeq-HeLa-Total-A3RL5-1/guppy/reads.fastq.gz"
"20180620_1930_hsa-dRNASeq-HeLa-Total-REL3-1/guppy/reads.fastq.gz"
"20190109_1933_hsa-dRNASeq-HeLa-Total-REL3-REL5-1/guppy/reads.fastq.gz"
"20190304_2301_hsa-dRNASeq-HeLa-polyA-REL5-1/guppy/reads.fastq.gz"
"20190409_1941_hsa-dRNASeq-HeLa-polyA-PNK-REL5-1/guppy/reads.fastq.gz"
"20190419_dRNASeq-HeLa-polyA-ladder/guppy/reads.fastq.gz"
"20190607-hsa.dRNASeq.HeLa.polyA.decap.REL5.long/guppy/reads.fastq.gz"
"20190614-hsa.dRNASeq.HeLa.polyA.CIP.decap.REL5.long/guppy/reads.fastq.gz"
"20191104-hsa.dRNASeq.HeLa.total.REL3.2/guppy/reads.fastq.gz"
"20191111-hsa.dRNASeq.HeLa.total.REL3.3/guppy/reads.fastq.gz"
"20191203-hsa.dRNASeq.HeLa.total.REL5.long.REL3.1/guppy/reads.fastq.gz"
"20191206-hsa.dRNASeq.HeLa.total.REL5.long.REL3.2/guppy/reads.fastq.gz"
"20191210-hsa.dRNASeq.HeLa.total.REL5.long.REL3.3.a/guppy/reads.fastq.gz"
"20191213-hsa.dRNASeq.HeLa.total.REL5.long.REL3.4/guppy/reads.fastq.gz"
"20200109-hsa.dRNASeq.293T.polyA.XRN1KO.Clow.5OH.REL5.long.1/guppy/reads.fastq.gz"
"20200110-hsa.dRNASeq.HeLa.total.REL5.long.REL3.5/guppy/reads.fastq.gz"
"20200114-hsa-dRNASeq.293T.polyA.XRN1KO.CHi.REL5.long.1/guppy/reads.fastq.gz"
"20200114-hsa-dRNASeq.293T.polyA.XRN1KO.REL5.long.1/guppy/reads.fastq.gz"
"20200129-hsa.dRNASeq.HeLa.total.REL5.long.REL3.6/guppy/reads.fastq.gz"
"20200129-hsa.dRNASeq.HeLa.total.REL5.long.REL3.7/guppy/reads.fastq.gz"
"20200131-hsa.dRNASeq.HeLa.polyA.CIP.decap.REL5.long.2.a/guppy/reads.fastq.gz"
"20200131-hsa.dRNASeq.HeLa.polyA.CIP.decap.REL5.long.2.b/guppy/reads.fastq.gz"
"20200206-hsa-dRNASeq.293T.polyA.XRN1KO.REL5.long.1/guppy/reads.fastq.gz"
"20200211-hsa.dRNASeq.HeLa.polyA.CIP.decap.REL5.long.3/guppy/reads.fastq.gz"
"20200219-hsa.dRNASeq.HeLa.total.REL5.long.REL3.8/guppy/reads.fastq.gz"
"20200219-hsa.dRNASeq.HeLa.total.REL5.long.REL3.9/guppy/reads.fastq.gz"
"20200227-hsa.dRNASeq.HeLa.total.REL5.long.REL3.10/guppy/reads.fastq.gz"
"new_guppy/20180420_1610_RNA_Control/guppy/reads.fastq.gz"
"new_guppy/20180601_1847_RNA_Control_RL3/guppy/reads.fastq.gz"
"new_guppy/20180613_1856_hsa-dRNASeq-HeLa-Total-A3RL5-1/guppy/reads.fastq.gz"
"new_guppy/20180620_1930_hsa-dRNASeq-HeLa-Total-REL3-1/guppy/reads.fastq.gz"
"new_guppy/20190109_1933_hsa-dRNASeq-HeLa-Total-REL3-REL5-1/guppy/reads.fastq.gz"
"new_guppy/20190304_2301_hsa-dRNASeq-HeLa-polyA-REL5-1/guppy/reads.fastq.gz"
"new_guppy/20190409_1941_hsa-dRNASeq-HeLa-polyA-PNK-REL5-1/guppy/reads.fastq.gz"
"new_guppy/20190419_dRNASeq-HeLa-polyA-ladder/guppy/reads.fastq.gz"
"new_guppy/20190515-hsa.dRNASeq.HeLa.polyA.REL5.long/guppy/reads.fastq.gz"
"new_guppy/20190531-hsa.dRNASeq.HeLa.polyA.REL5OH.long/guppy/reads.fastq.gz"
"new_guppy/20190607-hsa.dRNASeq.HeLa.polyA.decap.REL5.long/guppy/reads.fastq.gz"
"new_guppy/20190614-hsa.dRNASeq.HeLa.polyA.CIP.decap.REL5.long/guppy/reads.fastq.gz"
"new_guppy/20190628-hsa.dRNASeq.HeLa.total.REL3.long.1/guppy/reads.fastq.gz"
"new_guppy/20190829-hsa.dRNASeq.HeLa.polyA.REL3.long.atail/guppy/reads.fastq.gz"
"new_guppy/20190906-hsa.dRNASeq.HeLa.total.REL3.long.atail.1/guppy/reads.fastq.gz"
"new_guppy/20190906-hsa.dRNASeq.HeLa.total.REL3.long.atail/guppy/reads.fastq.gz"
"new_guppy/20190912-hsa.dRNASeq.HeLa.total.REL3.long.atail.2.a/guppy/reads.fastq.gz"
"new_guppy/20190920-hsa.dRNASeq.HeLa.total.REL3.long.atail.2.b/guppy/reads.fastq.gz"
"new_guppy/20190926-hsa.dRNASeq.HeLa.total.REL3.long.2.a/guppy/reads.fastq.gz"
"new_guppy/20191001-hsa.dRNASeq.HeLa.total.REL3.long.2.b/guppy/reads.fastq.gz"
"new_guppy/20191023-sc.dRNASeq.RCS.REL5.long.REL3.atail/guppy/reads.fastq.gz"
"new_guppy/20191023-sc.dRNASeq.RCS.REL5.long.REL3.long/guppy/reads.fastq.gz"
)

source /home/joppelt/playground/amazonS3/bin/activate

mkdir -p $sync_dir
cd $main_dir/

echo "Starting compressing and archiving for the following directories:"
echo ${bckp[*]} | sed 's/ /\n/g'

echo "------------------------------------------" >> $manifest
echo "Backup of:" >> $manifest
echo ${bckp[*]} | sed 's/ /\n/g' >> $manifest
echo "Backup started on: `date`" >> $manifest
echo "Backup to: $bucket" >> $manifest

for dir in ${bckp[@]}; do
	echo "Copying: $dir"
	if `echo $dir | grep -q "new_guppy"`; then
		echo "Found new guppy, rewriting previous reads"
		name=`echo $dir | sed 's/\/new_guppy//g'`
		cp $dir $sync_dir/${name%/guppy*}-reads.fastq.gz
		dir=`echo $dir | sed 's/\/new_guppy//g'`
	else
		echo "Found guppy, copying reads."
		cp $dir $sync_dir/${dir%/guppy*}-reads.fastq.gz
	fi
	echo "Done copying $dir"

	wait # Wait for previous delete not to upload it again 

	echo "Get time, md5sum and file size"
	date=`date`
	md5sum=`md5sum $sync_dir/${dir%/guppy*}-reads.fastq.gz | cut -d' ' -f1`
	filesize=$(stat -c%s "$sync_dir/${dir%/guppy*}-reads.fastq.gz")

	printf "%b\n" "date\tsource_dir\tfile_name\tfile_size\tmd5sum\tbucket" >> $manifest
	printf "%s\t%s\t%s\t%s\t%s\t%b\n" "$date" "$main_dir/$dir" "${dir%/guppy*}-reads.fastq.gz" "$filesize" "$md5sum" "$bucket" >> $manifest

done

cp $main_dir/20200227-hsa.dRNASeq.HeLa.total.REL5.long.REL3.10/run_guppy.sh $sync_dir/

aws s3 cp $sync_dir $bucket --recursive --storage-class $class

echo "Uploading manifest"
aws s3 cp $manifest $bucket
aws s3 cp $0 $bucket

rm $sync_dir/*

echo "All done"

