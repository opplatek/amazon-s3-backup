#!/bin/bash
#
# Check the synced folders in AWS S3 and those in the the manifest
#

source /home/joppelt/tools/amazonS3/bin/activate

aws s3 ls | cut -d ' ' -f3 | while read list; do 
	echo $list; aws s3 ls s3://${list} --recursive > all-bucket-list.${list}.txt
done

for a in logs/*.s3-backup-manifest.log; do
    names=`echo ${a%.s3-backup-manifest.log}`.txt
	names=$(basename $names)
    names=all-bucket-list.${names}
    echo $names
    cat $a | grep "tar.gz" | cut -f3 | while read list;do
        echo $list
        if grep -q $list $names; then
            echo "OK, found"\
        else
            echo "NOT found"
        fi
    done
done

rm all-bucket-list.*.txt
