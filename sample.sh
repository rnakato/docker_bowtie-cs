#docker run -it --rm rnakato/bowtie-cs-yeast bowtie.sh -t csfasta data/038_1 038_1 scer "-n2 -k1"
#singularity exec bowtie-cs.img bowtie_cs.sh -t csfasta data/038_1 038_1 scer "-n2 -k1"

singularity exec bowtie-cs.img bowtie_cs.sh -t csfastq data/SRR1554990.fastq.gz SRR1554990 scer "-n2 -k1"
