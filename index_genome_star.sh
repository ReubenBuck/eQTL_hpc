#!/bin/bash
# generating an index

# invoke with sbatch --cpus-per-task=12 --mem=35g --gres=lscratch:20 --time=1-00:00 index_genome_star.sh

INDEXDIR=/home/buckleyrm/data/resources/genomes/CanFam3.1/STAR
RSEMDIR=/home/buckleyrm/data/resources/genomes/CanFam3.1/rsem
GENOMEDIR=/home/buckleyrm/data/resources/genomes/CanFam3.1/fasta
GENOME=CanFam3.1.fa
GTFDIR=/home/buckleyrm/data/resources/genomes/CanFam3.1/gtf
GTF=CanFam3.1_NCBI.gtf

module load STAR/2.7.3a
module load rsem/1.3.2

STAR \
--runThreadN $SLURM_CPUS_PER_TASK \
--runMode genomeGenerate \
--genomeDir $INDEXDIR \
--genomeFastaFiles $GENOMEDIR/$GENOME \
--sjdbGTFfile $GTFDIR/$GTF \
--sjdbOverhang 74


rsem-prepare-reference $GENOMEDIR/$GENOME $RSEMDIR/$GENOME --gtf $GTFDIR/$GTF --num-threads $SLURM_CPUS_PER_TASK



