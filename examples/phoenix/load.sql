drop table if exists all_us_zip_codes;
drop table if exists all_us_states;
create table all_us_zip_codes (
    code varchar2(10),
    city varchar2(100),
    state varchar2(2),
    county varchar2(100),
    area_code varchar2(10),
    lat number,
    lon number
);
--
create table all_us_states (
    abbr varchar2(2),
    name varchar2(100)
);
--
set loadformat csv names on row_limit off;
--
load all_us_zip_codes C:\Users\sabya\gitrepos\oracle\examples\phoenix\all_us_zipcodes.csv
load all_us_states C:\Users\sabya\gitrepos\oracle\examples\phoenix\all_us_states.csv
--
select * from all_us_zip_codes;
--
select * from all_us_states;