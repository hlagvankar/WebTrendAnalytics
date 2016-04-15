# WebTrendAnalytics
User behavioral pattern use cases
To check for weblog file format visit http://publib.boulder.ibm.com/tividd/td/ITWSA/ITWSA_info45/en_US/HTML/guide/c-logs.html

1. Customer Visit Patterns
2. Visits but no purchase
3. IP accessing the site as a paid link
4. Returning and non returning IP
5. Product Trend Analysis
6. Peak and off-peak hours access 
7. Crawlers on the site – Number of crawlers and visit pattern
8. Pages for which 404 encountered frequently

WebTrendAnalytics/pig/weblog_clean.pig => process records and create weblog schema.

WebTrendAnalytics/pig/paramfile.txt => Parameter file to be passed to pig script.

WebTrendAnalytics/sh/pig_run.sh => shell script to run pig script and which expects parameter as mentioned in script.

WebTrendAnalytics/hive => Contains all the hive queries for above use cases

WebTrendAnalytics/oozie => contains sample workflow