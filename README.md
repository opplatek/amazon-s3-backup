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

### Notes
File `lifecycle.json` is not used. It's just an example of json lifecycle configuration.
Directory `bckp` contains older scripts, not used anymore.