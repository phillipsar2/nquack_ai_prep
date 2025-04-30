#!/bin/bash -l

#SBATCH --job-name=filterbams
#SBATCH -D /group/jrigrp11/aphillip/nquack_ai
#SBATCH -e /group/jrigrp11/aphillip/nquack_ai/slurm_log/sterror_filterbams_%a_%j.txt
#SBATCH -o /group/jrigrp11/aphillip/nquack_ai/slurm_log/stdoutput_filterbams_%a_%j.txt
#SBATCH -p high2
#SBATCH -t 2-00:00
#SBATCH --mem 2G
#SBATCH --array=0-173%20

module load ncbi-rmblastn/2.14.0
module load bedtools2/2.31.1
module load samtools # 1.19.2-xxdq3op

# Set database name
databasename="andropogon"
echo $databasename

# Create list of masked bams files from directory
bamlist=""$databasename"/masked_bamlist.txt"
mapfile -t bam_array < $bamlist

# Identify bam as the sample with the array number in bamlist
bam="${bam_array[$SLURM_ARRAY_TASK_ID]}"
sample_name=$(echo "$bam" | sed 's|.*/||; s/\.masked\.bam$//')

echo $bam
echo $sample_name

# Make a directory
mkdir -p "$databasename"/offtarget_removed

## Remove the marked regions
samtools view "$databasename"/repeats_removed/"$sample_name".masked.bam -b -h -o /dev/null \
-U "$databasename"/offtarget_removed/"$sample_name".offtarget.bam \
-L "$databasename"/blast/"$databasename"_blast.bed

## Quality filter
mkdir -p "$databasename"/filtered

samtools view -b -q 10 "$databasename"/offtarget_removed/"$sample_name".offtarget.bam > "$databasename"/filtered/"$sample_name".filtered.bam

rm "$databasename"/offtarget_removed/"$sample_name".offtarget.bam
