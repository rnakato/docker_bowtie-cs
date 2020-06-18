FROM debian:latest
LABEL maintainer "Ryuichiro Nakato <rnakato@iam.u-tokyo.ac.jp>"
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /opt
ENV PATH /opt/bowtie-1.1.2:/opt:${PATH}

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    python \
    zip unzip \
    ca-certificates \
    samtools \
    && apt-get clean

ADD bowtie-1.1.2-linux-x86_64.zip .
RUN unzip bowtie-1.1.2-linux-x86_64.zip \
    && rm bowtie-1.1.2-linux-x86_64.zip

ADD scer scer
ADD spom spom
RUN bowtie-build -C scer/genome.fa scer/scer
RUN bowtie-build -C spom/genome.fa spom/spom

ADD bowtie_cs.sh bowtie_cs.sh
RUN chmod +x bowtie_cs.sh

CMD ["/bin/bash"]
