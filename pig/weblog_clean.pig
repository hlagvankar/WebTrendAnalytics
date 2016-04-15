REGISTER $piggybank;

DEFINE DATE_EXTRACT org.apache.pig.piggybank.evaluation.util.apachelogparser.DateExtractor('dd/MMM/yyyy:HH:mm:ss Z','yyyy-MM-dd HH:mm:ss');

/* remove output directory if exists */
rmf $hdfs_outpath

/*1st load file */
logfile = load '$hdfs_inpath' USING TextLoader as (line:chararray);

/* extract each record into variable */
weblog_raw = FOREACH logfile GENERATE FLATTEN (REGEX_EXTRACT_ALL(line,'^(\\S+) (\\S+) (\\S+) \\[([\\w:/]+\\s[+\\-]\\d{4})\\] "(.+?)" (\\S+) (\\S+) "([^"]*)" "([^"]*)"') ) AS (ip: chararray, rfc: chararray, uname: chararray, date: chararray, request: chararray, status_code: int, bytes: chararray, referer: chararray, browser: chararray);

/* clean data i.e. remove spider,bots etc */
weblog_filter = filter weblog_raw by ( (NOT (browser matches '.*spider.*') ) AND (NOT (browser matches '.*bot.*')) )/* AND ( ( NOT (LOWER(request) matches '.*css.*') )  AND (NOT ( LOWER(referer) matches '.*css.*') ) ) AND (NOT( LOWER(request) matches '.*png.*') ) */;

/* generate clean weblog data and store it into HDFS */
weblog = foreach weblog_filter generate $0,$1,$2,DATE_EXTRACT($3),$4,$5,$6,$7,$8;

store weblog into '$hdfs_outpath' using PigStorage('|');
