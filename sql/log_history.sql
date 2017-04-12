set linesize 200
set trimspool on
set feedback off

Column 00 format 999
Column 01 format 999
Column 02 format 999
Column 03 format 999
Column 04 format 999
Column 05 format 999
Column 06 format 999
Column 07 format 999
Column 08 format 999
Column 09 format 999
Column 10 format 999
Column 11 format 999
Column 12 format 999
Column 13 format 999
Column 14 format 999
Column 15 format 999
Column 16 format 999
Column 17 format 999
Column 18 format 999
Column 19 format 999
Column 20 format 999
Column 21 format 999
Column 22 format 999
Column 23 format 999

select trunc(first_time) AS Day,
sum(DECODE(to_char(first_time, 'HH24'), '00', 1, 0)) AS "00",
sum(DECODE(to_char(first_time, 'HH24'), '01', 1, 0)) AS "01",
sum(DECODE(to_char(first_time, 'HH24'), '02', 1, 0)) AS "02",
sum(DECODE(to_char(first_time, 'HH24'), '03', 1, 0)) AS "03",
sum(DECODE(to_char(first_time, 'HH24'), '04', 1, 0)) AS "04",
sum(DECODE(to_char(first_time, 'HH24'), '05', 1, 0)) AS "05",
sum(DECODE(to_char(first_time, 'HH24'), '06', 1, 0)) AS "06",
sum(DECODE(to_char(first_time, 'HH24'), '07', 1, 0)) AS "07",
sum(DECODE(to_char(first_time, 'HH24'), '08', 1, 0)) AS "08",
sum(DECODE(to_char(first_time, 'HH24'), '09', 1, 0)) AS "09",
sum(DECODE(to_char(first_time, 'HH24'), '10', 1, 0)) AS "10",
sum(DECODE(to_char(first_time, 'HH24'), '11', 1, 0)) AS "11",
sum(DECODE(to_char(first_time, 'HH24'), '12', 1, 0)) AS "12",
sum(DECODE(to_char(first_time, 'HH24'), '13', 1, 0)) AS "13",
sum(DECODE(to_char(first_time, 'HH24'), '14', 1, 0)) AS "14",
sum(DECODE(to_char(first_time, 'HH24'), '15', 1, 0)) AS "15",
sum(DECODE(to_char(first_time, 'HH24'), '16', 1, 0)) AS "16",
sum(DECODE(to_char(first_time, 'HH24'), '17', 1, 0)) AS "17",
sum(DECODE(to_char(first_time, 'HH24'), '18', 1, 0)) AS "18",
sum(DECODE(to_char(first_time, 'HH24'), '19', 1, 0)) AS "19",
sum(DECODE(to_char(first_time, 'HH24'), '20', 1, 0)) AS "20",
sum(DECODE(to_char(first_time, 'HH24'), '21', 1, 0)) AS "21",
sum(DECODE(to_char(first_time, 'HH24'), '22', 1, 0)) AS "22",
sum(DECODE(to_char(first_time, 'HH24'), '23', 1, 0)) AS "23",
count( * ) AS "DAILY"
FROM v$log_history
GROUP BY trunc(first_time)
ORDER BY 1;
