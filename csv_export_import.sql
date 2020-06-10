load data infile 'D:/Vgen_SVN/reporting/doc/weather.csv'
into table inverter_sensor_box_weather
character set utf8
fields terminated by ','
lines terminated by '\n'
(idx, rsrs_id, sensor_box_id, bbbb, cccc, dddd, eeee, isvisual, create_date);

alter table inverter_sensor_box_weather modify sensor_box_id varchar(30)

load data infile 'D:/Vgen_SVN/reporting/doc/weather.csv'
replace
into table inverter_sensor_box_weather
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines
(idx, rsrs_id, sensor_box_id, bbbb, cccc, dddd, eeee, isvisual, @var_create_date)
set create_date = STR_TO_DATE(@var_create_date, '%d-%b-%y %H:%i:%s');

SELECT * FROM inverter_sensor_box_weather
WHERE create_date LIKE '2020-05%';

load data infile 'D:/Vgen_SVN/reporting/doc/weather.csv'
replace
into table inverter_sensor_box_weather
character set utf8
fields terminated by ','
lines terminated by '\n'
ignore 1 lines
(idx, rsrs_id, sensor_box_id, bbbb, cccc, dddd, eeee, isvisual, @create_date)
set create_date = STR_TO_DATE(@create_date, '%Y-%m-%d %H:%i:%s')

alter table 'inverter_sensor_box_weather' add column 'date' datetime default NULL 'eeee';

HR_

-- set primary key
ALTER TABLE sensor ADD CONSTRAINT sensor_PK PRIMARY KEY (idx);

-- set Auto increment
alter table sensor modify column idx bigint not null auto_increment;

-- set start point value of auto increment
alter table weather.sensor auto_increment = 1;

-- check structure of table
desc sensor

load data infile 'D:/Vgen_SVN/reporting/doc/weather.csv'
replace
into table sensor
character set utf8
fields terminated by ','
lines terminated by '\n'
ignore 1 lines
(idx, rsrs_id, sensor_box_id, bbbb, cccc, dddd, eeee, isvisual, @create_date)
--set create_date = STR_TO_DATE(@create_date, "%Y-%m-%d %H:%i:%s")

truncate sensor

-- export csv
select
    *
from
    sensor
into outfile 'tmp/weather_sensor.csv'
fields terminated by ','
lines terminated by '\n'; 

-- import csv
load data infile 'C:/Program Files/MariaDB 10.2/data/tmp/weather_sensor.csv'
replace
into table sensor
character set utf8
fields terminated by ','
lines terminated by '\n'
ignore 1 lines
(idx, rsrs_id, sensor_box_id, bbbb, cccc, dddd, eeee, isvisual, create_date)
--set create_date = STR_TO_DATE(@create_date, "%Y-%m-%d %H:%i:%s")

-- import csv with column name
select 'SEQ_NO', 'STACC_NO', 'PLANT_ID',
    'GRAPE_GBN', 'SLE_WNT_DT', 'RES_GNRRS_ID',
    'HR_00', 'HR_01', 'HR_02', 'HR_03', 'HR_04', 'HR_05',
    'HR_06', 'HR_07', 'HR_08', 'HR_09', 'HR_10', 'HR_11',
    'HR_12', 'HR_13', 'HR_14', 'HR_15', 'HR_16', 'HR_17',
    'HR_18', 'HR_19', 'HR_20', 'HR_21', 'HR_22', 'HR_23'
union all
select SEQ_NO, STACC_NO, PLANT_ID,
    GRAPE_GBN, SLE_WNT_DT, RES_GNRRS_ID,
    HR_00, HR_01, HR_02, HR_03, HR_04, HR_05,
    HR_06, HR_07, HR_08, HR_09, HR_10, HR_11,
    HR_12, HR_13, HR_14, HR_15, HR_16, HR_17,
    HR_18, HR_19, HR_20, HR_21, HR_22, HR_23
from tb_z_elec_bidg
where GRAPE_GBN = 'pvg' and SLE_WNT_DT like '2020-05%'
into outfile 'tmp/actual_pv.csv'
fields terminated by ','
lines terminated by '\n';

select 'IDX', 'PLANT_ID', 'SUMDATE', 'METERNO', 'PW_KHW', 'GRAPE_GBN', 'create_date'
union all
select *
from tb_z_vww_f_sum_meter
where SUMDATE like '2020-05-%' and GRAPE_GBN = 'pvg'
into outfile 'tmp/predict_pv.csv'
fields terminated by ','
lines terminated by '\n'

create table if not exists pv.actual_pv(
        SEQ_NO          int(11)     PRIMARY KEY not null auto_increment,
        STACC_NO        varchar(20) not null default 1,
        PLANT_ID        varchar(45) null,
        GRAPE_GBN       varchar(20) not null,
        SLE_WNT_DT      datetime    null,
        RES_GNRRS_ID    varchar(20) not null,
        HR_00           double      null,
        HR_01           double      null,
        HR_02           double      null,
        HR_03           double      null,
        HR_04           double      null,
        HR_05           double      null,
        HR_06           double      null,
        HR_07           double      null,
        HR_08           double      null,
        HR_09           double      null,
        HR_10           double      null,
        HR_11           double      null,
        HR_12           double      null,
        HR_13           double      null,
        HR_14           double      null,
        HR_15           double      null,
        HR_16           double      null,
        HR_17           double      null,
        HR_18           double      null,
        HR_19           double      null,
        HR_20           double      null,
        HR_21           double      null,
        HR_22           double      null,
        HR_23           double      null
);

-- alter table pv.actual_pv add CONSTRAINT pv.actual_pv PRIMARY KEY (SEQ_NO);

load data infile 'D:/Vgen_SVN/reporting/doc/actual_pv.csv'
replace
into table actual_pv
character set utf8
fields terminated by ','
lines terminated by '\n'
ignore 1 lines
(SEQ_NO,STACC_NO,PLANT_ID,GRAPE_GBN,SLE_WNT_DT,RES_GNRRS_ID,HR_00,HR_01,HR_02,HR_03,HR_04,HR_05,HR_06,HR_07,HR_08,HR_09,HR_10,HR_11,HR_12,HR_13,HR_14,HR_15,HR_16,HR_17,HR_18,HR_19,HR_20,HR_21,HR_22,HR_23)

create table if not exists pv.predict_pv(
    IDX         int(11)     PRIMARY KEY not null auto_increment,
    PLANT_ID    varchar(50) null,
    SUMDATE     varchar(45) not null,
    METERNO     varchar(45) null,
    PW_KHW      float       null,
    GRAPE_GBN   varchar(30) null,
    create_date datetime    null
)

load data infile 'D:/Vgen_SVN/reporting/doc/predict_pv.csv'
replace
into table predict_pv
character set utf8
fields terminated by ','
lines terminated by '\n'
ignore 1 lines
(IDX,PLANT_ID,SUMDATE,METERNO,PW_KHW,GRAPE_GBN,create_date)
