#!/bin/bash
# cd /lustre/scratch125/casm/team268im/at31/PTATO ; bsub -q long -M2000 -R 'span[hosts=1] select[mem>2000] rusage[mem=2000]' -J ptato -o log/ptato_%J.out -e log/ptato_%J.err 'bash src/02_run.sh'

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