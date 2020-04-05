#!/bin/bash
#
# Somehow simple backup of directories to Amazon S3 storage
#
delete

#main_dir="/home/mns/workspace/projects/ribothrypsis/data/minion"
main_dir="/home/joppelt/projects/ribothrypsis/analysis"
sync_dir="/home/joppelt/playground/glacier_test"
bucket="s3://ribothrypsis-analysis-jan"
manifest="/home/joppelt/playground/s3-sync-manifest.log" # File to keep track of what was backed up

class="GLACIER" # ["GLACIER"|"STANDARD"] 
upload="cp" # ["sync"|"cp"] sync to upload only new/change files (slower but doesn't upload all) or cp to upload all the files (faster but uploads all)

bckp=(
"adapters"
"degradation-levels"
"dist-from-annot"
"dist-from-annot-ends"
"distro-on-meta-gene"
"gene-levels"
"gene-ontology"
"genomic-distro"
"isoforms"
"nt-composition"
"other"
"polya-len"
"primer_design"
"protein-levels"
"qc-general"
"rel5-size-distro"
"rel-pos-distro"
"rel-pos-to-gquad"
"riboseq-distro"
"size-distro"
"spikein"
"transcript-coverage"
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
	echo "Compressing: $dir"
	tar -zcf $sync_dir/${dir%/raw}.tar.gz $dir
	echo "Done compressing $dir"

	wait # Wait for previous delete not to upload it again 

	echo "Check tar.gz archive: $sync_dir/${dir%/raw}.tar.gz"
	if tar -tzf $sync_dir/${dir%/raw}.tar.gz >/dev/null; then
		echo "Archive is OK, going to sync."

		echo "Get time, md5sum and file size"
		date=`date`
		md5sum=`md5sum $sync_dir/${dir%/raw}.tar.gz | cut -d' ' -f1`
		filesize=$(stat -c%s "$sync_dir/${dir%/raw}.tar.gz")
		printf "%b\n" "date\tsource_dir\tfile_name\tfile_size\tmd5sum\tbucket" >> $manifest
		printf "%s\t%s\t%s\t%s\t%s\t%b\n" "$date" "$main_dir/$dir" "${dir%/raw}.tar.gz" "$filesize" "$md5sum" "$bucket" >> $manifest

		# Comparing name and file size
		# Note: this will work only for big files; still, we might get a match by accident
		# Note: I wasn't able to do this comparison using hashes (md5, sha1, sha256) - every compression the tar.gz had different hash
		if `grep -w ${dir%/raw}.tar.gz $manifest | grep -q -w $filesize`; then
			echo "Warning: ${dir%/raw}.tar.gz has been already uploaded before (same file_name and file_size); not going to sync."
		else
			echo "Syncing $sync_dir/${dir%/raw}.tar.gz to storage class $class"
			if [ $upload = "sync" ]; then
				echo "Doing sync"
				aws s3 sync $sync_dir $bucket --storage-class $class # If we want to upload only new or modified files
			elif [ $upload = "cp" ]; then
				echo "Doing cp"
				aws s3 cp $sync_dir $bucket --storage-class $class # If we want to simply upload a file/files (--recursive - uploads ALL files)
			else
				echo "Didn't recognize upload: $upload, doing sync (default)"
				aws s3 sync $sync_dir $bucket --storage-class $class
			fi
		fi

		echo "Done syncing: $sync_dir/${dir%/raw}.tar.gz"
        else
                echo "Error: there is something wrong with: $sync_dir/${dir%/raw}.tar.gz. NOT going to sync."
                echo "Error: backup didn't finish." >> $manifest
        fi

	rm $sync_dir/${dir%/raw}.tar.gz &
done

echo "Uploading manifest"
aws s3 cp $manifest $bucket

echo "All done"
