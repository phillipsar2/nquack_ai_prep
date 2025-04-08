#!/bin/bash -l

#SBATCH --job-name=maskbams
#SBATCH -D /group/jrigrp11/aphillip/nquack_ai
#SBATCH -e /group/jrigrp11/aphillip/nquack_ai/slurm_log/sterror_mask_%a_%j.txt
#SBATCH -o /group/jrigrp11/aphillip/nquack_ai/slurm_log/stdoutput_mask_%a_%j.txt
#SBATCH -p high2
#SBATCH -t 2-00:00
#SBATCH --mem 8G
#SBATCH --array=0-1

# Set database name
species=("andropogon" "tripsacum")

databasename="${species[$SLURM_ARRAY_TASK_ID]}"
echo $databasename

# Load list of bam files
bamlist=

mapfile -t bam_array < $bamlist

# Load modules
module load samtools # v1.19.2

#mkdir repeats_removed

## Remove Repeats from bams
for i in "${bam_array[@]}"
do
	sample_name="${i%.bam}"
	samtools view $i -b -h -o /dev/null \
		-U $databasename/repeats_removed/$sample_name.bam \
		-L $databasename/repeat_database/$databasename.gff.bed
	echo "$i" "$sample_name"
done
