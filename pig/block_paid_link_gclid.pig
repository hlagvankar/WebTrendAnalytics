--This script required two parameters 1.input file path including filename/directory 2. output directory_name . This script will create a new directory in output directory as block_paid_links.

LOGDATA1 = LOAD'$PARAM1' USING PigStorage(' ') AS (ip_addr:CHARARRAY,col2:CHARARRAY,col3:CHARARRAY,visit_date:CHARARRAY,timezone:CHARARRAY,col6:CHARARRAY,col7:CHARARRAY,col8:CHARARRAY,col9:CHARARRAY,col10:CHARARRAY,URL:CHARARRAY,browser:CHARARRAY,os:CHARARRAY,os_flavour:CHARARRAY,os_version:CHARARRAY,col16:CHARARRAY,col17:CHARARRAY,col18:CHARARRAY,col19:CHARARRAY,col20:CHARARRAY,col21:CHARARRAY,coL22:CHARARRAY,col23:CHARARRAY); --Loading prepocessed data

LOGDATA2 = filter LOGDATA1 by (URL matches '.*gclid.*'); -- filtering the rows which are having gclid in url position(os_flavour)
LOGDATA3 = GROUP LOGDATA2 BY (ip_addr,visit_date);
LOGDATA4 = FOREACH LOGDATA3 GENERATE FLATTEN(group) AS (ip_addr, visit_date),COUNT(LOGDATA2.ip_addr) AS CNT;
LOGDATA5 = FILTER LOGDATA4 BY CNT>2;  --This will give us the gclid count is more than 2.

STORE LOGDATA5 INTO '$PARAM2/block_paid_links';



