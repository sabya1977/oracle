-- xml_processing.sql
-- 
-- The sample code to read a XML file (stored in an external dir) 
-- and load into a table.
-- 
-- As SYS
CREATE OR REPLACE DIRECTORY xml_dir AS '/tmp';
GRANT READ ON DIRECTORY xml_dir TO oradev21;
-- As schema owner
CREATE TABLE emp_xml (
  empno     NUMBER(4),
  ename     VARCHAR2(10),
  job       VARCHAR2(9),
  mgr       NUMBER(4),
  hiredate  DATE,
  sal       NUMBER(7, 2),
  comm      NUMBER(7, 2),
  deptno    NUMBER(2)
);
-- 
-- 
DECLARE
  l_bfile   BFILE;
  l_clob    CLOB;
  l_parser  DBMS_XMLPARSER.parser;
  l_doc     DBMS_XMLDOM.domdocument;
  l_nl      DBMS_XMLDOM.domnodelist;
  l_n       DBMS_XMLDOM.domnode;
  l_temp    VARCHAR2(1000);

  l_dest_offset   INTEGER := 1;
  l_src_offset    INTEGER := 1;
  l_bfile_csid    NUMBER  := 0;
  l_lang_context  INTEGER := 0;
  l_warning       INTEGER := 0;

  TYPE tab_type IS TABLE OF emp%ROWTYPE;
  t_tab  tab_type := tab_type();
BEGIN

  l_bfile := BFILENAME('XML_DIR', 'emp.xml');

-- This procedure creates a temporary BLOB or CLOB and its 
-- corresponding index in your default temporary tablespace.
  DBMS_LOB.createtemporary(l_clob, cache=>FALSE);

-- Open the LOB in readonly mode
  DBMS_LOB.open(l_bfile, dbms_lob.lob_readonly);
  
-- DBMS_LOB.LOADCLOBFROMFILE Procedure loads data from a BFILE to an internal 
-- CLOB/NCLOB with necessary character set conversion and returns the
-- new offsets.
-- 
-- Load xml file from XML_DIR into l_clob
-- 
  DBMS_LOB.loadclobfromfile (
    dest_lob      => l_clob,
    src_bfile     => l_bfile,
    amount        => DBMS_LOB.lobmaxsize,
    dest_offset   => l_dest_offset,
    src_offset    => l_src_offset,
    bfile_csid    => l_bfile_csid ,
    lang_context  => l_lang_context,
    warning       => l_warning);

  DBMS_LOB.close(l_bfile);
  
  -- make sure implicit date conversions are performed correctly
  DBMS_SESSION.set_nls('NLS_DATE_FORMAT','''DD-MON-YYYY''');
--   
-- First the XML document must be parsed and a DOMDocument created from it. 
-- Once the DOMDocument is created the parser is no longer needed so it's 
-- resources can be freed.
-- 
  -- Create a parser.
  l_parser := DBMS_XMLPARSER.newparser;

-- Parse the document and create a new DOM document and store it in CLOB variable
  DBMS_XMLPARSER.parseclob(l_parser, l_clob);
-- Get the document from CLOB variable to a XML DOMdocument
  l_doc := DBMS_XMLPARSER.getdocument(l_parser);

-- Free resources associated with the CLOB 
-- and Parsernow they are no longer needed.
  DBMS_LOB.freetemporary(l_clob);
  DBMS_XMLPARSER.freeparser(l_parser);

-- Get a list of all the EMP nodes in the document using the XPATH syntax.
  l_nl := DBMS_XSLPROCESSOR.selectnodes(dbms_xmldom.makeNode(l_doc),'/EMPLOYEES/EMP');

-- Loop through the list and create a new record in a tble collection
-- for each EMP record.
  FOR cur_emp IN 0 .. dbms_xmldom.getLength(l_nl) - 1 LOOP
    l_n := DBMS_XMLDOM.item(l_nl, cur_emp);

    t_tab.extend;

-- Use XPATH syntax to assign values to he elements of the collection.
    DBMS_XSLPROCESSOR.valueof(l_n,'EMPNO/text()',t_tab(t_tab.last).empno);
    DBMS_XSLPROCESSOR.valueof(l_n,'ENAME/text()',t_tab(t_tab.last).ename);
    DBMS_XSLPROCESSOR.valueof(l_n,'JOB/text()',t_tab(t_tab.last).job);
    DBMS_XSLPROCESSOR.valueof(l_n,'MGR/text()',t_tab(t_tab.last).mgr);
    DBMS_XSLPROCESSOR.valueof(l_n,'HIREDATE/text()',t_tab(t_tab.last).hiredate);
    DBMS_XSLPROCESSOR.valueof(l_n,'SAL/text()',t_tab(t_tab.last).sal);
    DBMS_XSLPROCESSOR.valueof(l_n,'COMM/text()',t_tab(t_tab.last).comm);
    DBMS_XSLPROCESSOR.valueof(l_n,'DEPTNO/text()',t_tab(t_tab.last).deptno);
  END LOOP;

-- Insert data into the real EMP table from the table collection.
  FORALL i IN t_tab.first .. t_tab.last
    INSERT INTO emp_xml VALUES t_tab(i);

  COMMIT; 

-- Free any resources associated with the document now it
-- is no longer needed.
  DBMS_XMLDOM.freedocument(l_doc);

EXCEPTION
  WHEN OTHERS THEN
    DBMS_LOB.freetemporary(l_clob);
    DBMS_XMLPARSER.freeparser(l_parser);
    DBMS_XMLDOM.freedocument(l_doc);
    RAISE;
END;
/
