#! /bin/bash
# this file is STAR.sh

# for read groups we can create a manifest



CONFIG=/Users/buckleyrm/Desktop/eQTL_metadata/sample_rna_seq_runs.txt
GENOMEDIR=/Users/buckleyrm/Desktop/RNA_data_test/test_run/in/genome/CanFam3.1/fasta
GENOME=CanFam3.1.fa
GTFDIR=/Users/buckleyrm/Desktop/RNA_data_test/test_run/in/genome/CanFam3.1/gtf
GTF=CanFam3.1_NCBI.gtf
BAMDIR=/Users/buckleyrm/Desktop/RNA_data_test/test_run/out/bam
TMPDIR=/Users/buckleyrm/Desktop/RNA_data_test/test_run/out/tmp
SM=S1


awk '{print $9"\t"$10"\tID:"$1"."$3"."$4"."$5"\\tPU:"$4"."$5"."$6"\\tSM:"$1"\\tPL:"$2"\\tLB:"$3}' $CONFIG | tail -n +2 > $TMPDIR/$SM.manifest.txt


#module load samtools/1.6 || fail "could not load samtools module"
#module load STAR         || fail "could not load STAR module"


STAR \
    --runThreadN 1 \
    --genomeDir $GENOMEDIR/$GENOME \
    --sjdbOverhang 50 \
    --readFilesManifest $TMPDIR/$SM.manifest.txt \
    --readFilesCommand zcat \
    --outSAMtype BAM SortedByCoordinate \
    --outTmpDir=/$TMPDIR \
    --outFileNamePrefix $BAMDIR/$SM






