for tag in latest
do
    docker build -t rnakato/bowtie-cs-yeast:$tag .
    docker push rnakato/bowtie-cs-yeast:$tag
done

singularity pull bowtie-cs.img docker://rnakato/bowtie-cs-yeast
