--Creating table and inserting values for MANUFACTURER relation

CREATE TABLE Manufacturer
(manufacturerID VARCHAR2(6) NOT NULL,
manufacturerRegion VARCHAR2(30),
manufacturerName VARCHAR2(20),
PRIMARY KEY(manufacturerID));

-------

INSERT INTO Manufacturer
(manufacturerID, manufacturerRegion, manufacturerName)
VALUES
('M00001', 'Chennai', 'Maruthi Suzuki');

INSERT INTO Manufacturer
(manufacturerID, manufacturerRegion, manufacturerName)
VALUES
('M00002', 'Mumbai', 'Hyundai');



--Creating table and inserting values for MODEL relation

CREATE TABLE Model
(modelNO VARCHAR2(6) NOT NULL,
modelName VARCHAR2(20),
modelType VARCHAR2(30),
manufacturerID VARCHAR2(6),
previousModelNO VARCHAR2(6),
PRIMARY KEY (modelNO),
FOREIGN KEY (manufacturerID) REFERENCES Manufacturer(manufacturerID));

-------

INSERT INTO Model
(modelNO, modelName, modelType, manufacturerID)
VALUES 
('T00001', 'Maruti Wagon', 'SEDAN', 'M00001');

INSERT INTO Model
(modelNO, modelName, modelType, manufacturerID)
VALUES 
('T00002', 'Maruti Swift Dzire', 'SEDAN', 'M00001');

UPDATE Model
SET previousModelNO = 'T00001'
WHERE modelNO = 'T00002';



--Creating table and inserting values for FEATURES relation

CREATE TABLE Features 
(featureID VARCHAR2(6) NOT NULL,
description VARCHAR2(50),
category VARCHAR2(30),
PRIMARY KEY (featureID));

-------

INSERT INTO Features
(featureID, description, category)
VALUES 
('F00001', 'petrol fuel', 'fuel' );

INSERT INTO Features
(featureID, description, category)
VALUES 
('F00002', '4 cyl. engine', 'Engine Type' );



--Creating table and inserting values for Car relation

CREATE TABLE Car
(VIN CHAR(17) NOT NULL CHECK (LENGTH(VIN)=17),
yearBuilt NUMBER(4),
askingPrice NUMBER(15,2),
purchasedPrice NUMBER(15,2),
dateAcquired DATE, 
color VARCHAR2(20),
currentMilage VARCHAR(20),
modelNO VARCHAR(6),
PRIMARY KEY (VIN),
FOREIGN KEY (modelNO) REFERENCES Model(modelNO));

-------

INSERT INTO Car
(VIN, yearBuilt, askingPrice, purchasedPrice, dateAcquired, color, 
	currentMilage, modelNO)
VALUES
('4Y1SL65848Z411439', 2015, 800000, 780000, TO_DATE('2015/07/09', 'yyyy/mm/dd'),'white','11km/l','T00002');

INSERT INTO Car
VALUES
('5YJSA1DG9DFP14705', 2009, 2300000, 2300000, TO_DATE('2020/01/02','yyyy/mm/dd'),'Black','13km/l','T00001');



--Creating table and inserting values for ViewingParty relation

CREATE TABLE ViewingParty
(viewingPartyID VARCHAR2(10) NOT NULL,
contactNO VARCHAR2(15) NOT NULL,
ViewingPartyEmail VARCHAR2(60),
PRIMARY KEY(viewingPartyID));

-------

INSERT INTO ViewingParty
VALUES
('VP01','+91 9940573782','allenshah@gmail.com');

INSERT INTO ViewingParty
VALUES
('VP02','+91 9988776655','technocolab@gmail.com');



--Creating table and inserting values for customer relation

CREATE TABLE Customer
(customerID VARCHAR2(10) NOT NULL,
customerName VARCHAR2(50) NOT NULL,
customerGender char(1) CHECK (customerGender='M' OR customerGender='F'),
customerDOB DATE,
customerPhone VARCHAR2(15) NOT NULL,
customerEmail VARCHAR2(60),
customerStreetAddress VARCHAR(70),
customerPostcode NUMBER(6) CHECK (LENGTH(customerPostcode)=6),
customerSuburb VARCHAR2(30),
customerType VARCHAR2(10) CHECK (customerType='VIP' OR customerType='NORMAL'),
PRIMARY KEY(customerID));

-------

INSERT INTO Customer
VALUES
('C01','Aashish','M',TO_DATE('10/06/1972','dd/mm/yyyy'),'+91 8754407920','aashishtk@gmail.com','West Tambaram:Kancheepuram','600045','Chennai','VIP');

INSERT INTO Customer
VALUES
('C02','Gowtham Ram','M',TO_DATE('29/09/1994','dd/mm/yyyy'),'+91 9876543210','nanfeyon@gmail.com','GST Road:Anna Nagar','600024','Chennai','NORMAL');



--Creating table and inserting values for SalesAgent relation

CREATE TABLE SalesAgent
(agentID VARCHAR2(10) NOT NULL,
agentDOB DATE,
agentName VARCHAR2(50) NOT NULL,
PRIMARY KEY(agentID));

-------

INSERT INTO SalesAgent
VALUES
('SA001',TO_DATE('28-04-1986','dd-mm-yyyy'),'James Mark');

INSERT INTO SalesAgent
VALUES
('SA002',TO_DATE('05-04-1984','mm-dd--yyyy'),'Mikkel Nielson');



--Creating table and inserting values for CarFeatures

CREATE TABLE CarFeatures
(VIN CHAR(17) NOT NULL CHECK (LENGTH(VIN)=17),
featureID VARCHAR2(6) NOT NULL,
PRIMARY KEY(VIN,featureID),
FOREIGN KEY(VIN) REFERENCES Car(VIN),
FOREIGN KEY(featureID) REFERENCES Features(featureID));

-------

INSERT INTO CarFeatures
VALUES
('4Y1SL65848Z411439','F00002');

INSERT INTO CarFeatures
VALUES
('4Y1SL65848Z411439','F00001');



--Creating table and inserting values for CarDisplay relation

CREATE TABLE CarDisplay
(VIN CHAR(17) NOT NULL CHECK (LENGTH(VIN)=17),
viewingPartyID VARCHAR2(10) NOT NULL,
dateViewed DATE NOT NULL,
amountPaid NUMBER(15.00),
PRIMARY KEY(VIN,viewingPartyID,dateViewed),
FOREIGN KEY(VIN) REFERENCES Car(VIN),
FOREIGN KEY(viewingPartyID) REFERENCES ViewingParty(viewingPartyID));

-------

INSERT INTO CarDisplay
VALUES
('5YJSA1DG9DFP14705','VP02',TO_DATE('2019/12/21','yyyy/mm/dd'),'5000.00');



--Creating table and inserting values for SelectedFeatures relation

CREATE TABLE SelectedFeatures
(customerID VARCHAR2(10) NOT NULL,
featureID VARCHAR2(6) NOT NULL,
PRIMARY KEY(customerID,featureID),
FOREIGN KEY (customerID) REFERENCES Customer(customerID),
FOREIGN KEY (featureID) REFERENCES Features(featureID));

-------

INSERT INTO SelectedFeatures
VALUES
('C01','F00001');

INSERT INTO SelectedFeatures
VALUES
('C02','F00001');



--Creating table and inserting values for Sale relation

CREATE TABLE Sale
(VIN CHAR(17) NOT NULL CHECK (LENGTH(VIN)=17),
customerID VARCHAR2(10) NOT NULL,
agentID VARCHAR2(10) NOT NULL,
dateOfSale DATE NOT NULL,
agreedPrice NUMBER(15,2),
PRIMARY KEY(VIN,customerID,agentID,dateOfSale),
FOREIGN KEY(VIN) REFERENCES Car(VIN),
FOREIGN KEY(customerID) REFERENCES Customer(customerID),
FOREIGN KEY(agentID) REFERENCES SalesAgent(agentID));

-------

INSERT INTO Sale
VALUES
('5YJSA1DG9DFP14705','C02','SA001',TO_DATE('2020/01/02','yyyy/mm/dd'),2300000);



--Creating table and inserting values for Organisation relation

CREATE TABLE Organisation
(viewingPartyID VARCHAR2(10) NOT NULL,
orgName VARCHAR2(30) NOT NULL,
PRIMARY KEY(viewingPartyID),
FOREIGN KEY(viewingPartyID) REFERENCES ViewingParty(viewingPartyID));

INSERT INTO Organisation
VALUES 
('VP01','MkBuilders');



--Creating table and inserting values for InternationalGuest relation

CREATE TABLE InternationalGuest
(viewingPartyID VARCHAR2(10) NOT NULL,
country VARCHAR2(30) NOT NULL,
PRIMARY KEY(viewingPartyID),
FOREIGN KEY(viewingPartyID) REFERENCES ViewingParty(viewingPartyID));

-------

INSERT INTO InternationalGuest
VALUES
('VP02','India');



--Creating and inserting values for SeniorAgent relation

CREATE TABLE SeniorAgent
(agentID VARCHAR2(10) NOT NULL,
fromDate DATE NOT NULL,
PRIMARY KEY(agentID),
FOREIGN KEY(agentID) REFERENCES SalesAgent(agentID));

-------

INSERT INTO SeniorAgent
VALUES 
('SA001',TO_DATE('08-07-2019','mm-dd--yyyy'));



--Creating and inserting values for JuniorAgent relation

CREATE TABLE JuniorAgent
(agentID VARCHAR2(10) NOT NULL,
SeniorAgentID VARCHAR2(10) NOT NULL,
PRIMARY KEY(agentID),
FOREIGN KEY(agentID) REFERENCES SalesAgent(agentID),
FOREIGN KEY(SeniorAgentID) REFERENCES SalesAgent(agentID));

-------

INSERT INTO JuniorAgent
VALUES
('SA002','SA001');


