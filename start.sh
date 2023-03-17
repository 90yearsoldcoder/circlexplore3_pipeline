#!/bin/bash -l

#run the command in terminal: bash ./start.sh sample_list.txt path_to_reads_folder
nsamples=$(wc -l < ${1})
echo "The number of samples is ${nsamples}"
qsub -t 1-${nsamples} runCIR3.qsub ${1} ${2}
