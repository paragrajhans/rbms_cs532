create sequence pur# start with 10000 increment by 1;
create sequence sup# start with 100 increment by 1;
create sequence log# start with 1000 increment by 1;

create or replace TRIGGER insertcustomer 
AFTER INSERT ON 
CUSTOMERS 
FOR EACH ROW
DECLARE
 username varchar2(10);
BEGIN
  SELECT user into username FROM dual;
  INSERT INTO LOGS (log#,user_name,op_time,table_name,operation,tuple_pkey) VALUES (log#.NEXTVAL, username, SYSDATE, 'customers', 'Insert', :new.cid);
END;
/

create or replace TRIGGER updatecustomervisits 
AFTER UPDATE OF visits_made ON 
CUSTOMERS 
FOR EACH ROW
DECLARE
 username varchar2(10);
BEGIN
  SELECT user into username FROM dual;
  INSERT INTO LOGS (log#,user_name,op_time,table_name,operation,tuple_pkey) VALUES (log#.NEXTVAL, username, SYSDATE, 'customers', 'Update', :new.cid);
END;
/

create or replace TRIGGER insertpurchase 
AFTER INSERT ON 
PURCHASES 
FOR EACH ROW
DECLARE
 username varchar2(10);
BEGIN
  SELECT user into username FROM dual;
  INSERT INTO LOGS (log#,user_name,op_time,table_name,operation,tuple_pkey) VALUES (log#.NEXTVAL, username, SYSDATE, 'purchases', 'Insert', :new.pur#);
END;
/

create or replace TRIGGER deletepurchase
AFTER DELETE ON
PURCHASES
FOR EACH ROW
DECLARE
username varchar2(10);
BEGIN
SELECT user into username FROM dual;
  INSERT INTO LOGS (log#,user_name,op_time,table_name,operation,tuple_pkey) VALUES (log#.NEXTVAL, username, SYSDATE, 'purchases', 'Delete', :old.pur#);
END;
/

create or replace TRIGGER updateqoh 
AFTER UPDATE OF qoh ON 
PRODUCTS 
FOR EACH ROW
DECLARE
 username varchar2(10);
BEGIN
  SELECT user into username FROM dual;
  INSERT INTO LOGS (log#,user_name,op_time,table_name,operation,tuple_pkey) VALUES (log#.NEXTVAL, username, SYSDATE, 'products', 'Update', :new.pid);
END;
/

create or replace TRIGGER insertsupply 
AFTER INSERT ON 
SUPPLIES 
FOR EACH ROW
DECLARE
 username varchar2(10);
BEGIN
  SELECT user into username FROM dual;
  INSERT INTO LOGS (log#,user_name,op_time,table_name,operation,tuple_pkey) VALUES (log#.NEXTVAL, username, SYSDATE, 'supplies', 'Insert', :new.sup#);
END;
/
