#!/bin/bash
# cd /lustre/scratch125/casm/team268im/at31/PTATO ; bsub -q long -M50000 -n8 -R 'span[hosts=1] select[mem>50000] rusage[mem=50000]' -J rm_shapeit_chr -o log/rm_shapeit_chr_%J.out -e log/rm_shapeit_chr_%J.err 'bash src/00b_remove_shapeit_chr.sh'

# modules
module load bcftools-1.19/python-3.11.6

# dirs
indir=resources/hg38/shapeit/Phasing_reference/
outdir=resources/hg38/shapeit/Phasing_reference_no_chr/
mkdir $outdir

# remove chr prefix from chr names
for vcf in resources/hg38/shapeit/Phasing_reference/*.vcf.gz; do
    
  # generate output filenames
  filename=$(basename $vcf)
  output_vcf="$outdir/$filename"

  echo "Processing $vcf..."

  # Remove the 'chr' prefix
  bcftools view "$vcf" | sed 's/^chr//' | bgzip -c > "$output_vcf"

  # Reindex the new VCF file
  bcftools index --threads 8 -t "$output_vcf"

  echo "Finished processing $vcf -> $output_vcf"

done

echo "All files processed successfully."