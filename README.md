# Amazon S3 backup
## Simple Amazon S3 backup
The main idea here is to backup only changed directories. If the directory has been changed is determined simply on its size in bytes. We can have a situation when the bytes are exactly the same but let's hope this doesn't happen that often. 

All the information about the uploaded backup is stored in manifest file which help us to avoid unecessary compressing of directories already uploaded before.

Use it as following:
`./s3-sync-data-general.sh s3-sync-data.config`

The `s3-sync-data.config` contains the _parent_ directory, subdirectories to backup and directories/files to exclude. It can contain author of the directories as well as basic s3 cli parameters (--storage-glass upon upload and type of upload cp/sync).

### Main workflow
1. Decide on which directories to backup.
2. Download manifest file if exists.
3. Compare directory size with manifest.
4. If the sizes are different, compress the directory.
5. Upload the compressed directory archive.
6. Store the information about the upload to manifest.
7. Upload manifest and script.
8. Clean.

### Lifecycle rules
1. By default, upload goes to --storage-class STANDARD. 
2. Move the archive to Glacier after 3 days leaving some space to fix the upload if something does wrong. 
3. Move non-current version to Deep Glacier after 90 days. 
4. Delete non-current version after 180 days. 

* If applies, move the finished project to Deep Glacier manually

### Install AWS CLI
Create Python3 virtual environment

`python3 -m venv amazonS3
source amazonS3/bin/activate
which python
python --version
pip install --upgrade pip`

Get amazon aws cli and s3cmd and s3-pit-restore
`python -m pip install awscli s3cmd s3-pit-restore`

Get `empty_bucket.sh` to delete versioned buckets

`wget https://gist.githubusercontent.com/wknapik/191619bfa650b8572115cd07197f3baf/raw/92519bba5df08082e9e62b392938bf8d625eacb7/empty_bucket.sh -O amazonS3/bin/empty_bucket.sh && chmod u+x amazonS3/bin/empty_bucket.sh`

Install jq (for `empty_bucket.sh`)

`sudo zypper install jq`


### Notes
File `lifecycle.json` is not used. It's just an example of json lifecycle configuration.
Directory `bckp` contains older scripts, not used anymore.

# List all the buckets and their content
To double check all our files are synced correctly you can list all the buckets and their content with:

`aws s3 ls | cut -d ' ' -f3 | while read list; do echo $list; aws s3 ls s3://${list} --recursive > all-bucket-list.${list}.txt; done`

Check if we have backup of all the files:

<code>for a in *.s3-backup-manifest.log; do
    names=`echo ${a%.s3-backup-manifest.log}`.txt
    names=all-bucket-list.${names}
    echo $names
    cat $a | grep "tar.gz" | cut -f3 | while read list;do 
        echo $list
        if grep -q $list $names; then
            echo "OK, found"
        else
            echo "NOT found"
        fi
    done
done</code>
