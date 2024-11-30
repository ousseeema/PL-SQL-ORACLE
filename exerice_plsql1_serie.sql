set SERVEROUTPUT ON
--creating  the procedure that add person to be employee 
CREATE OR REPLACE PROCEDURE ADD_EMP(idemp number , name varchar2, salary number , depid number) as
numberof_dep number :=0;
numberof_id number :=0;
begin
select COUNT(*) into numberof_dep from dep where IDDEP = depid;
select COUNT(*) INTO numberof_id from HR_SIMILAR.EMPLOYEE where IDEMP = idemp;
IF numberof_dep = 0 then 
 RAISE_APPLICATION_ERROR(-20010,'depid nexiste pas');
 ELSIF salary <0 then
 RAISE_APPLICATION_ERROR(-20012, 'salary must be positive');
  ELSIF numberof_id > 0 then
 RAISE_APPLICATION_ERROR(-20011, 'emp not found');
 ELSE
   INSERT INTO employee VALUES (idemp,name,salary, depid);
   END IF;
end ADD_EMP;


--create the programme that will call the procedure

DECLARE 
  dep_id_existe EXCEPTION;
  emp_existe EXCEPTION;
  sal_negatif EXCEPTION;
 PRAGMA EXCEPTION_INIT(dep_id_existe,-20010);
 PRAGMA EXCEPTION_INIT( sal_negatif,-20012);
BEGIN
HR_SIMILAR.ADD_EMP(1000,'oussema ferchihi77',1422,100);

EXCEPTION
WHEN dep_id_existe then
  dbms_output.put_line('dep n existe pas');
  WHEN emp_existe then
  dbms_output.put_line('emp n existe pas');
   when sal_negatif then
     dbms_output.put_line('sal negatif ');
   

END;
/

--FONCTION QUI CALCUL LA SOMME DES SALAIRES DUN DEPARTEMENT DONNER (methode 1 avec cursor):
CREATE OR REPLACE FUNCTION GET_TOTAL_SAL(depid number ) return number as
CURSOR CUR(depid number ) is select salary from employee where IDDEP = depid;
som_sal number :=0;
nb_dep number :=0;
begin
select count(*) into nb_dep from employee where IDDEP= depid;

if(nb_dep = 0) then
  RAISE_APPLICATION_ERROR(-20020, 'aucune employee donner cette departement');
  ELSE
   for cu in CUR(depid) LOOP
   som_sal := som_sal+ cu.salary;
   END LOOP;
   RETURN som_sal;
END IF;

end GET_TOTAL_SAL;



-- the body where the code will de execute

DECLARE 
TOTAL NUMBER;
 dep_existe EXCEPTION;
 PRAGMA EXCEPTION_INIT(dep_existe, -20020);
BEGIN 
TOTAL := GET_TOTAL_SAL(100);
dbms_output.put_line('le salaire total est : '||TOTAL);
 exception 
 when dep_existe then
 dbms_output.put_line('le departement entre na aucune salarie');
 when others then 
 dbms_output.put_line('error');
END;
/
--FONCTION QUI CALCUL LA SOMME DES SALAIRES DUN DEPARTEMENT DONNER (methode 2 avec select into):
CREATE OR REPLACE FUNCTION CAL_SAL(depid number) return number as
nb_dep number :=0;
som_sal number :=0;
begin
select count(*) into nb_dep from employee where IDDEP=depid;
IF nb_dep = 0 then 
RAISE_APPLICATION_ERROR(-20022,'aucune employee dans le departement');
ELSE 
select SUM(salary) into som_sal from employee where IDDEP= depid;
return som_Sal;
END IF;
end CAL_SAL;
/

--LE BODY WHERE THE FUNCTION WILL BE EXECUTED :
DECLARE 
SOMME NUMBER ;
dep_nexiste EXCEPTION;
PRAGMA EXCEPTION_INIT(dep_nexiste,-20022);
BEGIN 
SOMME := CAL_SAL(100);
dbms_output.put_line('le salaire total est : '||SOMME);
 EXCEPTION
 when dep_nexiste then
 dbms_output.put_line('le departement na aucune employee ');
 when others then 
 dbms_output.put_line('erreur');
END;
/


-- FONCTION QUI REMPLACE LE DEPARTEMENT ID AVEC LE NOUVELLE DEPARTMENT ID QUI A ETE PASSEE DANS LE PARAMETRE 
CREATE OR REPLACE PROCEDURE REMPLACE_DEPID(idm number , depid number) AS
id_existe number :=0;
dep_existe number :=0;
no_emp EXCEPTION;
no_dep EXCEPTION;
PRAGMA EXCEPTION_INIT(no_emp, -20100);
PRAGMA EXCEPTION_INIT(no_dep,-20101);
begin 
select count(IDEMP) into id_existe from employee where IDEMP = idm;
select count(*) into dep_existe from dep where IDDEP = depid;
if id_existe = 0 then 
RAISE_APPLICATION_ERROR(-20100,'employee nexiste pas');
elsif dep_existe =0 then
RAISE_APPLICATION_ERROR(-20101, 'departement nexiste pas ');
else 
UPDATE employee SET IDDEP = depid where IDEMP = idm ;
 dbms_output.put_line('mise a jour de departement est terminer');
END IF;
EXCEPTION 
when no_dep then
 dbms_output.put_line('departement nexiste pasdena le tableau departement  ');
 when  no_emp then 
  dbms_output.put_line('no employee avec cette id');
end REMPLACE_DEPID;

--BLOCK DE CODE OU ON A  EXECUTE LA FONCTION REMPLACE DEPID
DECLARE 
BEGIN 
REMPLACE_DEPID(114,300);
END;
/
-- FONCTION QUI RETURN LE NOMBRE DEMPLOYEE DANS UN DEPARTEMNET DONNER 
CREATE OR REPLACE FUNCTION TOTAL_EMP_DEP(depid number) return number AS
total number :=0;
BEGIN
 select count(*) into total from employee where IDDEP = depid;
RETURN total;
END TOTAL_EMP_DEP;
-- le corp ou la fonction sera execute
DECLARE 
TOTAL NUMBER :=0 ;
BEGIN 
TOTAL :=TOTAL_EMP_DEP(400) ;
    dbms_output.put_line('la somme de employee est  '||TOTAL);

END;
/


-- en va re-ecrire la blok ou sexecute la 1er procedure dinsertion en ajoutant le tretrement de le cas ou on a aucune information sur lexception
DECLARE 
  dep_id_existe EXCEPTION;
  emp_existe EXCEPTION;
  sal_negatif EXCEPTION;
 PRAGMA EXCEPTION_INIT(dep_id_existe,-20010);
  PRAGMA EXCEPTION_INIT(emp_existe,-20011);

 PRAGMA EXCEPTION_INIT( sal_negatif,-20012);
BEGIN
HR_SIMILAR.ADD_EMP(1000,'oussema ferchihi77',1422,100);

EXCEPTION
WHEN dep_id_existe then
  dbms_output.put_line('dep n existe pas');
  WHEN emp_existe then
  dbms_output.put_line('emp existe');
   when sal_negatif then
     dbms_output.put_line('sal negatif ');
     when OTHERS then
          dbms_output.put_line('errer');
END;
/

-- cette procedure ,sont tache est de supprime un employee dans un table 
 
CREATE OR REPLACE PROCEDURE DEL_EMP(idmp number)as
nb_emp number :=0;
emp_existe EXCEPTION;
PRAGMA EXCEPTION_INIT(emp_existe,-20025);
begin
select count(*) into nb_emp from employee WHERE IDEMP= idmp ;
IF nb_emp = 0  then 
 RAISE_APPLICATION_ERROR(-20025, 'employe nexiste pas');
 else 
  DELETE FROM EMPLOYEE WHERE IDEMP = idmp;
 dbms_output.put_line('employee deleted');
  END IF;
 EXCEPTION 
 WHEN emp_existe THEN
  dbms_output.put_line('employee  n existe pas dans le tableau');
  WHEN OTHERS THEN 
   dbms_output.put_line(' ERROR');
end DEL_EMP;

-- BLOK DE CODE AU LA PROCEDURE VA ETRE EXECUTE 
DECLARE
BEGIN 
DEL_EMP(1);
END;

-- cette fonction calcul la nouvelle salaire de lemployee donner avec un taux donner
CREATE OR REPLACE FUNCTION TAUX_SAL(idmp number , taux number)return number as
nv_sal number :=0;
nb_emp number :=0;
emp_notfound EXCEPTION;
PRAGMA EXCEPTION_INIT(emp_notfound,-20027);
begin 
select count(*) into nb_emp from employee where IDEMP = idmp;
if nb_emp =0 then 
RAISE_APPLICATION_ERROR(-20027,'employee not found');
else 
select salary into nv_sal from employee where IDEMP = idmp;
nv_sal := nv_sal * taux;
return nv_sal;
end if;
EXCEPTION
WHEN emp_notfound THEN 
   dbms_output.put_line(' EMPLOYEE NOT FOUND IN THE DATA BASE');
WHEN OTHERS THEN 
   dbms_output.put_line(' ERROR');

end TAUX_SAL;
-- la block  de code ou on a execute la fonction TAUX_SAL 
DECLARE 
NV_SAL NUMBER ;
BEGIN
NV_SAL := TAUX_SAL(2, 1.25);
   dbms_output.put_line('la nouvelle salaire de lemployee  est '||NV_SAL);

END;
/

--










