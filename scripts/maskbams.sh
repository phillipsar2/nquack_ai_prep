#!/bin/bash -l

#SBATCH --job-name=maskbams
#SBATCH -D /group/jrigrp11/aphillip/nquack_ai
#SBATCH -e /group/jrigrp11/aphillip/nquack_ai/slurm_log/sterror_mask_%a_%j.txt
#SBATCH -o /group/jrigrp11/aphillip/nquack_ai/slurm_log/stdoutput_mask_%a_%j.txt
#SBATCH -p high2
#SBATCH -t 2-00:00
#SBATCH --mem 1G
#SBATCH --array=0-41%20

# Set database name
databasename="tripsacum"
echo $databasename

# Load list of bam files from bamlist txt file into bam_array object
bamlist=""$databasename"/processed_bamlist.txt"
mapfile -t bam_array < $bamlist

# Identify bam as the sample with the array number in bamlist
bam="${bam_array[$SLURM_ARRAY_TASK_ID]}"
sample_name=$(echo "$bam" | sed 's|.*/||; s/\.dedup\.bam$//')

echo $bam
echo $sample_name

# Load modules
module load samtools # v1.19.2

mkdir -p "$databasename"/repeats_removed

## Remove Repeats from bams
	samtools view $bam -b -h -o /dev/null \
		-U "$databasename"/repeats_removed/"$sample_name".masked.bam \
		-L "$databasename"/repeat_database/"$databasename".gff3.bed
