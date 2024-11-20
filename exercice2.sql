set SERVEROUTPUT on
create table employee(id NUMBER NOT NULL,name varchar(50) NOT NULL, salary NUMBER, iddep NUMBER);

INSERT INTO employee VALUES (1,'oussema ferchichi', 4000, 100);
INSERT INTO employee VALUES (6,'oussema ferchichi', 4000, 100);
INSERT INTO employee VALUES (7,'oussema', 7800, 100);
INSERT INTO employee VALUES (2,'ahmed ferchichi', 5000, 200);
INSERT INTO employee VALUES (3,'achref ferchichi', 6000, 100);
INSERT INTO employee VALUES (4,'mimoun ferchichi', 10000, 200);
INSERT INTO employee VALUES (5,'aida ferchichi', 10000, 300);

create table dep(iddep number , depname varchar(50), empnumber number )

INSERT INTO dep VALUES (100,'info', 150);
INSERT INTO dep VALUES (200,'gestion ', 120);
INSERT INTO dep VALUES (300,'eco', 350);


CREATE OR REPLACE FUNCTION CALCUL_TOTAL_SAL(DEPID EMPLOYEE.IDDEP%TYPE)RETURN NUMBER AS
 totalsal EMPLOYEE.SALARY%TYPE :=0;
 CURSOR CURS IS SELECT SALARY FROM EMPLOYEE WHERE IDDEP = DEPID;
BEGIN
IF(DEPID>0) THEN
FOR CUR IN CURS LOOP 
totalsal := totalsal+CUR.salary;
END LOOP;
RETURN totalsal;
ELSE
RAISE_APPLICATION_ERROR(-20002,'dep id est invalid');
END IF;
END CALCUL_TOTAL_SAL;

DECLARE 
 totalsal NUMBER;
 depid number :=&depidd;
 invalid_depid EXCEPTION;
 PRAGMA EXCEPTION_INIT(invalid_depid,-20002);
BEGIN
totalsal := CALCUL_TOTAL_SAL(depid) ;
DBMS_OUTPUT.PUT_LINE('le total du salary est ' || totalsal || ' de la departement numero '|| depid);
EXCEPTION
WHEN invalid_depid THEN 
  DBMS_OUTPUT.PUT_LINE('inalid department id');
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('ERREUR');

END;
/

CREATE OR REPLACE PROCEDURE UPDATE_SAL(depid employee.IDDEP%TYPE, PERCENTAGE NUMBER) AS
CURSOR CURS IS SELECT * FROM EMPLOYEE WHERE IDDEP = depid;
BEGIN 
FOR CUR IN CURS LOOP 
UPDATE EMPLOYEE SET SALARY = CUR.SALARY*PERCENTAGE WHERE id = CUR.id;
DBMS_OUTPUT.PUT_LINE('L EMPLOYEE ' || CUR.NAME ||' ETE UPDATED VERS  ' ||  CUR.SALARY*PERCENTAGE );
END LOOP;
END UPDATE_SAL;

DECLARE 
PERCENTAGE NUMBER := &PER;
depid number := &dep;
BEGIN 
UPDATE_SAL(depid,PERCENTAGE);
END;
/

CREATE OR REPLACE FUNCTION FIND_MAX_NAME(DEPID EMPLOYEE.IDDEP%TYPE) RETURN VARCHAR2 AS
CURSOR CURS(DEP EMPLOYEE.IDDEP%TYPE) IS SELECT * FROM EMPLOYEE WHERE  salary = (select MAX(salary) from employee where IDDEP = DEP);
RES VARCHAR2(100);
BEGIN 
RES:='';
FOR CUR IN CURS(DEPID)LOOP 
RES := RES ||' ' || CUR.salary|| '  ' ||CUR.NAME;

END LOOP;
return RES;
END FIND_MAX_NAME;

DECLARE 
dep EMPLOYEE.IDDEP%TYPE:=&de;
RES VARCHAR2(100);
BEGIN 
RES:= FIND_MAX_NAME(dep);
DBMS_OUTPUT.PUT_LINE(RES);
END;
/

CREATE OR REPLACE PROCEDURE SUPPRIME_EMPLOYEE(valeur EMPLOYEE.SALARY%TYPE) AS
CURSOR CURS(VAL EMPLOYEE.SALARY%TYPE) IS SELECT * FROM EMPLOYEE WHERE SALARY < VAL ; 
BEGIN 
IF (valeur > 0) THEN
FOR CUR IN CURS(valeur) LOOP 
DELETE FROM EMPLOYEE WHERE id = CUR.id;
DBMS_OUTPUT.PUT_LINE('lemployeee '|| CUR.NAME ||' a ete supprimer');
END LOOP;
ELSE
RAISE_APPLICATION_ERROR(-20001, 'salaire invalid');
END IF;
END SUPPRIME_EMPLOYEE;


DECLARE 
SALAIRE_INVALID EXCEPTION;
PRAGMA EXCEPTION_INIT(SALAIRE_INVALID,-20001);
BEGIN 
SUPPRIME_EMPLOYEE(0);

EXCEPtION 
WHEN SALAIRE_INVALID THEN 
DBMS_OUTPUT.PUT_LINE('salaire inavlid ');
WHEN OTHERS THEN 
DBMS_OUTPUT.PUT_LINE('erreur ');


END;
/















