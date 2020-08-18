#!/bin/bash
#
# Somehow simple backup of directories to Amazon S3 storage
#

#main_dir="/home/mns/workspace/projects/ribothrypsis/data/minion"
#main_dir="/home/joppelt/projects/ribothrypsis/analysis"
main_dir="/home/joppelt/projects/ribothrypsis/samples"
sync_dir="/home/joppelt/playground/glacier_test"
bucket="s3://ribothrypsis-samples-jan"
manifest="/home/joppelt/playground/s3-sync-manifest-samples.log" # File to keep track of what was backed up

class="GLACIER" # ["GLACIER"|"STANDARD"] 
upload="cp" # ["sync"|"cp"] sync to upload only new/change files (slower but doesn't upload all) or cp to upload all the files (faster but uploads all)

bckp=(
"ath.dRNASeq.inclERCC.PRJEB32782.ERR3764346.polyA.CIP.decap.REL5.1"
"ath.dRNASeq.inclERCC.PRJEB32782.ERR3764350.polyA.CIP.decap.REL5.1"
"hsa.Akron3Seq.HeLa.whole.1"
"hsa.Akron3Seq.HeLa.whole.2"
"hsa.Akron5Seq.HeLa.whole.2"
"hsa.Akron5Seq.HeLa.whole.3"
"hsa.Akron5Seq.HeLa.whole.4"
"hsa.CAGE.HeLa.cytosolic.polyA.ENCSR000CJH.1"
"hsa.CAGE.HeLa.cytosolic.polyA.ENCSR000CJH.2"
"hsa.CAGE.HeLa.cytosolic.polyA.ENCSR000CJS.1"
"hsa.CAGE.HeLa.nuclear.polyA.ENCSR000CJI.1"
"hsa.CAGE.HeLa.nuclear.polyA.ENCSR000CJI.2"
"hsa.CAGE.HeLa.nuclear.polyA.ENCSR000CLH.1"
"hsa.CAGE.HeLa.nuclear.polyA.ENCSR000CLH.2"
"hsa.CAGE.HeLa.nucleolus.polyA.ENCSR000CJT.1"
"hsa.CAGE.HeLa.xxx.polyA.ENCSR000CJJ.1"
"hsa.CAGE.HeLa.xxx.polyA.ENCSR000CJJ.2"
"hsa.cDNASeq.CEPH1463.polyA.1"
"hsa.dRNASeq.293T.polyA.XRN1KO.REL5.long.2"
"hsa.dRNASeq.HeLa.polyA.CIP.decap.REL5.long.1"
"hsa.dRNASeq.HeLa.polyA.decap.REL5.long.1"
"hsa.dRNASeq.HeLa.polyA.PNK.REL5.1"
"hsa.dRNASeq.HeLa.polyA.REL3.long.atail.1"
"hsa.dRNASeq.HeLa.polyA.REL5.1"
"hsa.dRNASeq.HeLa.polyA.REL5.long.1"
"hsa.dRNASeq.HeLa.polyA.REL5OH.long.1"
"hsa.dRNASeq.HeLa.total.REL3.1"
"hsa.dRNASeq.HeLa.total.REL3.2"
"hsa.dRNASeq.HeLa.total.REL3.3"
"hsa.dRNASeq.HeLa.total.REL3.long.atail.1"
"hsa.dRNASeq.HeLa.total.REL3.long.atail.2"
"hsa.dRNASeq.HeLa.total.REL5.long.REL3.10"
"hsa.dRNASeq.HeLa.total.REL5.long.REL3.4"
"hsa.dRNASeq.HeLa.total.REL5.long.REL3.5"
"hsa.dRNASeq.HeLa.total.REL5.long.REL3.6"
"hsa.dRNASeq.HeLa.total.REL5.long.REL3.8"
"hsa.dRNASeq.HeLa.total.REL5.long.REL3.9"
"hsa.RiboSeq.HEK293T.WT.1"
"hsa.RiboSeq.HEK293T.WT.2"
"hsa.RiboSeq.HEK293T.XRN1KO.1"
"hsa.RiboSeq.HEK293T.XRN1KO.2"
"hsa.RiboSeq.HeLa.15_34.1"
"hsa.RiboSeq.HeLa.15_34.2"
"hsa.RiboSeq.HeLa.async.2"
"hsa.RiboSeq.HeLa.Gln_6hr.15_34.1"
"hsa.RiboSeq.HeLa.Gln_6hr.CHXTIG.15_34.1"
"hsa.RiboSeq.HeLa.Gln_9hr.15_34.1"
"hsa.RNASeq.HeLa.async.1"
"hsa.RNASeq.HeLa.async.2"
"hsa.RNASeq.HeLa.cytosolic.polyA.ENCSR000CPP.1"
"hsa.RNASeq.HeLa.cytosolic.polyA.ENCSR000CPP.2"
"hsa.RNASeq.HeLa.cytosolic.polyA.ENCSR000CQT.1"
"hsa.RNASeq.HeLa.nuclear.polyA.ENCSR000CPQ.1"
"hsa.RNASeq.HeLa.nuclear.polyA.ENCSR000CPQ.2"
"hsa.RNASeq.HeLa.xxx.polyA.ENCSR000CPR.1"
"hsa.RNASeq.HeLa.xxx.polyA.ENCSR000CPR.2"
"mmu.cDNASeq.inclSIRV.PRJEB27590.ERR2680377.1"
"mmu.cDNASeq.inclSIRV.PRJEB27590.ERR3363658.1"
"mmu.cDNASeq.inclSIRV.PRJEB27590.ERR3363660.1"
"mmu.dRNASeq.inclSIRV.PRJEB27590.ERR2680375.1"
"mmu.dRNASeq.inclSIRV.PRJEB27590.ERR2680379.1"
"mmu.dRNASeq.inclSIRV.PRJEB27590.ERR3363657.1"
"mmu.dRNASeq.inclSIRV.PRJEB27590.ERR3363659.1"
"other"
"sc.ontcDNASeq.polyA+.1"
"sc.ontRNASeq.polyA+.1"
"sc.ontRNASeq.polyA+.2"
"sc.ontRNASeq.polyA+.3"
"sc.ontRNASeq.polyA+.4"
"sc.ontRNASeq.polyA+.5"
"sc-RCS.dRNA-Seq"
"sc-RCS.dRNA-Seq.1"
"sc-RCS.dRNA-Seq.REL3.1"
"sc-RCS.dRNA-Seq.REL5.long.REL3.long.1"
"sc-RCS.dRNA-Seq.REL5.long.REL3.long.atail.1"
"sc.RiboSeq.tcpseq.Syo1.RS"
"sc.RiboSeq.tcpseq.Syo1.SSU"
"sc.RiboSeq.tcpseq.WT.input"
"sc.RiboSeq.tcpseq.WT.RS"
"sc.RiboSeq.tcpseq.WT.SSU"
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
	                printf "%s\t%s\t%s\t%s\t%s\t%b\n" "$date" "$main_dir/$dir" "${dir%/raw}.tar.gz" "$filesize" "$md5sum" "$bucket" >> $manifest

			echo "Syncing $sync_dir/${dir%/raw}.tar.gz to storage class $class"
			if [ $upload = "sync" ]; then
				echo "Doing aws s3 sync."
				aws s3 sync $sync_dir $bucket --storage-class $class # If we want to upload only new or modified files
			elif [ $upload = "cp" ]; then
				echo "Doing aws s3 cp."
				aws s3 cp $sync_dir $bucket --storage-class $class --recursive # If we want to simply upload a file/files (--recursive - uploads ALL files)
			else
				echo "Didn't recognize upload: $upload, doing aws s3 sync (default)."
				aws s3 sync $sync_dir $bucket --storage-class $class
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
aws s3 cp $manifest $bucket

echo "All done"
