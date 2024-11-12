#!/bin/bash

# run
module load singularity
module load ISG/rocker/rver/4.4.0 
export R_LIBS_USER=$HOME/R-tmp-4.4
nextflow run ptato.nf \
  -c configs/run.config \
  -c ~/.nextflow/config \
  -c configs/run-template.config \
  -c configs/nextflow.config \
  -c configs/process.config \
  -c configs/resources.config \
  --out_dir out/ \
  -w work/ \
  -resume \
  -N at31@sanger.ac.uk