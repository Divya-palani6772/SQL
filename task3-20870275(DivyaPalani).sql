-------------------------------Task 3-------------------------------

--creating ExcellentSale table

CREATE TABLE ExcellentSale(
SaleNumber NUMBER,
AgentName VARCHAR2(50),
CarModel VARCHAR2(20),
ManufacturerName VARCHAR2(20)
PRIMARY KEY(SaleNumber)
);

--creating sequence

CREATE SEQUENCE trigger_sequence START WITH 1 INCREMENT BY 1;

--creating trigger

CREATE OR REPLACE TRIGGER InsertExcellentSale
AFTER INSERT ON SalesTransaction
FOR EACH ROW

DECLARE
    v_askingPrice Car.askingPrice%type;
    v_agentName SalesAgent.Name%type;
    v_modelName Model.Name%type;
    v_manufacturerName Manufacturer.Name%type;

BEGIN

    SELECT askingPrice 
    INTO v_askingPrice
    FROM Car 
    WHERE VIN = :new.VIN;

    SELECT Name
    INTO v_agentName
    FROM SalesAgent 
    WHERE agentID = :new.agentID;

    SELECT Name
    INTO v_modelName
    FROM Model m, Car c
    WHERE c.ModelNo = m.ModelNo
    AND c.VIN = :new.VIN;

    SELECT m.Name 
    INTO v_manufacturerName
    FROM Manufacturer m, Model mo, Car c
    WHERE c.ModelNo = mo.ModelNo
    AND mo.manufacturerID = m.manufacturerID
    AND c.VIN = :new.VIN;
    
    IF :new.agreedPrice > v_askingPrice THEN
       INSERT INTO ExcellentSale
       VALUES(trigger_sequence.NEXTVAL, v_agentName, v_modelName, v_manufacturerName);
    END IF;

END InsertExcellentSale;
/

--to execute

INSERT INTO SalesTransaction Values('1GCEC19T11Z986314', '1', '3', '10-Mar-2020', '106500');

SELECT * FROM ExcellentSale;