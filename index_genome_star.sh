#!/bin/bash
# generating an index

# invoke with sbatch --cpus-per-task=12 --mem=35g --gres=lscratch:20 --time=1-00:00 index_genome_star.sh

INDEXDIR=/home/buckleyrm/data/resources/genomes/CanFam3.1/STAR
GENOMEDIR=/home/buckleyrm/data/resources/genomes/CanFam3.1/fasta
GENOME=CanFam3.1.fa
GTFDIR=/home/buckleyrm/data/resources/genomes/CanFam3.1/gtf
GTF=CanFam3.1_NCBI.gtf

module load STAR/2.7.3a

STAR \
--runThreadN $SLURM_CPUS_PER_TASK \
--runMode genomeGenerate \
--genomeDir $INDEXDIR \
--genomeFastaFiles $GENOMEDIR/$GENOME \
--sjdbGTFfile $GTFDIR/$GTF \
--sjdbOverhang 74
