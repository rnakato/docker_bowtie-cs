#!/bin/bash -e
cmdname=`basename $0`
function usage()
{
    echo "bowtie.sh [-t <csfasta|csfastq>] [-d bamdir] <csfastq|prefix of csfasta & qual> <output prefix> <build> <param>" 1>&2
}

type=csfastq
bamdir=cram
while getopts t:d: option
do
    case ${option} in
	t)
	    type=${OPTARG}
	    ;;
	d)
	    bamdir=${OPTARG}
	    ;;
	*)
	    usage
	    exit 1
	    ;;
    esac
done
shift $((OPTIND - 1))

# check arguments
if [ $# -ne 4 ]; then
  usage
  exit 1
fi

fastq=$1
prefix=$2
build=$3
param=$4

post=`echo $param | tr -d ' '`
index=/opt/$build
genome=$build/genome.fa

file=$bamdir/$prefix$post-$build.sort.cram
if test -e $file && test 1000 -lt `wc -c < $file` ; then
    echo "$file already exist. quit"
    exit 0
fi

if test ! -e $bamdir; then mkdir $bamdir; fi
if test ! -e log; then mkdir log; fi

ex_samtools="samtools view -C - -T $genome | samtools sort -O cram"

ex_csfastq(){
    if [[ $fastq = *.gz ]]; then
#	command="bowtie -S -C $index <(zcat $fastq) $param --chunkmbs 2048 -p12 | samtools view -bS - | samtools sort > $file"
	command="bowtie -S -C $index <(zcat $fastq) $param --chunkmbs 2048 -p12 | $ex_samtools > $file"
    else
#	command="bowtie -S -C $index $fastq $param --chunkmbs 2048 -p12 | samtools view -bS - | samtools sort > $file"
	command="bowtie -S -C $index $fastq $param --chunkmbs 2048 -p12 | $ex_samtools > $file"
    fi
    echo $command
    eval $command
}
ex_csfasta(){
    csfasta=`ls $fastq*csfasta*`
    qual=`ls $fastq*qual*`
    if [[ $csfasta = *.gz ]]; then
#	command="bowtie -S -C $index -f <(zcat $csfasta) -Q <(zcat $qual) $param --chunkmbs 2048 -p12 | samtools view -bS - | samtools sort > $file"
	command="bowtie -S -C $index -f <(zcat $csfasta) -Q <(zcat $qual) $param --chunkmbs 2048 -p12 | $ex_samtools > $file"
    else
#	command="bowtie -S -C $index -f $csfasta -Q $qual $param --chunkmbs 2048 -p12 | samtools view -bS - | samtools sort > $file"
	command="bowtie -S -C $index -f $csfasta -Q $qual $param --chunkmbs 2048 -p12 | $ex_samtools > $file"
    fi
    echo $command
    eval $command

    if test ! -e $file.crai; then samtools index $file; fi
}

log=log/bowtie-$prefix$post-$build
if test $type = "csfasta"; then  ex_csfasta >& $log;
elif test $type = "csfastq"; then  ex_csfastq >& $log;
else
    usage
    exit 1
fi
