#!/bin/bash -l

#SBATCH --job-name=blast
#SBATCH -D /group/jrigrp11/aphillip/nquack_ai
#SBATCH -e /group/jrigrp11/aphillip/nquack_ai/slurm_log/sterror_blast_%a_%j.txt
#SBATCH -o /group/jrigrp11/aphillip/nquack_ai/slurm_log/stdoutput_blast_%a_%j.txt
#SBATCH -p high2
#SBATCH -t 2-00:00
#SBATCH --mem 8G

module load ncbi-rmblastn/2.14.0
module load bedtools2/2.31.1 
module load samtools # 1.19.2-xxdq3op

# Set database name
databasename="tripsacum"
echo $databasename

# Set references
#ref="../andropogon/data/genome/JGIgenome/v1/Andropogon_gerardii_var_Kellogg_1272_HAP1_V1_release/Andropogon_gerardii_var_Kellogg_1272/sequences/Andropogon_gerardii_var_Kellogg_1272.mainGenome.fasta"
#chloroplast="andropogon/blast/NC_040111.1.fasta"

ref="/group/jrigrp10/tripsacum_dact/data/genome/v1/Td-KS_B6_1-Draft-PanAnd-1.0.noalternate.fasta"
chloroplast="/group/jrigrp10/tripsacum_dact/data/repeat_abundance/repeat_seq/chloroplast.fasta"

# Create list of masked bam files
ls "$databasename"/repeats_removed > "$databasename"/masked_bamlist.txt

# Make blastdb
makeblastdb -in $chloroplast -dbtype nucl -parse_seqids

echo "made chloroplast database"

# blast reference to the new db
mkdir -p "$databasename"/blast

blastn -db $chloroplast \
-query $ref \
-out "$databasename"/blast/"$databasename"_blast.out \
-outfmt 6

# Pull out the location in the query that match the chloroplast
cut -f 1,7,8 "$databasename"/blast/"$databasename"_blast.out | \
awk '{if($2 > $3) {print $1,$3,$2;} else if($2 < $3) print $1,$2,$3;}' OFS='\t' | \
awk '{a=$2-1;print $1,a,$3;}' OFS='\t' | \
bedtools sort > "$databasename"/blast/"$databasename"_blast.bed










