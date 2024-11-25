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

# rename shapeit maps
mkdir resources/hg38/shapeit/shapeit_maps_no_chr/
for file in resources/hg38/shapeit/shapeit_maps/chr* ; do
  filename=$(basename $file)
  echo resources/hg38/shapeit/shapeit_maps/${filename#chr}
  cp $file resources/hg38/shapeit/shapeit_maps_no_chr/${filename#chr}
done

# Dan's solution:
module load bcftools
module load tabix

# create key for bcftools annotate
for chr in {1..22} X ; do 
    echo chr${chr} ${chr}
done >> chr_names.txt

# rename - will error on X
for chr in {1..22} X; do
  echo start $chr
  bcftools annotate \
    --rename-chrs chr_names.txt \
    Phasing_reference/CCDG_14151_B01_GRM_WGS_2020-08-05_chr${chr}.filtered.shapeit2-duohmm-phased.vcf.gz \
    -Oz \
    -o Phasing_reference/CCDG_14151_B01_GRM_WGS_2020-08-05_${chr}.filtered.shapeit2-duohmm-phased.vcf.gz
  tabix -p vcf \
    Phasing_reference/CCDG_14151_B01_GRM_WGS_2020-08-05_${chr}.filtered.shapeit2-duohmm-phased.vcf.gz
done

# fix X
bcftools annotate \
  --threads 2 \
  --rename-chrs chr_names.txt \
  Phasing_reference/CCDG_14151_B01_GRM_WGS_2020-08-05_chrX.filtered.eagle2-phased.v2.vcf.gz \
  -Oz \
  -o Phasing_reference/CCDG_14151_B01_GRM_WGS_2020-08-05_X.filtered.eagle2-phased.v2.vcf.gz;
tabix -p vcf \
  Phasing_reference/CCDG_14151_B01_GRM_WGS_2020-08-05_X.filtered.eagle2-phased.v2.vcf.gz

# clean up 
rm chr_names.txt