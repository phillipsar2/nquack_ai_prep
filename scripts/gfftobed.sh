#!/bin/bash -l

#SBATCH --job-name=repeatdatabase
#SBATCH -D /group/jrigrp11/aphillip/nquack_ai
#SBATCH -e /group/jrigrp11/aphillip/nquack_ai/slurm_log/sterror_rpdb_%a_%j.txt
#SBATCH -o /group/jrigrp11/aphillip/nquack_ai/slurm_log/stdoutput_rpdb_%a_%j.txt
#SBATCH -p high2
#SBATCH -t 1-00:00
#SBATCH --mem 2G
#SBATCH --array=1-2

species=("andropogon" "tripsacum")

databasename="${species[$SLURM_ARRAY_TASK_ID]}"
echo $databasename

# mkdir repeat_database
cut -f1,4,5 $species/repeat_database/*.gff3 | \
perl -pi -e 's/ˆ#.*\n//g' > $species/repeat_database/$databasename.gff3.bed
