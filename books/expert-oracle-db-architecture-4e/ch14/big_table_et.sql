-- Note: big_table.dat needs to exist in the /tmp directory.

DROP TABLE big_table_et;

CREATE TABLE BIG_TABLE_ET
(
  "ID" NUMBER,
  "OWNER" VARCHAR2(128),
  "OBJECT_NAME" VARCHAR2(128),
  "SUBOBJECT_NAME" VARCHAR2(128),
  "OBJECT_ID" NUMBER,
  "DATA_OBJECT_ID" NUMBER,
  "OBJECT_TYPE" VARCHAR2(23)
)
ORGANIZATION external 
(
  TYPE oracle_loader
  DEFAULT DIRECTORY my_dir 
  ACCESS PARAMETERS 
  (
    RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
    READSIZE 1048576
    FIELDS TERMINATED BY "|" LDRTRIM 
    REJECT ROWS WITH ALL NULL FIELDS 
    (
      "ID" CHAR(255)
        TERMINATED BY "|",
      "OWNER" CHAR(255)
        TERMINATED BY "|",
      "OBJECT_NAME" CHAR(255)
        TERMINATED BY "|",
      "SUBOBJECT_NAME" CHAR(255)
        TERMINATED BY "|",
      "OBJECT_ID" CHAR(255)
        TERMINATED BY "|",
      "DATA_OBJECT_ID" CHAR(255)
        TERMINATED BY "|",
      "OBJECT_TYPE" CHAR(255)
        TERMINATED BY "|"
    )
  )
  location 
  (
    'big_table.dat'
  )
)REJECT LIMIT UNLIMITED parallel;