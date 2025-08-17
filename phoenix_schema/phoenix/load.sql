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
drop table if exists phoenix.uscities cascade constraint;
create table phoenix.uscities (
    city  varchar2(100),
    state_id varchar2(2),
    state_name varchar2(100),
    county_name varchar2(100)
);
--
set loadformat csv names on row_limit off;
--
load all_us_zip_codes C:\Users\sabya\gitrepos\oracle\examples\phoenix\all_us_zipcodes.csv
load all_us_states C:\Users\sabya\gitrepos\oracle\examples\phoenix\all_us_states.csv

set loadformat xlsx
load C:\Users\sabya\gitrepos\oracle\examples\phoenix\uscities.xlsx
--
alter table all_us_zip_codes drop column lon;
select * from all_us_zip_codes order by 1;
--
select city, state_id, state_name from phoenix.uscities;
--
select zip.code, usct.CITY, usct.COUNTY_NAME, usct.STATE_ID, usct.STATE_NAME
from phoenix.uscities usct
inner join all_us_zip_codes zip
on usct.state_id = zip.state and usct.city = zip.city
order by state_id, county_name;
--
-- 
select zip_codes.code zip_code,
       zip_codes.city city,
       zip_codes.state state_id,
       states.name state_name
  from all_us_zip_codes zip_codes
 inner join all_us_states states
on zip_codes.state = states.abbr
 order by state,
          city,
          code;
--
select * 
from oradev23.all_us_zip_codes zip
left outer join phoenix.uscities usct
on zip.state_id = usct.state_id
   and zip.city = usct.city
where usct.state_id is null and usct.city is null;
--

select * from phoenix.phnx_state_lookup;

select * from phoenix.uscities where city = 'Shelburne Falls';
select * from phoenix.phnx_city_lookup where city_name = 'Shelburne Falls';
--
select * from oradev23.all_us_states
--
select distinct state_id, state_name from phoenix.phnx_state_lookup where state_name = 'District of Columbia'
select distinct state_id, state_name from phoenix.uscities
--
with us_states_zip as (
select zip.code,
       'US' as country_id,
       usct.state_id,
       usct.state_name,
       zip.county,
       usct.city
  from phoenix.uscities usct
 inner join oradev23.all_us_zip_codes zip
on usct.state_id = zip.state
   and usct.city = zip.city
)
select zip.code,zip.state_id, zip.state_name, zip.city 
from us_states_zip zip 
left outer join phoenix.phnx_city_lookup cl
on cl.state_id = zip.state_id
   and cl.state_name = zip.state_name
   and cl.city_name = zip.city
where cl.state_id is null and cl.state_name is null and cl.city_name is null;
--
create table phoenix.all_us_states
as
select * from oradev23.all_us_states;
--
select * from phoenix.all_us_states;
--
select * from uscities;
--
select * from all_us_zip_codes;
--
select count(distinct state) from all_us_zip_codes;
--
select * from phoenix.phnx_state_lookup;
--
select * from phoenix.all_us_states;
--
select * from phoenix.phnx_state_lookup;
--
create table phoenix.all_us_zip_codes
as
select * from oradev23.all_us_zip_codes;
--
commit;
--
select * from phoenix.all_us_zip_codes
--
select zip.code, zip.state, zip.city, state.state_name
from phoenix.all_us_zip_codes zip
inner join phoenix.phnx_state_lookup state
on zip.state = state.state_id
where code = '37010'
--
select * from phoenix.all_us_zip_codes where code = '37010';
--
alter table phoenix.all_us_zip_codes
   add (country_id varchar2(2), region_id varchar2(4));
--
update phoenix.all_us_zip_codes
set country_id = 'US', region_id = 'NA'
where country_id is null;
commit;
--
insert into phoenix.all_us_zip_codes (code, city, state, county, country_id, region_id)
select '500015', 'Hyderabad', 'TG', NULL, 'IN', 'APAC'
union all
select '500016', 'Hyderabad', 'TG', NULL, 'IN', 'APAC'
union all
select '500080', 'Hyderabad', 'TG', NULL, 'IN', 'APAC'
union all 
select '500081', 'Hyderabad', 'TG', NULL, 'IN', 'APAC'
union all
select '700020', 'Kolkata', 'WB', NULL, 'IN', 'APAC'
union all
select '700046', 'Kolkata', 'WB', NULL, 'IN', 'APAC'
union all
select '700027', 'Kolkata', 'WB', NULL, 'IN', 'APAC'
union all 
select '700028',
       'Kolkata',
       'WB',
       null,
       'IN',
       'APAC'
union all
select '700073',
       'Kolkata',
       'WB',
       null,
       'IN',
       'APAC'       
union all
select '600018',
       'Chennai',
       'TN',
       null,
       'IN',
       'APAC'
union all
select '600020',
       'Chennai',
       'TN',
       null,
       'IN',
       'APAC' 
union all
select '600025',
       'Chennai',
       'TN',
       null,
       'IN',
       'APAC' 
union all
select '600001',
       'Chennai',
       'TN',
       null,
       'IN',
       'APAC'
union all
select '560034',
       'Bangalore',
       'KA',
       null,
       'IN',
       'APAC'       
union all
select '560092',
       'Bangalore',
       'KA',
       null,
       'IN',
       'APAC'       
union all
select '560050',
       'Bangalore',
       'KA',
       null,
       'IN',
       'APAC' 
union all
select '560079',
       'Bangalore',
       'KA',
       null,
       'IN',
       'APAC'        
union all
select '682001',
       'Kochi',
       'KL',
       null,
       'IN',
       'APAC'           
union all
select '695005',
       'Thiruvananthapuram',
       'KL',
       null,
       'IN',
       'APAC'    
--
commit;                                        
--
select * from phoenix.phnx_state_lookup;
--
with zip as (
   select  country_id,
           region_id,
          zip.state,
          zip.city,
          zip.code
     from phoenix.all_us_zip_codes zip
)
select zip.code,
       zip.country_id,
       zip.state,
       state.state_name,
       zip.city
  from zip
 inner join phoenix.phnx_state_lookup state
on zip.state = state.state_id
   and state.country_id = zip.country_id
   and state.region_id = zip.region_id
where zip.code = '37010';
--
select * from phoenix.phnx_cntry_state_city_zip_codes where state_name = 'Montana' order by city_name;
--
select *
  from phoenix.phnx_cntry_state_city_zip_codes
 where zip_code = '71601';
--
select *
  from phoenix.phnx_cntry_state_city_zip_codes where country_id = 'IN'; 