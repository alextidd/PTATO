process getContext {
  tag {"getContext ${sample_id}"}
  label 'getContext'
  shell = ['/bin/bash', '-euo', 'pipefail']

  input:
    tuple( val(donor_id), val(sample_id), path(vcf), path(tbi) )

  output:
    tuple( val(donor_id), val(sample_id), path("${sample_id}.context.bed"), emit: bed)

  script:
    """
    host=\$(hostname)
    echo \${host}

    R --slave --file=${baseDir}/scripts/R/get_context.R --args ${vcf} ${sample_id}.context.bed ${params.ref_genome}
    """
}
