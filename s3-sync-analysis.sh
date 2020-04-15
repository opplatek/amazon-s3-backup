#!/bin/bash
#
# Somehow simple backup of directories to Amazon S3 storage
#

main_dir="/home/mns/workspace/projects/akron/analysis"
sync_dir="/home/joppelt/playground/glacier_test"
bucket="akron-analysis-manolis" # Without s3://
manifest="/home/joppelt/playground/logs/s3-sync-manifest-analysis.log" # File to keep track of what was backed up

class="GLACIER" # ["GLACIER"|"STANDARD"] 
upload="cp" # ["sync"|"cp"] sync to upload only new/change files (slower but doesn't upload all) or cp to upload all the files (faster but uploads all)

bckp=(
"akron_counts_on_snRNAs"
"akron_polyA_counts"
"codon_adaptation"
"codon_composition"
"conservation"
"correlations"
"dist_from_codon"
"distro_on_meta_gene"
"genomic_distro"
"GO_analysis"
"gquad_pred"
"mirnas"
"motif"
"nt_composition"
"orf_distro"
"pacbio_dist_from_exons"
"pacbio_sizes"
"pacbio_tails_composition"
"read_counts"
"relative_pos_distro"
"sample_correlation"
"secondary_structure"
"size_distro"
"stability"
)

source /home/joppelt/playground/amazonS3/bin/activate

mkdir -p $sync_dir
cd $main_dir/

echo "Check if the destination bucket exists: $bucket"

if `aws s3api list-buckets | grep -q -w $bucket`; then
    echo "Bucket exists.."
else
    echo "Bucket doesn't exist, making a new one."
    /home/joppelt/playground/s3-make-bucket.sh $bucket
fi

echo "Starting compressing and archiving for the following directories:"
echo ${bckp[*]} | sed 's/ /\n/g'

echo "------------------------------------------" >> $manifest
echo "Backup of:" >> $manifest
echo ${bckp[*]} | sed 's/ /\n/g' >> $manifest
echo "Backup started on: `date`" >> $manifest
echo "Backup to: s3://${bucket}" >> $manifest

for dir in ${bckp[@]}; do
	echo "Compressing: $dir"
	tar -zcf $sync_dir/${dir%/raw}.tar.gz $dir
	echo "Done compressing $dir"

	wait # Wait for previous delete not to upload it again 

	echo "Check tar.gz archive: $sync_dir/${dir%/raw}.tar.gz"
	if tar -tzf $sync_dir/${dir%/raw}.tar.gz >/dev/null; then # Check if tar.gz is not corrupted
		echo "Archive is OK, going to sync."

		echo "Get time, md5sum and file size"
		date=`date`
		md5sum=`md5sum $sync_dir/${dir%/raw}.tar.gz | cut -d' ' -f1`
		filesize=$(stat -c%s "$sync_dir/${dir%/raw}.tar.gz")

		# Comparing name and file size
		# Note: this will work only for big files; still, we might get a match by accident
		# Note: I wasn't able to do this comparison using hashes (md5, sha1, sha256) - every compression the tar.gz had different hash
		if `grep -w ${dir%/raw}.tar.gz $manifest | grep -q -w $filesize`; then # Check if we have seen an exact file name with and exact file size
			echo "Warning: ${dir%/raw}.tar.gz has been already uploaded before (same file_name and file_size); not going to sync."
		else
        	        printf "%b\n" "date\tsource_dir\tfile_name\tfile_size\tmd5sum\tbucket" >> $manifest
	                printf "%s\t%s\t%s\t%s\t%s\t%b\n" "$date" "$main_dir/$dir" "${dir%/raw}.tar.gz" "$filesize" "$md5sum" "s3://${bucket}" >> $manifest

			echo "Syncing $sync_dir/${dir%/raw}.tar.gz to storage class $class"
			if [ $upload = "sync" ]; then
				echo "Doing aws s3 sync."
				aws s3 sync $sync_dir s3://${bucket} --storage-class $class # If we want to upload only new or modified files
			elif [ $upload = "cp" ]; then
				echo "Doing aws s3 cp."
				aws s3 cp $sync_dir s3://${bucket} --storage-class $class --recursive # If we want to simply upload a file/files (--recursive - uploads ALL files)
			else
				echo "Didn't recognize upload: $upload, doing aws s3 sync (default)."
				aws s3 sync $sync_dir s3://${bucket} --storage-class $class
			fi
			echo "Done syncing: $sync_dir/${dir%/raw}.tar.gz"
		fi

        else
                echo "Error: there is something wrong with: $sync_dir/${dir%/raw}.tar.gz. NOT going to sync."
                echo "Error: backup didn't finish." >> $manifest
        fi

	rm $sync_dir/${dir%/raw}.tar.gz &
done

echo "Uploading manifest"
aws s3 cp $manifest s3://${bucket}
aws s3 cp $0 s3://${bucket}

echo "All done"
