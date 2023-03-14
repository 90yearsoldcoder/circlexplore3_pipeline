#!/bin/bash -l

#bash start.sh cell_type


qsub -t 1-100 runCIR3.qsub list.txt

list_path=${1}

cat ${1}|while read line
do
    echo "upload task ${line}"
    eval qsub runCIR3.qsub $line
done