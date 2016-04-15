--This script required three parameters 1.input file path including filename/directory of preprocessed file 2. input file name/directory for purchased ip's 3. output directory_name . This script will create a new directory in output directory as Not_Purchased.

WebLog_Clnsd = LOAD'$PARAM1' USING PigStorage(' ') AS (ip_addr:CHARARRAY,col2:CHARARRAY,col3:CHARARRAY,visit_date:CHARARRAY,timezone:CHARARRAY,col6:CHARARRAY,col7:CHARARRAY,col8:CHARARRAY,col9:CHARARRAY,col10:CHARARRAY,URL:CHARARRAY,browser:CHARARRAY,os:CHARARRAY,os_flavour:CHARARRAY,os_version:CHARARRAY,col16:CHARARRAY,col17:CHARARRAY,col18:CHARARRAY,col19:CHARARRAY,col20:CHARARRAY,col21:CHARARRAY,coL22:CHARARRAY,col23:CHARARRAY); --Loading prepocessed data

WebLog_Clnsd_Fin = FOREACH WebLog_Clnsd GENERATE ip_addr,visit_date,col6,URL,browser  ; -- Selecting only required columns 

Purchase_IP = LOAD'$PARAM2' AS (IP:CHARARRAY); --Loading IP's who have done purchasing in a relation Purchase_IP

Purchase_Dtls = JOIN WebLog_Clnsd_Fin BY ip_addr LEFT OUTER, Purchase_IP BY IP; -- Joining Cleaned weblog data and Purchased data using left outer join
Not_Purchased = FILTER Purchase_Dtls BY IP IS NULL;   --Filtering all records who have not purchased anything 

STORE Not_Purchased INTO '$PARAM3/Not_Purchased'; --Storing final data to file
