# PanAndropogoneae nQuack AI

Preparing the bam files associated with the PanAnd project for training in nQuack AI.

## Pipeline

0. Align bams to their reference genomes. Proces bams by sorting, adding read groups, and marking duplicates. This step has already been completed.

1. Using the reference genome's repeat annotation, mask repetitive regions in the bams.
