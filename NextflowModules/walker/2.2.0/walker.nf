process walker {
  tag {"walker ${sample_id}"}
  label 'walker'
  label 'walker_2_2_0'
  shell = ['/bin/bash', '-euo', 'pipefail']
  container = 'docker://vanboxtelbioinformatics/walker:2.2.0'

  input:
    tuple( val(donor_id), val(germline_sample_id), path(germline_vcf), path( germline_tbi), val(bam_sample_ids), val(bam_files), val(bai_files), val(sample_id), path(somatic_vcf), path(somatic_tbi) )

  output:
    tuple( val(donor_id), val(sample_id), path("${sample_id}.walker.vcf"), path("${sample_id}.walker.bed"), path("${sample_id}.walker.txt"), emit: walker_out)

  script:
    b = bam_files ? ' -b ' + bam_files.join(' -b ') : ''

    """
    host=\$(hostname)
    echo \${host}

    python /walker/walker.py \
    -g ${germline_vcf} \
    -s ${somatic_vcf} \
    -t ${task.cpus} \
    ${b} \
    -o ${sample_id} \
    -f vcf -f bed -f txt
    """
}
