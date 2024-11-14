#!/bin/bash

# run demo
module load singularity
module load ISG/rocker/rver/4.4.0 
export R_LIBS_USER=$HOME/R-tmp-4.4
nextflow run ptato.nf \
  -c demo/example_out/run_demo.config \
  --genome_fasta /lustre/scratch125/casm/team268im/at31/PTATO/demo/resources/Homo_sapiens_assembly38.fasta \
  --out_dir demo/out/ \
  -w work/demo/ \
  -resume \
  -N at31@sanger.ac.uk