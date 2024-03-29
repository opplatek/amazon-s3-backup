#!/bin/bash
#
# Somehow simple backup of directories to Amazon S3 storage
# Accepts one and only one argument - config file with a single (main) directory to backup (main_dir) - will be used as bucket name
#    and a array of subdirectories (dirs); optionaly can have another array (exclude) with dirs to exclude from the backup
#
# TODO: Change to getopts or other "smart" argument processing https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
#
###

# Default variables if they are not set in a config file
author="jan"
sync_dir_main="/home/joppelt/playground/s3_backup" # Main sync directory we'll use as temporary directory for archiving and upload; make sure there is enough space
class="STANDARD" # ["GLACIER"|"STANDARD"] default/starting AWS class
upload="cp" # ["sync"|"cp"] sync to upload only new/change files (slower but doesn't upload all) or cp to upload all the files (faster but uploads all)
version="true" # ["true"|"false"] # keep all file versions (with lifecycle config)
keep="false" # ["true"|"false"] # keep all file versions forever
logs="false" # ["true"|"false"] # keep AWS operation logs

# Test if one of the parameters is "--force"; ["true"|"false"] # force new backup even if old same size backup already exists
if [[ "$*" == *"--force"* ]]
then
    force="true"
else
    force="false"
fi

# Check if we are logging and making bucket name
if [ "$#" -gt 3 ]; then
    echo "Illegal number of parameters. We need config file as the first argument (mandatory), optionaly bucket name as second, and optionaly \"--force\" as last (second if bucket name is not used or third if it is) if forced upload is required."
    exit 1
elif [ "$#" -eq 3 ]; then
    source $1
    bucket=$2
elif [ "$#" -eq 2 ]; then
    if [ "$force" == "false" ]; then
        source $1
        bucket=$2
    elif [ "$force" == "true" ]; then
        source $1
    else
        echo "Don't understand command-line parameters, please see help."
        exit 1
    fi        
elif [ "$#" -eq 1 ]; then
    if [ "$force" == "true" ]; then
        echo "You specified only \"--force\" and no config file (required), please check help."
        exit 1
    fi    
    source $1
fi

echo -e "Params check\n-----------------"
echo "Author: $author"
echo "Backup class: $class"
echo "Upload type: $upload"
echo "Versioning: $version"
echo "Keep old versions forever: $keep"
echo "Keep logs: $logs"
echo "Bucket (if specificed): $bucket"
echo "Forced upload: $force"

if [ "$force" == "true" ]; then
    echo "Warning: \"--force\" was specified, going to sync even if the exact same directory/file has been uploaded before."
fi

# check if we set bucket name in the command line/as parameter
if [ -n "$bucket" ]; then
    echo "Bucket: ${bucket} was specified as parameter."
else
    bucket=${author}-$(basename $main_dir) # Without s3://
    echo "Bucket wasn't specified, using default: ${bucket}."
fi

bucket=`echo $bucket | sed 's/_//g' | tr '[:upper:]' '[:lower:]'` # aws cli doesn't like "_" in the bucket name as well as uppercase letters
manifest="$(pwd)/logs/${bucket}.s3-backup-manifest.log" # File to keep track of what was backed up

manifest_bucket="s3-backup-manifest" # without s3://

echo "Starting compressing and archiving for the following subdirectories:"
echo ${dirs[*]} | sed 's/ /\n/g'

source /home/joppelt/tools/amazonS3/bin/activate
re="^[0-9]+([.][0-9]+)?$" # For testing a number values with decimal points https://stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash

for bckp_main in ${dirs[@]}; do
    echo "Making backup of dir: ${main_dir}/${bckp_main}"

    sync_dir="$sync_dir_main/$bckp_main"

    #bckp=$(ls -d $main_dir/${bckp_main}/* | tr '' '\n' | grep -v external | sed "s|${main_dir}/||g")
#    if [ $bckp_main == "data/illumina" ] || [ $bckp_main == "data/minion" ]; then
#        bckp=$(ls -d $main_dir/${bckp_main}/* | tr '' '\n' | grep -v external) # Illumina and Minion will be backed up separately
#    else
#        bckp=$(ls -d $main_dir/${bckp_main}/* | tr '' '\n' | grep -v external | grep -v illumina | grep -v minion) # Illumina and Minion will be backed up separately
#    fi

    bckp=$(ls -d $main_dir/${bckp_main}/*)
    bckp=($bckp) # Convert string to array

    # Remove directories in array $exclude if set
    if [ -z ${exclude} ]; then
        echo "Backing up all directories, nothing in array \$exclude"
    else
        echo "Removed directories from backup: ${exclude[*]}"
        for target in "${exclude[@]}"; do
            for i in "${!bckp[@]}"; do
                if [[ ${bckp[i]} = ${main_dir}/${bckp_main}/${target} ]]; then
                    unset 'bckp[i]'
                fi
            done
        done
    fi

    # Change name of the backup subfolder if $name is defined in the config file
    if [ -z ${name} ]; then
        echo "Keeping destination folder name: ${bckp_main}."
    else
        echo "Changing destination folder name to: ${name}."
        bckp_main=$name
    fi

    ###

    mkdir -p $sync_dir
    tmp_dir=$pwd
    #cd $main_dir/

    echo "Check if the destination bucket exists: $bucket"

    if `aws s3api list-buckets | grep -q -w $bucket`; then
        echo "Bucket already exists."
    else
        echo "Bucket doesn't exist, making a new one."
        $(pwd)/s3-make-bucket.sh $bucket $version $keep $logs

        if `aws s3api list-buckets | grep -q -w $bucket`; then # Check again if bucket was created
            echo "Bucket creation confirmed."
        else
            echo "Bucket wasn't created, please check what happened, exiting." #; exit 2
        fi
    fi

    echo "Main directory with the directories to backup: $main_dir"

    echo "Starting compressing and archiving for the following subdirectories:"
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

        if [ "$force" == "false" ] && `cat $manifest | grep -w "s3://${bucket}" | grep -w $dir | tail -1 | grep -q -w $dirsize`; then # Check if the last backed up directory had the same exact size
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

                echo "Syncing $sync_dir/$(basename $dir).tar.gz to storage class $class"
                if [ $upload == "sync" ]; then
                    echo "Doing aws s3 sync."
                    aws s3 sync $sync_dir s3://${bucket}/${bckp_main}/ --storage-class $class # If we want to upload only new or modified files
                elif [ $upload == "cp" ]; then
                    echo "Doing aws s3 cp."
                    aws s3 cp $sync_dir s3://${bucket}/${bckp_main}/ --storage-class $class --recursive # If we want to simply upload a file/files (--recursive - uploads ALL files)
                else
                    echo "Didn't recognize upload: $upload, doing aws s3 sync (default)."
                    aws s3 sync $sync_dir s3://${bucket}/${bckp_main}/ --storage-class $class
                fi

                echo "Done syncing: $sync_dir/$(basename $dir).tar.gz"

                # Check file size and compare it with the uploaded one
                filesize_up=`aws s3 ls s3://$bucket/${bckp_main}/ | grep $(basename $dir).tar.gz | tail -1 | tr -s ' ' | cut -d ' ' -f3`
                if [[ "$filesize_up" =~ $re ]] && [ "$filesize" -eq "$filesize_up" ]; then
                    echo "The file sizes are matching, good! Seems like a good upload."

                    # Add the upload to the manifest if sucesfull
                    printf "%b\n" "date\tsource_name\tfile_name\tsource_size\tfile_size\tmd5sum\tbucket" >> $manifest
                    printf "%s\t%s\t%s\t%s\t%s\t%s\t%b\n" "$date" "$dir" "${bckp_main}/$(basename $dir).tar.gz" "$dirsize" "$filesize" "$md5sum" "s3://${bucket}" >> $manifest
                else
                    echo "Warning: file sizes are NOT matching, please check the upload of: $(basename $dir).tar.gz" >> $manifest
                fi

            else
                echo "Error: there is something wrong with: $sync_dir/$(basename $dir).tar.gz. NOT going to sync."
                echo "Error, backup didn't finish for: $(basename $dir).tar.gz" >> $manifest
            fi

            rm $sync_dir/$(basename $dir).tar.gz
        fi
    done

    echo "Uploading manifest and sync script"
    aws s3 cp $manifest s3://${bucket}
    aws s3 cp $manifest s3://${manifest_bucket}
    aws s3 cp $0 s3://${bucket}

    wait

    rmdir $sync_dir # Clean temp upload directory
    rmdir $(dirname $sync_dir)
done

echo "All done"
