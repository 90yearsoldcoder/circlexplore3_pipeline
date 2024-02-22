#!/bin/bash

# Replace 'cir3_tasks' with 'monitor.qsub' based on your example, or any jobname you're interested in
JOBNAME="cir3_tasks"

# Command to get the job accounting information, filtered by job name
qacct -d 1 -o minty -j | awk -v jobname="$JOBNAME" '
BEGIN { record = 0; }
$1 == "jobname" && $2 == jobname { record = 1; }
record == 1 && $1 == "ru_wallclock" {
    print "Running time for job", jobname ": " $2 " seconds";
    record = 0;
}'
