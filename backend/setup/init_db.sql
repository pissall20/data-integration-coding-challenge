CREATE SCHEMA IF NOT EXISTS app;

CREATE TABLE IF NOT EXISTS app.customers
(
    customer_id               BIGSERIAL PRIMARY KEY,
    name                      VARCHAR          NOT NULL,
    city                      VARCHAR          NOT NULL,
    street_hn                 VARCHAR          NOT NULL,
    annual_energy_consumption DOUBLE PRECISION NOT NULL,
    peak_power                DOUBLE PRECISION NOT NULL,
    accounting_year           INTEGER          NOT NULL,
    total_cost                DOUBLE PRECISION,
    CONSTRAINT aec_positive CHECK (annual_energy_consumption >= 0),
    CONSTRAINT p_max_positive CHECK (peak_power >= 0)
);

COMMENT ON COLUMN app.customers.name IS 'Full name of the customer';
COMMENT ON COLUMN app.customers.city IS 'Origin city where the customer is located';
COMMENT ON COLUMN app.customers.street_hn IS 'Street and House number where the customer is located';
COMMENT ON COLUMN app.customers.annual_energy_consumption IS 'Short: aec. Total energy consumption per year in (kWh)';
COMMENT ON COLUMN app.customers.peak_power IS 'Maximum Power that the customer can consume in (kW)';
COMMENT ON COLUMN app.customers.accounting_year IS 'Year in which the energy was consumed';
COMMENT ON COLUMN app.customers.total_cost IS 'Total cost (in €) for energy and power consumption';


CREATE TABLE IF NOT EXISTS app.electricity_cost
(
    city         VARCHAR NOT NULL,
    year         INTEGER NOT NULL,
    cent_per_kwh DOUBLE PRECISION NOT NULL,
    cent_per_kw  DOUBLE PRECISION NOT NULL
);

COMMENT ON COLUMN app.electricity_cost.city IS 'Name of the city with respective energy costs';
COMMENT ON COLUMN app.electricity_cost.year IS 'Year of the respective energy costs';
COMMENT ON COLUMN app.electricity_cost.cent_per_kwh IS 'Cost per euro cent/kWh energy for the respective city';
COMMENT ON COLUMN app.electricity_cost.cent_per_kw IS 'Cost per euro cent/kW power for the respective city';

INSERT INTO app.electricity_cost (city, year, cent_per_kwh, cent_per_kw)
VALUES ('Bonn', 2020, 31.4, 100),
       ('Bonn', 2021, 32.2, 100),
       ('Düsseldorf', 2021, 32.7, 100),
       ('Heidelberg', 2021, 32.4, 100),
       ('Köln', 2019, 29.6, 100),
       ('Köln', 2020, 31.1, 100),
       ('Köln', 2021, 32.5, 100),
       ('Köln', 2022, 42.0, 100),
       ('München', 2020, 33.1, 100),
       ('München', 2021, 33.8, 100),
       ('Wolfsburg', 2019, 30.1, 100),
       ('Wolfsburg', 2020, 31.2, 100),
       ('Wolfsburg', 2021, 32.2, 100);


CREATE SCHEMA IF NOT EXISTS backup;
CREATE TABLE IF NOT EXISTS backup.source_data (
    name VARCHAR,
    street_hn VARCHAR,
    city VARCHAR,
    annual_energy_consumption DOUBLE PRECISION,
    aec_unit VARCHAR,
    peak_power VARCHAR,
    accounting_year INTEGER
);

INSERT INTO backup.source_data (name, street_hn, city, annual_energy_consumption, aec_unit, peak_power, accounting_year)
VALUES ('envelio','Hildegard-von-bingen-allee 2','Köln',23000,'kWh','30 kW',2021),
       ('telekom','Landgrabenweg 151','Bonn',NULL,NULL,'40 kW',2021),
       ('früh','Am Hof 12-18','Köln',NULL,NULL,NULL,NULL),
       ('e.on','Arnulfstraße 203','München',NULL,NULL,NULL,NULL),
       ('deiters','Dr.-Gottfried-Cremer-Allee 19','Frechen',8000,'kWh',NULL,2021),
       ('vw','Berliner Ring 2','Wolfsburg',1900000,'MWh','500 MW',2019),
       ('envelio','Hildegard-von-bingen-allee 2','Köln',25000,'kWh','30 kW',2022),
       ('Allianz Arena','Werner-Heisenberg-Allee 25','München',19000,'MWh','5000 kW',2020),
       ('düsseldorf airport','Flughafenstraße 105','Düsseldorf',88000,'MWh','10 MW',2021),
       ('Heidelberg-Cement','Berliner Straße 6','Heidelberg',900000,'MWh','100 MW',2021);
