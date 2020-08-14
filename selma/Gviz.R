library("GenomicFeatures")
library("Gviz")

gtf<-"E:/Results/selma/Homo_sapiens.GRCh38.91.sorted.added_transcripts.gtf.gz"
geneid<-"ENSG00000109819"
genename<-"PPARGC1A"
stranded<-"rev" # {for,rev} strandedness of the library
indir<-"E:/Results/selma/sashimi"
assembly<-"hg38"
inbam<-list.files(indir, pattern = ".bam$")
#inbed<-list.files(indir, pattern = ".bedGraph$")

names(inbam)<-gsub(".Homo_sapiens.GRCh38.91.sorted.added_transcriptsAligned.sortedByCoord.out.chr4.bam", "", inbam)
#names(inbed)<-gsub(".Homo_sapiens.GRCh38.91.sorted.added_transcriptsAligned.sortedByCoord.outSignal.Unique.str1.out.chr4.bedGraph", "", inbed)

txdb<-makeTxDbFromGFF(gtf, format="auto", organism="Homo sapiens", dataSource="Ensembl")

txdb.trans<-transcriptsBy(txdb, by="gene")

options(ucscChromosomeNames = FALSE)

grtrack.main <- GeneRegionTrack(
  txdb,
  genome=assembly,
  showId = FALSE,
  name = "Gene Annotation"
)

txdb.df<-as.data.frame(txdb.trans[geneid])
txnames<-txdb.df$tx_name

mychr<-unique(txdb.df$seqnames)
afrom<-min(txdb.df$start)
ato<-max(txdb.df$end)

# Strand for filtering the BAM alignment
if(stranded=="for"){
  readstrand<-unique(txdb.df$strand)  
}else if(stranded=="rev"){
  if(unique(txdb.df$strand)=="+"){
    readstrand<-"-"
  }else{
    readstrand<-"+"
  }
}

# Get only annotated introns
#txdb.genes<-intronsByTranscript(txdb)
#q<-GRanges(seqnames=mychr,
#          ranges=IRanges(start = afrom-150, end = ato+150),
#          strand=unique(txdb.df$strand))
#txdb.genes<-as.data.frame(subsetByOverlaps(txdb.genes, q))

grtrack<-grtrack.main
select_range <- grtrack@range[mcols(grtrack@range)$transcript %in% txnames]
grtrack@range <- select_range
grtrack@name<-genename

# Aesthetic adjustments
#displayPars(grtrack) <- list(col="transparent", fill=orange, background.title="transparent", 
#                             showTitle=FALSE, showId=FALSE, min.height=0, stackHeight=0.5, max.height=2, min.height=1) # Remove border around exons

grtrack.d<-grtrack
displayPars(grtrack.d)<-list(collapseTranscripts="meta") # Collapse "by gene"
grtrack.d@name<-genename
grtrack.d@range$symbol<-grtrack.d@range$gene # Fake transcript id to fit to meta visualization; we could use the above as well

maketrack<-function(inbam){
  iname<-gsub("v2", "", names(inbam))
  iname<-gsub("cns", "CNS", iname)
  iname<-gsub("ref", "Ref", iname)
  iname<-gsub("scrambled", "Scrambled", iname)
  readsTrackL<-Gviz:::.import.bam.alignments(inbam, GRanges(seqnames = mychr, ranges = IRanges(afrom-75, ato+75)))
  readsTrackL<-readsTrackL[strand(readsTrackL) == readstrand]
  readsTrackL <- AlignmentsTrack(readsTrackL, genome=assembly, isPaired=FALSE, name=iname, 
                                 aggregation="max", stacking='squish', missingAsZero=F)
}

readTrack1<-maketrack(inbam[1])
readTrack2<-maketrack(inbam[2])
readTrack3<-maketrack(inbam[3])
readTrack4<-maketrack(inbam[4])
readTrack5<-maketrack(inbam[5])
readTrack6<-maketrack(inbam[6])
readTrack7<-maketrack(inbam[7])
readTrack8<-maketrack(inbam[8])
readTrack9<-maketrack(inbam[9])

displayPars(readTrack1)<-list(col="#00B0F0", fill="#00B0F0", ylim=c(0,10))
displayPars(readTrack2)<-list(col="#00B0F0", fill="#00B0F0", ylim=c(0,10))
displayPars(readTrack3)<-list(col="#00B0F0", fill="#00B0F0", ylim=c(0,10))
displayPars(readTrack4)<-list(col="#BFBFBF", fill="#BFBFBF", ylim=c(0,40))
displayPars(readTrack5)<-list(col="#BFBFBF", fill="#BFBFBF", ylim=c(0,40))
displayPars(readTrack6)<-list(col="#BFBFBF", fill="#BFBFBF", ylim=c(0,40))
displayPars(readTrack7)<-list(col="violet", fill="violet", ylim=c(0,1))
displayPars(readTrack8)<-list(col="violet", fill="violet", ylim=c(0,1))
displayPars(readTrack9)<-list(col="violet", fill="violet", ylim=c(0,1))

displayPars(grtrack.d)<-list(fill="#66FF66", col="lightgrey", lwd.border=2)

# Add some finese sashimi filtering (=only reads on exons, not the one in the middle)
#introns<-GRanges(mychr, IRanges(start = c(txdb.genes$start),
#                                  end = c(txdb.genes$end)), strand=unique(txdb.df$strand))

pdf("coverage_sashimi.pdf")
  plotTracks(list(readTrack4, readTrack5, readTrack6,
                  readTrack1, readTrack2, readTrack3,
                  readTrack7, readTrack8, readTrack9, 
                  grtrack.d),
             sizes=c(rep(x = 2, length(inbam)), 1),
             minCoverageHeight = 0,
             min.height=0, 
             lwd=0.25, lwd.border=0.25, lwd.sashimiMax = 5,
             background.title="transparent", 
             fontcolor.title="black", col.axis="darkgrey",
             type = c('coverage', 'sashimi'), 
             sashimiFilterTolerance = 5L) 
#             sashimiFilter = introns)
dev.off()

# merged bams
#readTrack4<-maketrack(inbam[4])
#readTrack8<-maketrack(inbam[8])
#readTrack12<-maketrack(inbam[12])

# plotTracks(list(readTrack4, readTrack8, readTrack12, grtrack.d),
#            sizes=c(rep(x = 3, 9), 2),
#            minCoverageHeight = 0,
#            max.height=2, min.height=0,
#            background.title="transparent",
#            fontcolor.title="black",
#            type = c('coverage', 'sashimi'))

