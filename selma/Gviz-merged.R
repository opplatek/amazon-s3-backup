library("GenomicFeatures")
library("Gviz")

gtf<-"Homo_sapiens.GRCh38.91.sorted.added_transcripts.gtf.gz"
geneid<-"ENSG00000109819"
genename<-"PPARGC1A"
stranded<-"rev" # {for,rev} strandedness of the library
indir<-"."
assembly<-"hg38"
inbam<-list.files(indir, pattern = ".bam$")

names(inbam)<-gsub(".Homo_sapiens.GRCh38.91.sorted.added_transcriptsAligned.sortedByCoord.out.chr4.bam", "", inbam)

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

displayPars(readTrack1)<-list(col="#00B0F0", fill="#00B0F0", ylim=c(0,30))
displayPars(readTrack2)<-list(col="#BFBFBF", fill="#BFBFBF", ylim=c(0,125))
displayPars(readTrack3)<-list(col="violet", fill="violet", ylim=c(0,1))

displayPars(grtrack)<-list(fill="#66FF66", col="lightgrey", lwd.border=2)
displayPars(grtrack.d)<-list(fill="#66FF66", col="lightgrey", lwd.border=2)

pdf("coverage_sashimi-merged.pdf")
    # all together
    plotTracks(list(readTrack2, readTrack1, readTrack3, grtrack.d),
               sizes=c(rep(x = 3, length(inbam)), 0.5),
               minCoverageHeight = 0,
               min.height=0, 
               lwd=0.25, lwd.border=0.25, lwd.sashimiMax = 5,
               background.title="transparent", 
               fontcolor.title="black", col.axis="darkgrey",
               fontsize = 10,
               type = c('coverage', 'sashimi'), 
               sashimiFilterTolerance = 5L)
    # all together with exons
    plotTracks(list(readTrack2, grtrack.d, readTrack1, grtrack.d, readTrack3, grtrack.d),
               sizes=c(rep(x = c(3, 0.5), length(inbam))),
               minCoverageHeight = 0,
               min.height=0, 
               lwd=0.25, lwd.border=0.25, lwd.sashimiMax = 5,
               background.title="transparent", 
               fontcolor.title="black", col.axis="darkgrey",
               fontsize = 10,
               type = c('coverage', 'sashimi'), 
               sashimiFilterTolerance = 5L)               
    # separately
    plotTracks(list(readTrack1, grtrack, grtrack.d),
               minCoverageHeight = 0,
               min.height = 0, 
               coverageHeight = 0.08,
               lwd=0.05, lwd.border=0,
               background.title="transparent", 
               fontcolor.title="black", col.axis="darkgrey",
               type = c('coverage', 'pileup', 'sashimi'),
               sashimiFilterTolerance = 5L)
    plotTracks(list(readTrack2, grtrack, grtrack.d),
               minCoverageHeight = 0,
               min.height = 0, 
               coverageHeight = 0.08,
               lwd=0.05, lwd.border=0,
               background.title="transparent", 
               fontcolor.title="black", col.axis="darkgrey",
               type = c('coverage', 'pileup', 'sashimi'), 
               sashimiFilterTolerance = 5L)
    plotTracks(list(readTrack3, grtrack, grtrack.d),
               minCoverageHeight = 0,
               min.height = 0, 
               coverageHeight = 0.08,
               lwd=0.05, lwd.border=0,
               background.title="transparent", 
               fontcolor.title="black", col.axis="darkgrey",
               type = c('coverage', 'pileup', 'sashimi'), 
               sashimiFilterTolerance = 5L)
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

