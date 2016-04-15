--This script required two parameters 1.input file path including filename/directory 2. output directory_name . This script will create a new directory in output directory as PigCustomerVisitPattern.

LOGDATA1 = LOAD'$PARAM1' USING PigStorage(' ') AS (ip_addr:CHARARRAY,col2:CHARARRAY,col3:CHARARRAY,visit_date:CHARARRAY,timezone:CHARARRAY,col6:CHARARRAY,col7:CHARARRAY,col8:CHARARRAY,col9:CHARARRAY,col10:CHARARRAY,URL:CHARARRAY,browser:CHARARRAY,os:CHARARRAY,os_flavour:CHARARRAY,os_version:CHARARRAY,col16:CHARARRAY,col17:CHARARRAY,col18:CHARARRAY,col19:CHARARRAY,col20:CHARARRAY,col21:CHARARRAY,coL22:CHARARRAY,col23:CHARARRAY); --Loading prepocessed data
LOGDATA2 = FOREACH LOGDATA1 GENERATE ip_addr,visit_date,ToDate(visit_date,'dd/MMM/YYYY:HH:mm:ss') As Visit_FormatDate; --converting visit_Date into date format
LOGDATA3 = DISTINCT LOGDATA2;
LOGDATA4 = FOREACH LOGDATA3 GENERATE ip_addr,visit_date,GetDay(Visit_FormatDate) As Day:chararray,GetMonth(Visit_FormatDate) As Month:chararray,GetYear(Visit_FormatDate) As  Year:chararray,GetHour(Visit_FormatDate) As Hour:int; -- getting Day,Month,Year and Hour as seperate columns from formatted visit date

LOGDATA5 = FOREACH LOGDATA4 GENERATE ip_addr,visit_date,CONCAT(CONCAT(CONCAT(CONCAT(Day,'/'),Month),'/'),Year) As DayMonth:chararray,Hour; --forming date in truncated formatt
LOGDATA6 = GROUP LOGDATA5 BY (ip_addr,DayMonth,Hour); 

LOGDATA7 = FOREACH LOGDATA6 GENERATE group,MIN(LOGDATA5.visit_date) As MinTime:chararray,MAX(LOGDATA5.visit_date) As MaxTime:chararray; --Getting min and max visit_dates grouped by ip,date and hour
LOGDATA8 = FOREACH LOGDATA7 GENERATE group.ip_addr,group.DayMonth,group.Hour,ToDate(MinTime,'dd/MMM/YYYY:HH:mm:ss') As Visit_MinTime,ToDate(MaxTime,'dd/MMM/YYYY:HH:mm:ss') As Visit_MaxTime; -- casting min and max dates as date formatt.
LOGDATA9 = FOREACH LOGDATA8 GENERATE ip_addr,DayMonth,Hour,SecondsBetween(Visit_MaxTime,Visit_MinTime) As SecondsSpend; --getting no. of seconds spend in between min and max time.
LOGDATA10 = GROUP LOGDATA9 BY (ip_addr,DayMonth);
LOGDATA11 = FOREACH LOGDATA10 GENERATE group,AVG(LOGDATA9.SecondsSpend)/60 As AverageDailyTimeInMin;

STORE LOGDATA11 INTO '$PARAM2/PigCustomerVisitPattern'; --soting custom visit patterns
