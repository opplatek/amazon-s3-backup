#!/bin/bash
#
# Somehow simple backup of directories to Amazon S3 storage
#

main_dir="/home/joppelt/projects/pirna_mouse"
bckp_main="data" # make this automatic

author="jan"

bucket=${author}-$(basename $main_dir) # Without s3://
bucket=`echo $bucket | sed 's/_//g'` # aws cli doesn't like "_" in the bucket name
manifest="/home/joppelt/playground/logs/${bucket}.s3-backup-manifest.log" # File to keep track of what was backed up

manifest_bucket="s3-backup-manifest"
sync_dir="/home/joppelt/playground/s3_backup/$bckp_main"

class="STANDARD" # ["GLACIER"|"STANDARD"] 
upload="cp" # ["sync"|"cp"] sync to upload only new/change files (slower but doesn't upload all) or cp to upload all the files (faster but uploads all)

#bckp=$(ls -d $main_dir/${bckp_main}/* | tr '' '\n' | grep -v external | sed "s|${main_dir}/||g")
bckp=$(ls -d $main_dir/${bckp_main}/* | tr '' '\n' | grep -v external | grep -v illumina | grep -v minion) # Illumina and Minion will be backed up separately
bckp=($bckp) # Convert string to array

###

source /home/joppelt/playground/amazonS3/bin/activate

mkdir -p $sync_dir
tmp_dir=$pwd
#cd $main_dir/

echo "Check if the destination bucket exists: $bucket"

if `aws s3api list-buckets | grep -q -w $bucket`; then
    echo "Bucket exists.."
else
    echo "Bucket doesn't exist, making a new one."
    /home/joppelt/playground/s3-make-bucket.sh $bucket
fi

echo "Main directory with the directories to backup: $main_dir"

echo "Starting compressing and archiving for the following directories:"
echo ${bckp[*]} | sed 's/ /\n/g'

mkdir -p $(dirname $manifest)
if [ -f "$manifest" ]; then
    echo "Found already existing manifest file at: ${manifest}. Moving it to ${manifest}.$(date +"%m%d%y-%H%M%S").bckp"
    mv $manifest ${manifest}.$(date +"%m%d%y-%H%M%S").bckp
fi
# Get manifest from the bucket (if exists); if not, it just fails with "fatal error: An error occurred (404) when calling the HeadObject operation: Key "manifest.log" does not exist"
aws s3 cp s3://${manifest_bucket}/$(basename $manifest) ${manifest}

echo "------------------------------------------" >> $manifest
echo "Attempting backup of:" >> $manifest
echo ${bckp[*]} | sed 's/ /\n/g' >> $manifest
echo "Backup started on: `date`" >> $manifest
echo "Backup to: s3://${bucket}/${bckp_main}" >> $manifest

for dir in ${bckp[@]}; do
    echo "Working on: $dir"
    # Comparing name and dir size
    # Note: this will work only for big files; still, we might get a match by accident
    # Note: I wasn't able to do this comparison using hashes (md5, sha1, sha256) - every compression the tar.gz had different hash
    dirsize=`du -b -s $dir | cut -f 1`

    if `cat $manifest | grep -w "s3://${bucket}" | grep -w $dir | tail -1 | grep -q -w $dirsize`; then # Check if the last backed up directory had the same exact size
        echo "Warning: $dir has been already uploaded before (same file_name and dir_size); not going to sync."
    else
        echo "Compressing: $dir"
        tar -zcf $sync_dir/$(basename $dir).tar.gz $dir
        echo "Done compressing $dir"

        wait # Wait for previous delete not to upload it again 

        echo "Checking tar.gz archive: $sync_dir/$(basename $dir).tar.gz"
        if tar -tzf $sync_dir/$(basename $dir).tar.gz >/dev/null; then # Check if tar.gz is not corrupted
            echo "Archive is OK, going to sync."

#            echo "Get time, md5sum and file size"
            date=`date`
            md5sum=`md5sum $sync_dir/$(basename $dir).tar.gz | cut -d' ' -f1`
            filesize=$(stat -c%s "$sync_dir/$(basename $dir).tar.gz")

#        # Comparing name and file size
#        # Note: this will work only for big files; still, we might get a match by accident
#        # Note: I wasn't able to do this comparison using hashes (md5, sha1, sha256) - every compression the tar.gz had different hash
#        if `grep -w ${bckp_main}/$(basename $dir).tar.gz $manifest | tail -1 | grep -q -w $filesize`; then # Check if we have seen an exact file name with and exact file size
#            echo "Warning: ${bckp_main}/$(basename $dir).tar.gz has been already uploaded before (same file_name and file_size); not going to sync."
#        else
            printf "%b\n" "date\tsource_name\tfile_name\tsource_size\tfile_size\tmd5sum\tbucket" >> $manifest
            printf "%s\t%s\t%s\t%s\t%s\t%s\t%b\n" "$date" "$dir" "${bckp_main}/$(basename $dir).tar.gz" "$dirsize" "$filesize" "$md5sum" "s3://${bucket}" >> $manifest

            echo "Syncing $sync_dir/$(basename $dir).tar.gz to storage class $class"            
            if [ $upload = "sync" ]; then
                echo "Doing aws s3 sync."
                aws s3 sync $sync_dir s3://${bucket}/${bckp_main}/ --storage-class $class # If we want to upload only new or modified files
            elif [ $upload = "cp" ]; then
                echo "Doing aws s3 cp."
                aws s3 cp $sync_dir s3://${bucket}/${bckp_main}/ --storage-class $class --recursive # If we want to simply upload a file/files (--recursive - uploads ALL files)
            else
                echo "Didn't recognize upload: $upload, doing aws s3 sync (default)."
                aws s3 sync $sync_dir s3://${bucket}/${bckp_main}/ --storage-class $class
            fi
            
            echo "Done syncing: $sync_dir/$(basename $dir).tar.gz"

            # Check file size and compare it with the uploaded one
            filesize_up=`aws s3 ls s3://$bucket/${bckp_main}/ | grep $(basename $dir).tar.gz | tail -1 | tr -s ' ' | cut -d ' ' -f3` 
            if [ "$filesize" -eq "$filesize_up" ]; then
               echo "The file sizes are matching, good! Seems like a good upload."
            else
                echo "Warning: file sizes are NOT matching, please check the upload."
            fi

        else
            echo "Error: there is something wrong with: $sync_dir/$(basename $dir).tar.gz. NOT going to sync."
            echo "Error: backup didn't finish." >> $manifest
        fi    

        rm $sync_dir/$(basename $dir).tar.gz &
    fi
done

echo "Uploading manifest and sync script"
aws s3 cp $manifest s3://${bucket}
aws s3 cp $manifest s3://${manifest_bucket}
aws s3 cp $0 s3://${bucket}

wait

echo "All done"