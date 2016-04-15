#!/bin/bash
####################################################################################
# Description :  This script is used to run pig script for web log                 #
#                data cleansing.                                                   #
#                Before running the script in MR mode make sure                    # 
#                FLUME# has run and data is present in HDFS                        #
#                                                                                  #
# Usage       :  bash pig_run.sh <project-dir> <output-path> <input-path>          #
####################################################################################
. ~/.bashrc

date=`date +"%d%m%Y%H%M%S"`
logfile=weblog_$date.log
if [ $# -lt 3 -o $# -gt 3 ]
   then
      printf "Invalid number of arguments supplied\n"
      printf "Usage - \"bash pig_run.sh <project-dir> <output-path> <input-path>\"\n"
      printf "Exiting...\n"
      exit 1
fi
hdfs_outpath=$2
hdfs_inpath=$3
piggybank=$PIGGYBANK

# Verify project directory exists
if [ -d "$1" ]
    then
       cd $1
       rm *.log
       script_name=`ls -lrt *.pig | awk '{print $9}'`
       printf "Directory successfully changed to $1\n"
else
       printf "Project directory doesn't exist. Exiting shell...\n"
       exit 1
fi

printf "Running pig script $script_name\n"

read -p "Select mode - (M)apRedue|(L)ocal default is MR: " mode

if [ ! -z "$mode" -a "$mode" = "L" -o "$mode" = "l" ]
     then
       printf "Script will run in Local mode\n"
        printf "Running job"
        pig -x local -f $script_name -param piggybank=$piggybank -param hdfs_outpath=$hdfs_outpath -param hdfs_inpath=$hdfs_inpath &>$logfile
elif [ "$mode" = "M" -o "$mode" = "m" -o "$mode" = "" ]
     then
          printf "Script will run in MR mode\n"
          # Check NameNode is up or not
          hdfs_daemon=`jps|grep -iw "namenode"|awk '{print $2}'`

          if [ ! -z "$hdfs_daemon" -a "$hdfs_daemon" = "NameNode" ]
             then
		printf "Running job"
	        pig -f $script_name -param piggybank=$piggybank -param hdfs_outpath=$hdfs_outpath -param hdfs_inpath=$hdfs_inpath &>$logfile
          else
               printf "Hadoop services are not running. Exiting..\n"
               exit 1
          fi
else
      printf "Invalid input. Exiting..\n"
      exit 1
fi

for i in {1..5}
do
   printf "."
   sleep 1
done

printf "\n"

tail -1 $logfile | grep -i success &>/dev/null
job_status=$?
if [ $job_status -ne 0 ]
then
  printf "Job failed. Please check the log file $1/$logfile \n"
else
  printf "Job completed successfully. Log file - $1/$logfile\n"
fi
