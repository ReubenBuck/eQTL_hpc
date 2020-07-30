#! /bin/bash
# this file is STAR.sh

# for read groups we can create a manifest

# invoke with: sbatch --cpus-per-task=12 --mem=35g --gres=lscratch:20 STAR_map.sh

CONFIG=/home/buckleyrm/data/projects/eQTL/config_files/AUSS_25461.config
SM=$(cat $CONFIG | cut -f1 | tail -n 1)
RUNDIR=/home/buckleyrm/data/projects/eQTL/run_dir/$SM
mkdir -p $RUNDIR

INDEX=/home/buckleyrm/data/resources/genomes/CanFam3.1/STAR

TMPDIR=/lscratch/$SLURM_JOB_ID/STARtmp




awk '{print $9"\t"$10"\tID:"$1"."$3"."$4"."$5"\\tPU:"$4"."$5"."$6"\\tSM:"$1"\\tPL:"$2"\\tLB:"$3}' $CONFIG | tail -n +2 > $RUNDIR/manifest.txt


module load samtools/1.9 || fail "could not load samtools module"
module load STAR/2.7.3a || fail "could not load STAR module"


STAR \
    --runThreadN $SLURM_CPUS_PER_TASK \
    --genomeDir $INDEX \
    --sjdbOverhang 75 \
    --readFilesManifest $RUNDIR/manifest.txt \
    --readFilesCommand zcat \
    --outSAMtype BAM SortedByCoordinate \
    --outTmpDir=$TMPDIR \
    --outFileNamePrefix $RUNDIR/$SM






