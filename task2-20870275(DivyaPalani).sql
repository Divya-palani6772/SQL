------------------------------Task 2 a-------------------------------

CREATE OR REPLACE PROCEDURE Cars(inputYear DATE) AS 

      v_lowMileageCount NUMBER := 0;
      v_mediumMileageCount NUMBER := 0;
      v_highMileageCount NUMBER :=0;
      v_totalCount NUMBER :=0;
    
BEGIN

      select COUNT(c.currentMileage)
      into v_lowMileageCount
      from car c, salestransaction s
      where c.VIN = s.VIN
      and to_char(s.dateOfSale, 'YYYY') = to_char(inputYear, 'YYYY')
      and c.currentMileage < '50000';

      select COUNT(c.currentMileage)
      into v_mediumMileageCount
      from car c, salestransaction s
      where c.VIN = s.VIN
      and to_char(s.dateOfSale, 'YYYY') = to_char(inputYear, 'YYYY')
      and c.currentMileage >= '50000' AND c.currentMileage < '150000';
            
      select COUNT(c.currentMileage)
      into v_highMileageCount
      from car c, salestransaction s
      where c.VIN = s.VIN
      and to_char(s.dateOfSale, 'YYYY') = to_char(inputYear, 'YYYY')
      and c.currentMileage >= '150000';

      v_totalCount := v_lowMileageCount + v_mediumMileageCount + v_highMileageCount;

      DBMS_OUTPUT.PUT_LINE('Details Of Cars sold in the year' || ' ' || to_char(inputYear, 'YYYY'));
      DBMS_OUTPUT.PUT_LINE('-------------------------------------');
      DBMS_OUTPUT.PUT_LINE('NO. Of Low Mileage Cars sold:' || ' ' || v_lowMileageCount);
      DBMS_OUTPUT.PUT_LINE('NO. Of Medium Mileage Cars sold:' || ' ' || v_mediumMileageCount);
      DBMS_OUTPUT.PUT_LINE('NO. Of High Mileage Cars sold:' || ' ' || v_highMileageCount);
      DBMS_OUTPUT.PUT_LINE('Total NO. Of Cars sold this date:' || ' ' || v_totalCount);

END Cars;
/

--to execute

BEGIN
Cars(to_date('2020','YYYY'));
END;



-------------------------------Task 2 b-------------------------------

CREATE OR REPLACE FUNCTION SeniorAgentCommission(p_seniorAgentID SeniorAgent.AgentID%type)
RETURN NUMBER IS
v_commission NUMBER;
v_agreed SalesTransaction.agreedPrice%type;
v_asking Car.askingPrice%type;

BEGIN
      SELECT SUM(s.agreedPrice), SUM(c.askingPrice)
      INTO v_agreed, v_asking
      FROM SalesTransaction s, Car c, SeniorAgent sa
      WHERE s.VIN = c.VIN
      AND sa.AgentID = s.AgentID
      AND sa.AgentID = p_seniorAgentID;



      IF v_agreed > v_asking THEN
            select SUM((st.agreedPrice - c.askingPrice) * (ROUND((to_char(SYSDATE, 'YYYY') - to_char(yearPromoted, 'YYYY')) + ((to_char(SYSDATE, 'MM') - to_char(yearPromoted, 
                  'MM'))/12), 0) /100))
            INTO v_commission
            FROM SalesTransaction st, SeniorAgent sa, Car c
            WHERE st.agentID = sa.agentID
            AND st.VIN = c.VIN
            AND st.agentID = p_seniorAgentID;

            RETURN v_commission;
      END IF;

END SeniorAgentCommission;
/

--to execute

      SELECT SUM((st.AgreedPrice - c.AskingPrice) * (ROUND((to_char(SYSDATE, 'YYYY') - to_char(yearPromoted, 'YYYY')) + ((to_char(SYSDATE, 'MM') - to_char(yearPromoted, 
                  'MM'))/12), 0) /100)) AS "Total commission", SeniorAgentCommission('1') AS "Individual Commission" 
      FROM SalesTransaction st, SeniorAgent sa, Car c
      WHERE st.AgentID = sa.AgentID
      AND st.VIN = c.VIN;




      