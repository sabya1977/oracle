create or replace function myslowfunction( p_in in number )
return number
result_cache
is
begin
  dbms_session.sleep( 1 );
  return p_in;
end;
/
