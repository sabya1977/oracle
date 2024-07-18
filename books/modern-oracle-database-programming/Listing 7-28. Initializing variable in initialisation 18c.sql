declare
  type circuit_t is record
  ( circuitid  number(11) 
  , circuitref varchar2(255)
  , name       varchar2(255)
  , location   varchar2(255)
  , country    varchar2(255)
  , lat        float
  , lng        float
  , alt        number(11)
  , url        varchar2(255));
  l_circuit circuit_t;
begin
  l_circuit := circuit_t
    ( circuitid  => 2912
    , circuitref => 'tt_circuit'
    , name       => 'TT Circuit Assen'
    , location   => 'Assen'
    , country    => 'Netherlands'
    , lat        => 52.961667
    , lng        => 6.523333
    , url        => 'https://en.wikipedia.org/wiki/TT_Circuit_Assen'
    );
  dbms_output.put_line( 'Name     : ' || l_circuit.name );
  dbms_output.put_line( 'Location : ' || l_circuit.location );
  dbms_output.put_line( 'Latitude : ' || l_circuit.lat );
  dbms_output.put_line( 'Lngitude : ' || l_circuit.lng );
  dbms_output.put_line( 'Altitude : ' || l_circuit.alt );
end;
/
