#!/bin/bash
# cd /lustre/scratch125/casm/team268im/at31/PTATO ; bsub -q long -M2000 -R 'span[hosts=1] select[mem>2000] rusage[mem=2000]' -J ptato_demo -o log/ptato_demo_%J.out -e log/ptato_demo_%J.err 'bash src/01_run_demo.sh'

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