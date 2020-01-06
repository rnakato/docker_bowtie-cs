for tag in latest
do
#    docker build -t rnakato/bowtie-cs-yeast:$tag .
    docker push rnakato/bowtie-cs-yeast:$tag
done
