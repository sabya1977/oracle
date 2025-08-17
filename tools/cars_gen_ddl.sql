-- Table DDL: COUNTRIES

-- =====================================================================
-- Table: COUNTRIES
-- Description: Stores country information including continent and code.
-- Columns:
--   COUNTRYID    NUMBER(5,0)   - Primary key. Unique identifier for each country.
--   COUNTRYNAME  VARCHAR2(20)  - Name of the country.
--   CONTID       NUMBER(5,0)   - Foreign key. References CONTINENTS.CONTID.
--   COUNTRYCODE  VARCHAR2(2)   - 2-letter country code. Allowed values:
--                                IN (India), CN (China), US (USA), FR (France),
--                                UK (United Kingdom), GE (Germany), JP (Japan),
--                                IT (Italy), SW (Sweden), SK (South Korea),
--                                RU (Russia), NI (Nigeria), AU (Australia),
--                                NZ (New Zealand), EG (Egypt), MX (Mexico),
--                                BR (Brazil)
-- Constraints:
--   PK: COUNTRYID (COUNTRYCODE_PK)
--   FK: CONTID references CONTINENTS.CONTID (COUNTRIES_CONTID_FK)
--   CHK: COUNTRYCODE must be one of the allowed values (COUNTRYCODE_CHK)
-- =====================================================================
CREATE TABLE CARS.COUNTRIES 
(
	COUNTRYID NUMBER(5,0), 
	COUNTRYNAME VARCHAR2(20), 
	CONTID NUMBER(5,0), 
	COUNTRYCODE VARCHAR2(2), 
	CONSTRAINT COUNTRYCODE_CHK CHECK (CountryCode IN ('IN', 'CN', 'US', 'FR', 'UK', 'GE', 'JP', 'IT', 'SW', 'SK', 'RU', 'NI', 'AU', 'NZ', 'EG', 'MX', 'BR')) ENABLE, 
	CONSTRAINT COUNTRYCODE_PK PRIMARY KEY (COUNTRYID)
	USING INDEX ENABLE, 
	CONSTRAINT COUNTRIES_CONTID_FK FOREIGN KEY (CONTID)
	REFERENCES CARS.CONTINENTS (CONTID) ENABLE
);

-- Index DDL: COUNTRYCODE_PK
CREATE UNIQUE INDEX CARS.COUNTRYCODE_PK ON CARS.COUNTRIES (COUNTRYID);


-- Table DDL: CONTINENTS
-- =====================================================================
-- Table: CONTINENTS
-- Description: Stores continent information.
-- Columns:
--   CONTID      NUMBER(5,0)   - Primary key. Unique identifier for each continent.
--   CONTINENT   VARCHAR2(15)  - Name of the continent.
-- Constraints:
--   PK: CONTID (CONTINENTS_CONTID_PK)
-- =====================================================================
CREATE TABLE CARS.CONTINENTS 
(
	CONTID NUMBER(5,0), 
	CONTINENT VARCHAR2(15), 
	CONSTRAINT CONTINENTS_CONTID_PK PRIMARY KEY (CONTID)
	USING INDEX ENABLE
);

-- Index DDL: CONTINENTS_CONTID_PK
-- Description: Unique index to enforce primary key constraint on CONTID in CONTINENTS table.
CREATE UNIQUE INDEX CARS.CONTINENTS_CONTID_PK ON CARS.CONTINENTS (CONTID);


-- =====================================================================
-- Table: CAR_MAKERS
-- Description: Stores car manufacturer information.
-- Columns:
--   MAKERID    NUMBER(5,0)   - Primary key. Unique identifier for each car maker.
--   MAKERNAME  VARCHAR2(15)  - Short name of the car maker.
--   FULLNAME   VARCHAR2(25)  - Full name of the car maker.
--   COUNTRYID  NUMBER(5,0)   - Foreign key. References COUNTRIES.COUNTRYID.
-- Constraints:
--   PK: MAKERID (CARMAKERS_MAKERID_PK)
--   FK: COUNTRYID references COUNTRIES.COUNTRYID (CARMAKERS_COUNTRYID_FK)
-- =====================================================================
CREATE TABLE CARS.CAR_MAKERS 
(
	MAKERID NUMBER(5,0), 
	MAKERNAME VARCHAR2(15), 
	FULLNAME VARCHAR2(25), 
	COUNTRYID NUMBER(5,0), 
	CONSTRAINT CARMAKERS_MAKERID_PK PRIMARY KEY (MAKERID)
	USING INDEX ENABLE, 
	CONSTRAINT CARMAKERS_COUNTRYID_FK FOREIGN KEY (COUNTRYID)
	REFERENCES CARS.COUNTRIES (COUNTRYID) ENABLE
);

-- Index DDL: CARMAKERS_MAKERID_PK
-- Description: Unique index to enforce primary key constraint on MAKERID in CAR_MAKERS table.
CREATE UNIQUE INDEX CARS.CARMAKERS_MAKERID_PK ON CARS.CAR_MAKERS (MAKERID);


-- =====================================================================
-- Table: MODEL_DETAILS
-- Description: Stores car model details.
-- Columns:
--   MODELID         NUMBER(5,0)    - Primary key. Unique identifier for each model.
--   MAKERID         NUMBER(5,0)    - Foreign key. References CAR_MAKERS.MAKERID.
--   MODELSHORTDESC  VARCHAR2(45)   - Short description of the model.
--   MODELLONGDESC   VARCHAR2(100)  - Long description of the model.
-- Constraints:
--   PK: MODELID (MODELDETAILS_MODELID_PK)
--   FK: MAKERID references CAR_MAKERS.MAKERID (MODELDETAILS_FK)
-- =====================================================================
CREATE TABLE CARS.MODEL_DETAILS 
(
	MODELID NUMBER(5,0), 
	MAKERID NUMBER(5,0), 
	MODELSHORTDESC VARCHAR2(45), 
	MODELLONGDESC VARCHAR2(100), 
	CONSTRAINT MODELDETAILS_MODELID_PK PRIMARY KEY (MODELID)
	USING INDEX ENABLE, 
	CONSTRAINT MODELDETAILS_FK FOREIGN KEY (MAKERID)
	REFERENCES CARS.CAR_MAKERS (MAKERID) ENABLE
);

-- Index DDL: MODELDETAILS_MODELID_PK
-- Description: Unique index to enforce primary key constraint on MODELID in MODEL_DETAILS table.
CREATE UNIQUE INDEX CARS.MODELDETAILS_MODELID_PK ON CARS.MODEL_DETAILS (MODELID);


-- Table DDL: CAR_NAMES

-- =====================================================================
-- Table: CAR_NAMES
-- Description: Stores car names and their associations to models and makers.
-- Columns:
--   CARID     NUMBER(5,0)    - Primary key. Unique identifier for each car.
--   CARNAME   VARCHAR2(100)  - Name of the car.
--   MODELID   NUMBER(5,0)    - Foreign key. References MODEL_DETAILS.MODELID.
--   MAKERID   NUMBER(5,0)    - Foreign key. References CAR_MAKERS.MAKERID.
-- Constraints:
--   PK: CARID (CARNAMES_CARID_PK)
--   FK: MODELID references MODEL_DETAILS.MODELID (CARNAMES_MODELID_FK)
--   FK: MAKERID references CAR_MAKERS.MAKERID (CARNAMES_MAKERID_FK)
-- =====================================================================
CREATE TABLE CARS.CAR_NAMES 
(
	CARID NUMBER(5,0), 
	CARNAME VARCHAR2(100), 
	MODELID NUMBER(5,0), 
	MAKERID NUMBER(5,0), 
	CONSTRAINT CARNAMES_CARID_PK PRIMARY KEY (CARID)
	USING INDEX ENABLE, 
	CONSTRAINT CARNAMES_MODELID_FK FOREIGN KEY (MODELID)
	REFERENCES CARS.MODEL_DETAILS (MODELID) ENABLE, 
	CONSTRAINT CARNAMES_MAKERID_FK FOREIGN KEY (MAKERID)
	REFERENCES CARS.CAR_MAKERS (MAKERID) ENABLE
);

-- Index DDL: CARNAMES_CARID_PK
-- Description: Unique index to enforce primary key constraint on CARID in CAR_NAMES table.
CREATE UNIQUE INDEX CARS.CARNAMES_CARID_PK ON CARS.CAR_NAMES (CARID);


-- =====================================================================
-- Table: CAR_DETAILS
-- Description: Stores detailed specifications for each car.
-- Columns:
--   CARID      NUMBER(5,0)    - Primary key. Unique identifier for each car. FK to CAR_NAMES.CARID.
--   MPG        NUMBER(5,2)    - Miles per gallon (fuel efficiency).
--   CYLINDERS  NUMBER(5,0)    - Number of engine cylinders.
--   EDISPL     NUMBER(10,0)   - Engine displacement.
--   HORSEPOWER NUMBER(10,0)   - Engine horsepower.
--   WEIGHT     NUMBER(10,0)   - Weight of the car.
--   ACCEL      NUMBER(10,2)   - Acceleration (0-60 mph time).
--   YEAR       NUMBER(10,0)   - Model year.
-- Constraints:
--   PK: CARID (CARDETAILS_CARID_PK)
--   FK: CARID references CAR_NAMES.CARID (CARDETAILS_CARID_FK)
-- =====================================================================
CREATE TABLE CARS.CAR_DETAILS 
(
	CARID NUMBER(5,0), 
	MPG NUMBER(5,2), 
	CYLINDERS NUMBER(5,0), 
	EDISPL NUMBER(10,0), 
	HORSEPOWER NUMBER(10,0), 
	WEIGHT NUMBER(10,0), 
	ACCEL NUMBER(10,2), 
	YEAR NUMBER(10,0), 
	CONSTRAINT CARDETAILS_CARID_PK PRIMARY KEY (CARID)
	USING INDEX ENABLE, 
	CONSTRAINT CARDETAILS_CARID_FK FOREIGN KEY (CARID)
	REFERENCES CARS.CAR_NAMES (CARID) ENABLE
);

-- Index DDL: CARDETAILS_CARID_PK
-- Description: Unique index to enforce primary key constraint on CARID in CAR_DETAILS table.
CREATE UNIQUE INDEX CARS.CARDETAILS_CARID_PK ON CARS.CAR_DETAILS (CARID);
--
-- List all car names of Toyota
SELECT cn.CARNAME
FROM CARS.CAR_NAMES cn
JOIN CARS.CAR_MAKERS cm ON cn.MAKERID = cm.MAKERID
WHERE UPPER(cm.MAKERNAME) = 'TOYOTA';


