# Circlexplore3 pipeline using Singularity
This is a definition file for circlexplore3 container

## To build the container
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


## Create folders(mount) for inputdata, result and reference
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

## Run container
To perform circlexplore3 for fastq file example_R1.fastq and example_R2.fastq
```bash
singularity run --bind ./inputdata:/inputdata,./result:/result,./reference:/reference cir3.sif example
```

Of course, if you are using BU SCC and have the access to casa, you can use the following command
```bash
singularity run --bind ./inputdata:/inputdata,./result:/result,/restricted/projectnb/casa/mtLin/reference:/reference cir3.sif example
```

## Run container on PBS
A very basic demo of qsub file is provided, named runCIR3.qsub
You can run it with bash
```bash
qsub runCIR3.qsub <name>
```
please remember delete /hisat/align.sam and /inputdata/${name}_R1.fastq files, since they are quite large.

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