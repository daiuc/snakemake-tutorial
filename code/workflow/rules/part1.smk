'''
Work flow part 1: 

  - feature counts

'''


rule FeatureCounts:
  input:
    anno = config['Gene'],
    bam = 'resources/alignment/{sample}.bam'
  output: touch('results/featurecounts/{sample}.done')
  params:
    TMP = '/home/chaodai/scratch/TMP',
    prefix = 'results/featurecounts/{sample}',
  threads: 2
  resources:
    cpu = 2, mem_mb = 15000, time = 1600
  log: 'logs/featurecounts/{sample}.log'
  shell:
    '''
    featureCounts \
        --minOverlap 1 \
        -p --countReadPairs -T {threads} --tmpDir {params.TMP} \
        -a {input.anno} -F GTF -t gene \
        -o {params.prefix}.counts {input.bam}
    '''



rule combineCounts:
  input:
    fcDone = expand('results/featurecounts/{samp}.done', samp = SAMPLES),
    countFiles = expand('results/featurecounts/{samp}.counts', samp = SAMPLES)
  output: 'results/featurecounts/combined.counts'
  params:
    r_script  = 'workflow/scripts/combineCounts.R'
  shell:
    '''
    Rscript {params.r_script} {input.countFiles} {output}
    '''
