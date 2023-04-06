-----------------------------Task 1--------------------------------
--a

SELECT c.Name AS "Customer who bought MAX cars"
FROM SalesTransaction s, Customer c
WHERE s.custID = c.custID
GROUP BY c.Name
HAVING COUNT(s.custID) = (SELECT MAX(COUNT(custID))
                         FROM SalesTransaction
                         GROUP BY custID);

--b

SELECT sa.agentID AS "Agent ID", sa.Name AS "Agent Name", COUNT(s.agentID) AS "Total sales made"
FROM SalesTransaction s, SalesAgent sa
WHERE s.agentID (+) = sa.agentID
GROUP BY sa.agentID, sa.Name
ORDER BY COUNT(s.agentID) DESC;

--c

SELECT to_char(dateOfSale, 'MON') AS "Month Purchased", SUM(s.agreedPrice - c.purchasedPrice) AS "Total Profit"
FROM Car c, SalesTransaction s
WHERE c.VIN = s.VIN
AND to_char(dateOfSale, 'YYYY') = '2020'
GROUP BY to_char(dateOfSale, 'MON'), to_char(dateOfSale, 'MM')
ORDER BY to_char(dateOfSale, 'MM');

--d

SELECT m.Name AS "Manufacturer Name", mo.Name AS "Model Name", mo.Type AS "Model Type", COUNT(c.modelno) AS "No. of times sold"
FROM Manufacturer m, Model mo, Car c
WHERE m.ManufacturerID = mo.ManufacturerID
AND mo.ModelNO = c.ModelNO
GROUP BY m.Name, mo.Name, mo.Type
HAVING COUNT(c.ModelNO) = (SELECT MAX(COUNT(c.ModelNO))
                            FROM Car c, Manufacturer m, Model mo
                            WHERE c.ModelNO = mo.ModelNO
                            AND mo.ManufacturerID = m.ManufacturerID
                            AND m.Region = 'EUROPE'
                            Group BY c.ModelNO);

--e

SELECT to_char(dateOfSale, 'MON') as "Month", COUNT(*)/COUNT(distinct to_char(dateOfSale, 'YYYY')) AS "Average transactions/month"
FROM SalesTransaction
GROUP BY to_char(dateOfSale, 'MON'), to_char(dateOfSale, 'MM')
ORDER BY to_char(dateOfSale, 'MM');

--f

SELECT R1.SellingProfit - R3.vipPrice + R2.CarDisplayProfit AS "Total Profit"
FROM (SELECT SUM(sa.agreedPrice - c.purchasedPrice) AS SellingProfit
      FROM SalesTransaction sa, Car c
      WHERE sa.VIN = c.VIN) R1,
     (SELECT SUM(amountPaid) AS CarDisplayProfit
      from CarsViewed) R2,
     (SELECT ABS(SUM((sa.agreedPrice - (sa.agreedPrice * 0.05)) - c.purchasedPrice)) AS vipPrice
      FROM SalesTransaction sa, Car c, Customer cust
      WHERE c.VIN = sa.VIN
      AND sa.custID = cust.custID
      AND sa.agreedPrice >= '50000'
      AND cust.type = 'VIP') R3;







