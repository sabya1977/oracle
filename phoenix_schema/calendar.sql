-- Insert data into the calendar table for a range of dates
-- This will create a calendar from 01/01/2010 to 01/01/2020
-- The calendar will include day, month, quarter, year, and holiday information
--
declare
   start_date date;
   end_date   date;
begin
   start_date := to_date ( '01/01/2010','DD/MM/YYYY' );
   end_date := start_date + 10950;
   while start_date <= end_date loop
      insert into calendar (
         calendar_date,
         calendar_day,
         calendar_month,
         calendar_quarter,
         calendar_year,
         day_of_week_num,
         day_of_week_name,
         date_num,
         quarter_cd,
         month_name_cd,
         full_month_name,
         holiday_name,
         holiday_flag
      ) values ( start_date,
                 to_char(
                    start_date,
                    'DD'
                 ),
                 to_char(
                    start_date,
                    'MM'
                 ),
                 to_char(
                    start_date,
                    'Q'
                 ),
                 to_char(
                    start_date,
                    'YYYY'
                 ),
                 case
                    when to_char(
                       start_date,
                       'D'
                    ) = '1' then
                       7
                    else
                       to_char(
                          start_date,
                          'D'
                       ) - 1
                 end,
                 to_char(
                    start_date,
                    'DY'
                 ),
                 to_char(
                    start_date,
                    'YYYYMMDD'
                 ),
                 to_char(
                    start_date,
                    'YYYY'
                 )
                 || 'Q'
                 || to_char(
                    start_date,
                    'Q'
                 ),
                 to_char(
                    start_date,
                    'MON'
                 ),
                 to_char(
                    start_date,
                    'MONTH'
                 ),
                 null,
                 0 );

      start_date := start_date + 1;
   end loop;
end;
/
--
commit;