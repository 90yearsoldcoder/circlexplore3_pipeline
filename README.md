# Circlexplore3 pipeline using Singularity
This is a definition file for circlexplore3 container

## 0. To build the container
Assume you are using computational cluster without root privilege.

For BU SCC user
    If you are using BU SCC, please switch to SCC-i01 using the command below
```bash
ssh SCC-i01
cd /path/to/folder
```

Build the container using fakeroot mode
```bash
git clone git@github.com:90yearsoldcoder/circlexplore3_pipeline.git
cd circlexplore3_pipeline
singularity build --fakeroot cir3.sif cir3_container.def
```

Then you will find the file cir3.sif in your current directory


## 1. Create folders(mount) for inputdata, result and reference
```bash
mkdir inputdata result reference
```

## Move files to the inputdata folder and reference
The folder structure of inputdata files
```
./inputdata/${name}_R1.fastq
./inputdata/${name}_R2.fastq
```

The folder structure of reference
```
./reference/hg38.fa 
./reference/hisat_index/hisat_index 
./reference/bowtieIndex/bowtie1_index 
./reference/hg38_ref_all2.gtf
```

For BU SCC user, you can find those reference at 
```
/restricted/projectnb/casa/mtLin/reference
```

## 3. Run container
To perform circlexplore3 for fastq file example_R1.fastq and example_R2.fastq
```bash
singularity run --bind ./inputdata:/inputdata,./result:/result,./reference:/reference cir3.sif example
```

Of course, if you are using BU SCC and have the access to casa, you can use the following command
```bash
singularity run --bind ./inputdata:/inputdata,./result:/result,/restricted/projectnb/casa/mtLin/reference:/reference cir3.sif example
```

## (optional)Run container on PBS
A very basic demo of qsub file is provided, named runCIR3.qsub
You can run it with bash
```bash
qsub runCIR3.qsub <name>
```
please remember delete /hisat/align.sam and /inputdata/${name}_R1.fastq files, since they are quite large.

## (optional)Run container batch by batch and automatically
switch to other branch of the repo
```
git clone -b tcbatch git@github.com:90yearsoldcoder/circlexplore3_pipeline.git
```
or
copy the start.sh file and runCIR3.qsub from my demo(/restricted/projectnb/casa/mtLin/circexplore3/circlexplore3_pipeline/) *on branch tcbatch

Then, run the container
```
bash start.sh sample_list.txt path/to/inputdata
```

## Run container in SHELL mode(for developer)
It is used for debugging and debuging only. You can get into the container and check the environment in this way.
```bash
singularity shell --no-home --bind ./inputdata:/inputdata,./result:/result,/restricted/projectnb/casa/mtLin/reference:/reference cir3.sif
source activate circexplorer3
```

## An kind reminder(for developer)
It is an reminder for anyone who wants to develop the container.
In the definition file
```
%enviroment
    export balabala
```
this part works and ONLY works in SHELL mode.
As a result, ```%runscript``` will not share the environment setting.

Why it is so important?
if you write down "source activate <env>" in ```%runscript```, it goes wrong even though you have already export the conda/bin as a path.
You cannot activate the conda env by this way.
The interesting thing is you can activate the conda environment in SHELL mode of the container.

How to avoid this problem when cannot use SHELL mode?
You can write the environment setting in ```%post``` part.
Something like this
```
%post
echo ". /miniconda3/etc/profile.d/conda.sh" >> $SINGULARITY_ENVIRONMENT
echo "conda activate circexplorer3" >> $SINGULARITY_ENVIRONMENT
```

# 4.(temporary pipeline) For emergent use
Since our current pipeline cannot handle flexible reference, here we provide a temporary way to use Alex's new annotation
## 4.1 copy files to working folder
```
cd path/to/working/directory
cp /restricted/projectnb/ad-portal/circ3_maxiumCapacity_test/circlexplore3_pipeline/cir3.sif .
cp /restricted/projectnb/ad-portal/circ3_maxiumCapacity_test/circlexplore3_pipeline/runCIR3.qsub .
cp /restricted/projectnb/ad-portal/circ3_maxiumCapacity_test/circlexplore3_pipeline/start.sh .
```

## 4.2 prepare folders
```
mkdir inputdata result reference
```

## 4.3 prepare list of samples
You can find a typical list at ```/restricted/projectnb/ad-portal/circ3_maxiumCapacity_test/circlexplore3_pipeline/list.txt``` </br>
Please notice that the sample name in the list did not have the pair number suffix. In other word, sample1 is just sample1, but not listed as sample1_1 and sample1_2.

## 4.4 prepare the path to samples(fastq.gz)
You can find a typical folder at ```/restricted/projectnb/casa/mtLin/bu_brain_rna/batch4/minus/rawdata```
Here, we used '_1' and '_2' to indicate the pair number, please follow the rule.

## 4.5 (optional) setting the number of sample running at the sametime in PBS
In the file ```runCIR3.qsub line 7```, the parameter -tc is for the number of tasks running at the same time. My default setting is 30.

## 4.6 run the pipeline
```
bash ./start.sh list.txt path/to/sample_fastqgz
```

An example command is
```
bash ./start.sh list.txt /restricted/projectnb/casa/mtLin/bu_brain_rna/batch4/minus/rawdata
```