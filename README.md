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
singularity build --fakeroot cir3.sif cir3_container.def
```

Then you will find the file cir3.sif in your current directory


## Create folders(mount) for inputdata, result and reference
```bash
mkdir inputdata result reference
```

## Move files to the inputdata folder and reference
The postion of inputdata file
```
./inputdata/${name}_R1.fastq
./inputdata/${name}_R2.fastq
```

The position of reference
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

## Run container in SHELL mode(for developer)
It is used for debugging and debuging only. You can get into the container and check the environment by this way.
```bash
singularity shell --no-home --bind ./inputdata:/inputdata,./result:/result,/restricted/projectnb/casa/mtLin/reference:/reference cir3.sif
source activate circexplorer3
```