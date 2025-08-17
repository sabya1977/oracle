-- ============================================
-- TABLE: CARS.CONTINENTS
-- PURPOSE: Stores information about continents
-- ============================================
 
-- COLUMN: CONTID        NUMBER(5)
-- - Unique identifier for each continent
-- - PRIMARY KEY
 
-- COLUMN: CONTINENT      VARCHAR2(15)
-- - Full name of the continents (e.g., 'AMERICA', 'EUROPE', 'ASIA', 'AUSTRALIA', 'AFRICA')

-- ============================================
-- INDEXES
-- ============================================

-- INDEX: CARS.CONTINENTS_CONTID_PK
-- - UNIQUE index created on CONTID (primary key)
-- - CREATE UNIQUE INDEX CARS.CONTINENTS_CONTID_PK ON CARS.CONTINENTS (CONTID)

-- ============================================
-- NOTES
-- ============================================
-- CARS.CONTINENTS is the parent table for continents 

-- ============================================
-- TABLE: CARS.COUNTRIES
-- PURPOSE: Stores information about countries and their continent
-- ============================================

-- COLUMN: COUNTRYID        NUMBER(5)
-- - Unique identifier for each country
-- - PRIMARY KEY

-- COLUMN: COUNTRYNAME      VARCHAR2(20)
-- - Full name of the country (e.g., 'India', 'China', 'USA')

-- COLUMN: CONTID        NUMBER(5)
-- - Foreign key referencing CONTINENTS.CONTID
-- - Represents the continent the country belongs to

-- COLUMN: COUNTRYCODE     VARCHAR2(2)
-- - 2-letter ISO-like country code
-- - ALLOWED VALUES (CHECK constraint):
--     'IN' = India
--     'CN' = China
--     'US' = United States
--     'FR' = France
--     'UK' = United Kingdom
--     'GE' = Germany
--     'JP' = Japan
--     'IT' = Italy
--     'SW' = Sweden
--     'SK' = South Korea
--     'RU' = Russia
--     'NI' = Nigeria
--     'AU' = Australia
--     'NZ' = New Zealand
--     'EG' = Egypt
--     'MX' = Mexico
--     'BR' = Brazil

-- ============================================
-- CONSTRAINTS
-- ============================================

-- CONSTRAINT: COUNTRYCODE_PK
-- - PRIMARY KEY on COUNTRYID

-- CONSTRAINT: COUNTRYCODE_CHK
-- - CHECK constraint to allow only predefined COUNTRY_CODE values

-- CONSTRAINT: COUNTRIES_CONTID_FK
-- - FOREIGN KEY (CONTINENTS) REFERENCES CARS.CONTINENTS(CONTID)

-- ============================================
-- INDEXES
-- ============================================

-- INDEX: COUNTRYCODE_PK
-- - UNIQUE index created on COUNTRYID (primary key)
-- - CREATE UNIQUE INDEX CARS.COUNTRYCODE_PK ON CARS.COUNTRIES (COUNTRYID);

-- ============================================
-- NOTES
-- ============================================
-- COUNTRYCODE is validated against a fixed set of values using a CHECK constraint
-- CONTID must exist in the CARS.CONTINENTS table
-- CARS.CCOUNTRIES is the child table for CARS.CONTINENTS

-- ============================================
-- TABLE: CARS.CAR_MAKERS
-- PURPOSE: Stores automobile manufacturers and their country of origin
-- ============================================

-- COLUMN: MAKERID             NUMBER(5)
-- - Unique identifier for the car maker
-- - PRIMARY KEY

-- COLUMN: MAKERNAME          VARCHAR2(15)
-- - Short brand name (e.g., 'Toyota', 'Ford', 'BMW')

-- COLUMN: FULLNAME       VARCHAR2(25)
-- - Full legal or display name of the car maker
-- - Examples: 'Toyota Motor Corporation', 'Bayerische Motoren Werke AG'

-- COLUMN: COUNTRYID        NUMBER(5)
-- - Foreign key referencing CARS.COUNTRIES.COUNTRYID
-- - Indicates the country where the car maker is based

-- ============================================
-- CONSTRAINTS
-- ============================================

-- CONSTRAINT: CARMAKERS_MAKERID_PK
-- - PRIMARY KEY on MAKERID

-- CONSTRAINT: CARMAKERS_COUNTRYID_FK
-- - FOREIGN KEY (COUNTRYID) REFERENCES CARS.COUNTRIES(COUNTRYID)

-- ============================================
-- INDEXES
-- ============================================

-- INDEX: CARS.CARMAKERS_MAKERID_PK
-- - UNIQUE index on MAKERID (primary key)
-- - CREATE UNIQUE INDEX CARS.CARMAKERS_MAKERID_PK ON CARS.CAR_MAKERS (MAKERID);

-- ============================================
-- NOTES
-- ============================================
-- This table links to COUNTRIES using COUNTRYID → COUNTRYID
-- Use JOINs with COUNTRIES to retrieve maker origin details
-- Common use cases: filter car makers by country, group by maker, join with sales, etc.

-- ============================================
-- TABLE: CARS.MODEL_DETAILS
-- PURPOSE: Stores details of individual car models and their associated makers
-- ============================================

-- COLUMN: MODELID        NUMBER(5)
-- - Unique identifier for each car model
-- - PRIMARY KEY

-- COLUMN: MAKERID          NUMBER(5)
-- - Foreign key referencing CAR_MAKERS.MAKERID
-- - Indicates which manufacturer produced this model

-- COLUMN: MODELSHORTDESC          VARCHAR2(25)
-- - Name of the car model (e.g., 'Corolla', 'Mustang', 'Civic')

-- COLUMN: MODELLONGDESC           VARCHAR2(100)
-- - Longer description of the car model, can include trim levels or special editions

-- ============================================
-- CONSTRAINTS
-- ============================================

-- CONSTRAINT: MODELDETAILS_MODELID_PK
-- - PRIMARY KEY on MODELID

-- CONSTRAINT: MODELDETAILS_FK
-- - FOREIGN KEY (MAKERID) REFERENCES CARS.CAR_MAKERS(MAKERID)

-- ============================================
-- INDEXES
-- ============================================

-- INDEX: CARS.MODELDETAILS_MODELID_PK
-- - UNIQUE index on MODELID (primary key)
-- - CREATE UNIQUE INDEX CARS.MODELDETAILS_MODELID_PK ON CARS.MODEL_DETAILS (MODELID);

-- ============================================
-- NOTES
-- ============================================
-- This table defines a list of distinct car models
-- Links to CAR_MAKERS to associate each model with a specific brand
-- JOIN this table with CAR_MAKERS and COUNTRIES for reporting by region, brand, or model

-- ============================================
-- TABLE: CARS.CAR_NAMES
-- PURPOSE: Stores descriptive or alternate names for car models
-- ============================================

-- COLUMN: CARID NUMBER(5)
-- - Unique identifier for each car name record
-- - PRIMARY KEY

-- COLUMN: CARNAME VARCHAR2(100)
-- - Name of the car as it appears in marketing or sales materials  
-- - Examples: 'Toyota Corolla Altis', 'Mustang GT Fastback'

-- COLUMN: MODELID NUMBER(5,0)
-- - Foreign key referencing CARS.MODEL_DETAILS.MODELID
-- - Associates this record with a specific car model

-- COLUMN: MAKERID  NUMBER(5,0)
-- - Foreign key referencing CARS.CAR_MAKERS.MAKERID


-- ============================================
-- CONSTRAINTS
-- ============================================

-- CONSTRAINT: CARNAMES_CARID_PK
-- - PRIMARY KEY on CARID

-- CONSTRAINT: CARNAMES_MODELID_FK
-- - FOREIGN KEY (MODELID) REFERENCES CARS.MODEL_DETAILS(MODELID)

-- CONSTRAINT: CARNAMES_MAKERID_FK
-- - FOREIGN KEY (MAKERID) REFERENCES CARS.CAR_MAKERS(MAKERID)

-- ============================================
-- INDEXES
-- ============================================

-- INDEX: CARS.CARNAMES_CARID_PK
-- - UNIQUE index on CARID (primary key)
-- - CREATE UNIQUE INDEX CARS.CARNAMES_CARID_PK ON CARS.CAR_NAMES (CARID);

-- ============================================
-- NOTES
-- ============================================
-- This table allows storing marketing or display names for car models
-- Use joins with MODEL_DETAILS → CAR_MAKERS → COUNTRIES → CONTINENTS for full model lineage for each car
-- MODELID must match an existing model name from MODEL_DETAILS (MODELID
-- MAKERID must match an existing car maker from CAR_MAKERS (MAKERID)

-- ============================================
-- TABLE: CARS.CAR_DETAILS
-- PURPOSE: Stores performance and technical specifications for cars
-- ============================================

-- COLUMN: CARID            NUMBER(5)
-- - Unique identifier linking to a car in CAR_NAMES
-- - PRIMARY KEY and FOREIGN KEY

-- COLUMN: MPG           NUMBER(5,2)
-- - Miles per gallon (fuel efficiency)

-- COLUMN: CYLINDERS     NUMBER(5)
-- - Number of engine cylinders (e.g., 4, 6, 8)

-- COLUMN: EDISPL        NUMBER(10)
-- - Engine displacement (typically in cubic centimeters or cc)

-- COLUMN: HORSEPOWER    NUMBER(10)
-- - Engine power output

-- COLUMN: WEIGHT        NUMBER(10)
-- - Weight of the car in pounds (lbs)

-- COLUMN: ACCEL         NUMBER(10,2)
-- - Time (in seconds) to accelerate from 0 to 60 mph

-- COLUMN: YEAR          NUMBER(10)
-- - Model year of the car (e.g., 2020, 2021)

-- ============================================
-- CONSTRAINTS
-- ============================================

-- CONSTRAINT: CARDETAILS_CARID_PK
-- - PRIMARY KEY on CARID

-- CONSTRAINT: CARDETAILS_CARID_FK
-- - FOREIGN KEY (CARID) REFERENCES CARS.CAR_NAMES(CARID)

-- ============================================
-- INDEXES
-- ============================================

-- INDEX: CARS.CARDETAILS_CARID_PK
-- - UNIQUE index on ID (primary key)
-- - CREATE UNIQUE INDEX CARS.CARDETAILS_CARID_PK ON CARS.CAR_DETAILS (CARID);

-- ============================================
-- NOTES
-- ============================================
-- This table contains the numerical specs of each car, joined by ID from CAR_NAMES
-- Use in reporting on performance metrics, comparisons, filtering by year, etc.
-- You can join CAR_DETAILS → CAR_NAMES → MODEL_DETAILS → CAR_MAKERS → COUNTRIES
-- Common queries include filtering cars by horsepower, weight, or MPG thresholds
SELECT
    cd.CARID,
    cn.CARNAME,
    md.MODELSHORTDESC,
    md.MODELLONGDESC,
    cd.MPG,
    cd.CYLINDERS,
    cd.EDISPL,
    cd.HORSEPOWER,
    cd.WEIGHT,
    cd.ACCEL,
    cd.YEAR
FROM
    CARS.CAR_DETAILS cd
    JOIN CARS.CAR_NAMES cn ON cd.CARID = cn.CARID
    JOIN CARS.MODEL_DETAILS md ON cn.MODELID = md.MODELID
    JOIN CARS.CAR_MAKERS cm ON md.MAKERID = cm.MAKERID
WHERE
    UPPER(cm.MAKERNAME) = 'FORD';
--
SELECT
    cn.CARNAME
FROM
    CARS.CAR_NAMES cn
    JOIN CARS.MODEL_DETAILS md ON cn.MODELID = md.MODELID
    JOIN CARS.CAR_MAKERS cm ON md.MAKERID = cm.MAKERID
    JOIN CARS.COUNTRIES ctry ON cm.COUNTRYID = ctry.COUNTRYID
    JOIN CARS.CONTINENTS cont ON ctry.CONTID = cont.CONTID
WHERE
    UPPER(cont.CONTINENT) = 'ASIA';
