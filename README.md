# PanAndropogoneae nQuack AI

Preparing the bam files associated with the PanAnd project for training in nQuack AI.

## Pipeline

0. Align bams to their reference genomes. Proces bams by sorting, adding read groups, and marking duplicates. This step has already been completed.

1. Using the reference genome's repeat annotation, mask repetitive regions in the bams (Scripts 1-2).

2. Remove off-target sites identified by blasting the chloroplast ref to the nuclear ref (Scripts 3-4).

3. Remove low-quality reads (Script 4).

4. Generate summary statistics (Script 5).

## Project organization
<pre>
├── scriptsi
│   ├── README.md
│   ├── gff3tobed.sh		<- (1) convert gff3repeat annotation to bedfile 
│   ├── maskbams.sh		<- (2) mask bams using repeat bedfiles
│   ├── blast_chl.sh            <- (3) identify off-target sites
│   ├── filterbams.sh           <- (4) remove off-target sites and low-quality reads
│   ├── sumstats.sh             <- (5) generate summary stats for the bams
│   └── 
├── data 			<- folder for each species containing same structure
│   ├── species
│   |   ├── repeatdatabse	<- gff3 and related files 
│   |   ├── repeats_removed	<- repeat-masked bams
│   |   ├── blast
│   |   ├── filtered
│   |   └── metadata
│   └── structure
├── 
├── 
├── slurm_log
└── 
</pre>
