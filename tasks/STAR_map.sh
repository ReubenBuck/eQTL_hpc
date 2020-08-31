#! /bin/bash
# this file is STAR_map.sh

# invoke with: sbatch --cpus-per-task=12 --mem=35g --gres=lscratch:20 STAR_map.sh

CONFIG=/home/buckleyrm/data/projects/eQTL/config_files/TS_AUSS_59775.config
SM=$(cat $CONFIG | cut -f1 | tail -n 1)
RUNDIR=/home/buckleyrm/data/projects/eQTL/run_dir/$SM
mkdir -p $RUNDIR

INDEX=/home/buckleyrm/data/resources/genomes/CanFam3.1/STAR
GTF=/home/buckleyrm/data/resources/genomes/CanFam3.1/gtf/CanFam3.1_NCBI.gtf
RSEMINDEX=/home/buckleyrm/data/resources/genomes/CanFam3.1/rsem/CanFam3.1.fa

TMPDIR=/lscratch/$SLURM_JOB_ID/STARtmp


awk '{print $7"\t"$8"\tID:"$1"."$3"."$4"."$5" PU:"$4"."$5"."$6" SM:"$1" PL:"$2" LB:"$3}' $CONFIG | tail -n +2 > $RUNDIR/manifest.txt

module load samtools/1.10 || fail "could not load samtools module"
module load STAR/2.7.3a || fail "could not load STAR module"
module load GATK/4.1.8.1
module load rsem/1.3.2
module load rnaseqc/2.3.2

STAR \
 --runThreadN $SLURM_CPUS_PER_TASK \
 --genomeDir $INDEX \
 --sjdbOverhang 74 \
 --readFilesIn $(cut -f1 $RUNDIR/manifest.txt | paste -s -d, -) \
 --readFilesCommand zcat \
 --outSAMtype BAM SortedByCoordinate \
 --outSAMattrRGline $(cut -f3 $RUNDIR/manifest.txt | paste -s -d, - | sed "s/,/ , /g") \
 --outTmpDir $(pwd)/tmp \
 --quantMode TranscriptomeSAM \
 --outFileNamePrefix $RUNDIR/$SM.



# could proably put mark duplicates in here
# this stuff seems to only take a few minutes 

gatk MarkDuplicates -I $RUNDIR/$SM.Aligned.sortedByCoord.out.bam -O $RUNDIR/$SM.markDup.bam -M $RUNDIR/$SM.markDup.metrics

mkdir -p $RUNDIR/qc

# will need to update gene names on gtf to remove underscore
# cat CanFam3.1_NCBI.gtf | sed "s/_1\"; transcript_id/\.1\"; transcript_id/g" > CanFam3.1_NCBI.2.gtf
# cat CanFam3.1_NCBI.gtf | sed "s/_1\"; transcript_id/\.1\"; transcript_id/g" | sed "s/_1\"; db_xref/\.1\"; db_xref/g" > CanFam3.1_NCBI.2.gtf
rnaseqc $GTF $RUNDIR/$SM.markDup.bam $RUNDIR/qc

# SM may need to have path
rsem-calculate-expression --num-threads 10 --fragment-length-max 75 --no-bam-output --bam $RUNDIR/$SM.Aligned.toTranscriptome.out.bam $RSEMINDEX $RUNDIR/$SM


