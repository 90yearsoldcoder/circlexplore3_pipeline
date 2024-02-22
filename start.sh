#!/bin/bash -l

#run the command in terminal: bash ./start.sh list.txt /restricted/projectnb/casa/mtLin/bu_brain_rna/batch4/minus/rawdata
nsamples=$(wc -l < ${1})
echo "The number of samples is ${nsamples}"
echo "The path: ${2}"
qsub -t 1-${nsamples} runCIR3.qsub ${1} ${2}
