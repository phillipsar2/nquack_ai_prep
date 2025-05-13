#!/bin/bash -l

#SBATCH --job-name=sumstatss
#SBATCH -D /group/jrigrp11/aphillip/nquack_ai
#SBATCH -e /group/jrigrp11/aphillip/nquack_ai/slurm_log/sterror_sumstats_%a_%j.txt
#SBATCH -o /group/jrigrp11/aphillip/nquack_ai/slurm_log/stdoutput_sumstats_%a_%j.txt
#SBATCH -p high2
#SBATCH -t 2-00:00
#SBATCH --mem 2G

module load samtools # 1.19.2-xxdq3op

# Set database name
databasename="tripsacum"
echo $databasename

# Set final file name
# Tripsacum_Phillips_stat.txt
# Populus_stat.txt
# Andropogon_stat.txt
out="Tripsacum_Phillips_stat.txt"

# Create bamlist
ls "$databasename"/filtered > "$databasename"/filtered_bamlist.txt

# Create file
mkdir -p "$databasename"/metadata

echo "filename total primary secondary supplementary duplicates primary_dup \
mapped mapped_% primary_mapped primary_mapped_% paired_in_seq read1 read2 \
properly_paired properly_paired_% with_itself_mate_mapped singletons singletons_% \
with_mate_ondiffchr with_mate_ondiffchr_lowqual" > "$databasename"/metadata/"$out"

## Loop through BAM files
while read name ; do
#	mv $databasename/filtered/$name $databasename/filtered/"$name"red.bam
	echo -n "$databasename/filtered/"$name"  " >> "$databasename"/metadata/"$out"
	samtools flagstat "$databasename"/filtered/"$name" -O tsv | awk '{printf "%s ", $1}' >> "$databasename"/metadata/"$out"
	echo "" >> "$databasename"/metadata/"$out"
done < "$databasename"/filtered_bamlist.txt
