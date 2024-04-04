
rule BamFlagStats:
  input: "resources/alignment/{sample}.bam"
  output: "resources/alignment/{sample}.flagstat.txt"
  threads: 1
  log: "logs/BamFlagStats/{sample}.log"
  shell:
    '''
    samtools flagstat -@ {threads} {input} 1> {output} 2> {log}
    '''

