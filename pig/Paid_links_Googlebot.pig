LOGDATA1 = LOAD'$PARAM1' USING PigStorage(' ') AS (ip_addr:CHARARRAY,col2:CHARARRAY,col3:CHARARRAY,visit_date:CHARARRAY,timezone:CHARARRAY,col6:CHARARRAY,col7:CHARARRAY,col8:CHARARRAY,col9:CHARARRAY,col10:CHARARRAY,URL:CHARARRAY,browser:CHARARRAY,os:CHARARRAY,os_flavour:CHARARRAY,os_version:CHARARRAY,col16:CHARARRAY,col17:CHARARRAY,col18:CHARARRAY,col19:CHARARRAY,col20:CHARARRAY,col21:CHARARRAY,coL22:CHARARRAY,col23:CHARARRAY); --Loading prepocessed data
LOGDATA2 = foreach LOGDATA1 generate ip_addr,visit_date,timezone,col7,URL,os,os_flavour,os_version; -- selecting required columns
LOGDATA3 = order LOGDATA2 by ip_addr;
LOGDATA4 = filter LOGDATA3 by (os_flavour matches '.*Googlebot.*'); -- filtering the rows which are having Googlebot in 14th position(os_flavour)


store LOGDATA4 into '$PARAM2/Goodlebot_ips'; --  storing the rows which are having Googlebot in 14th position(os_flavour)
