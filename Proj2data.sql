drop sequence pur#;
drop sequence sup#;
drop sequence log#;

create sequence pur# start with 10000 increment by 1;
create sequence sup# start with 100 increment by 1;
create sequence log# start with 1000 increment by 1;

create table employees
(eid char(3) primary key,
name varchar2(15),
telephone# char(12),
email varchar2(20));

create table customers
(cid char(4) primary key,
name varchar2(15),
telephone# char(12),
visits_made number(4) check (visits_made >= 1),
last_visit_date date);

create table purchases
(pur# number(6) primary key,
eid char(3) references employees(eid),
pid char(4) references products(pid),
cid char(4) references customers(cid),
qty number(5),
ptime date,
total_price number(7,2));

create table discounts
(discnt_category number(1) primary key check(discnt_category in (1, 2, 3, 4)),
discnt_rate number(3,2) check (discnt_rate between 0 and 0.8));

create table products
(pid char(4) primary key,
name varchar2(15),
qoh number(5),
qoh_threshold number(4),
original_price number(6,2),
discnt_category number(1) references discounts);

create table suppliers
(sid char(2) primary key,
name varchar2(15) not null unique,
city varchar2(15),
telephone# char(12) not null unique,
email varchar2(20) unique);

create table supplies
(sup# number(4) primary key,
pid char(4) references products(pid),
sid char(2) references suppliers(sid),
sdate date,
quantity number(5),
unique(pid, sid, sdate));

create table logs
(log# number(5) primary key,
user_name varchar2(12) not null,
operation varchar2(6) not null,
op_time date not null,
table_name varchar2(20) not null,
tuple_pkey varchar2(6)); 


insert into employees values ('1', 'David', '666-555-1234', 'david@rb.com');
insert into employees values ('2', 'Peter', '777-555-2341', 'peter@rb.com');
insert into employees values ('3', 'Susan', '888-555-3412', 'susan@rb.com');
insert into employees values ('4', 'Anne', '666-555-4123', 'anne@rb.com');
insert into employees values ('5', 'Mike', '444-555-4231', 'mike@rb.com');

insert into customers values ('1', 'Kathy', '666-555-4567', 3, '12-OCT-17');
insert into customers values ('2', 'John', '888-555-7456', 1, '08-OCT-17');
insert into customers values ('3', 'Chris', '666-555-6745', 3, '18-SEP-17');
insert into customers values ('4', 'Mike', '999-555-5674', 1, '15-OCT-17');
insert into customers values ('5', 'Mike', '777-555-4657', 2, '30-AUG-17');
insert into customers values ('6', 'Connie', '777-555-7654', 2, '16-OCT-17');
insert into customers values ('7', 'Katie', '888-555-6574', 1, '12-OCT-17');
insert into customers values ('8', 'Joe', '666-555-5746', 1, '14-OCT-17');

insert into discounts values(1, 0);
insert into discounts values(2, 0.1);
insert into discounts values(3, 0.2);
insert into discounts values(4, 0.3);

insert into products values(1,'stapler', 60, 50, 9.99, 2);
insert into products values(2,'camera', 20, 5, 148, 3);
insert into products values(3,'pencil', 100, 10, 0.99, 1);
insert into products values(4,'lamp', 10, 6, 19.95, 2);
insert into products values(5,'chair', 10, 8, 12.98, 4);

insert into suppliers values(1, 'Sandy', 'New York', '9999999999', 'sandy@gmail.com');
insert into suppliers values(2, 'Pawan', 'XYZ', '8888888888', 'pawan@yahoo.com');

insert into supplies values(sup#.nextval, 2, 1, sysdate, 10);
insert into supplies values(sup#.nextval, 5, 2, sysdate, 50);
insert into supplies values(sup#.nextval, 1, 1, sysdate, 25);
insert into supplies values(sup#.nextval, 4, 2, sysdate, 20);
insert into supplies values(sup#.nextval, 3, 2, sysdate, 30);
insert into supplies values(sup#.nextval, 1, 1, sysdate, 13);



drop trigger insertcustomer;
drop trigger updatecustomervisits;
drop trigger insertpurchase
drop trigger updateqoh;
drop trigger insertsupply;

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


drop package rbms;

create or replace package rbms as
FUNCTION get_total_employees RETURN NUMBER;
FUNCTION get_total_customers RETURN NUMBER;
FUNCTION get_total_products RETURN NUMBER;
FUNCTION get_total_suppliers RETURN NUMBER;
FUNCTION get_total_supplies(s_id IN CHAR) RETURN NUMBER;
FUNCTION get_total_purchases RETURN NUMBER;
FUNCTION purchase_saving(pur# IN CHAR) RETURN NUMBER;

PROCEDURE show_employees(out_prc OUT sys_refcursor);
PROCEDURE show_customers(out_prc OUT sys_refcursor);
PROCEDURE show_products(out_prc OUT sys_refcursor);
PROCEDURE show_discounts(out_prc OUT sys_refcursor);
PROCEDURE show_suppliers(out_prc OUT sys_refcursor);
PROCEDURE show_supplies(s_id IN CHAR, out_prc OUT sys_refcursor);
PROCEDURE show_purchases(out_prc OUT sys_refcursor);
PROCEDURE add_customer(c_id IN CHAR, c_name IN VARCHAR, c_telephone# IN CHAR);
PROCEDURE add_purchase(e_id IN CHAR, p_id IN CHAR, c_id IN CHAR, pur_qty IN NUMBER);
PROCEDURE monthly_sale_activities(employee_id IN CHAR, out_prc OUT sys_refcursor);
PROCEDURE delete_purchase(pur# IN CHAR);
end rbms;
/

create or replace package body rbms as
  FUNCTION get_total_employees RETURN NUMBER
  IS
      NumberOfEmployee NUMBER;
  BEGIN
      SELECT COUNT(*) INTO NumberOfEmployee FROM employees;
      RETURN NumberOfEmployee;
  END get_total_employees;

  FUNCTION get_total_customers RETURN NUMBER
  IS
      NumberOfCustomer NUMBER;
  BEGIN
      SELECT COUNT(*) INTO NumberOfCustomer FROM customers;
      RETURN NumberOfCustomer;
  END get_total_customers;

  FUNCTION get_total_products RETURN NUMBER
  IS
      NumberOfProduct NUMBER;
  BEGIN
      SELECT COUNT(*) INTO NumberOfProduct FROM products;
      RETURN NumberOfProduct;
  END get_total_products;

  FUNCTION get_total_suppliers RETURN NUMBER
  IS
      NumberOfSuppliers NUMBER;
  BEGIN
      SELECT COUNT(*) INTO NumberOfSuppliers FROM suppliers;
      RETURN NumberOfSuppliers;
  END get_total_suppliers;

  FUNCTION get_total_supplies(s_id IN CHAR) RETURN NUMBER
  IS
      NumberOfSupplies NUMBER;
  BEGIN
      SELECT COUNT(*) INTO NumberOfSupplies FROM supplies where sid=s_id;
      RETURN NumberOfSupplies;
  END get_total_supplies;


  FUNCTION get_total_purchases RETURN NUMBER
  IS
      NumberOfPurchases NUMBER;
  BEGIN
      SELECT COUNT(*) INTO NumberOfPurchases FROM purchases;
      RETURN NumberOfPurchases;
  END get_total_purchases;

  FUNCTION purchase_saving(pur# IN CHAR) RETURN NUMBER
  IS
  pur_id NUMBER;
  total_saving NUMBER;
  BEGIN
  pur_id:=pur#;
  select (original_price*qty-total_price) as total_saving into total_saving from purchases,products where purchases.pur#=pur_id and purchases.pid=products.pid;
  RETURN total_saving;
  END purchase_saving;
  
  PROCEDURE show_employees(out_prc OUT sys_refcursor)
  AS
  BEGIN
      OPEN out_prc for select * from employees;
  END show_employees;

  PROCEDURE show_customers(out_prc OUT sys_refcursor)
  AS
  BEGIN
      OPEN out_prc for select * from customers;
  END show_customers;

  PROCEDURE show_products(out_prc OUT sys_refcursor)
  AS
  BEGIN
      OPEN out_prc for select * from products,discounts where products.discnt_category=discounts.discnt_category;
  END show_products;

  PROCEDURE show_discounts(out_prc OUT sys_refcursor)
  AS
  BEGIN
      OPEN out_prc for select * from discounts;
  END show_discounts;

  PROCEDURE show_suppliers(out_prc OUT sys_refcursor)
  AS
  BEGIN
      OPEN out_prc for select * from suppliers;
  END show_suppliers;

  PROCEDURE show_supplies(s_id IN CHAR, out_prc OUT sys_refcursor)
  AS
  BEGIN
      OPEN out_prc for select sup#,supplies.pid,products.name as product,sid,sdate,quantity from supplies,products where supplies.pid=products.pid and supplies.sid=s_id;
  END show_supplies;

  PROCEDURE show_purchases(out_prc OUT sys_refcursor)
  AS
  BEGIN
      OPEN out_prc for select purchases.pur#, purchases.eid, purchases.pid, purchases.cid, products.original_price, purchases.qty, purchases.total_price, purchases.ptime, employees.name as employee_name, products.name as product_name, customers.name as customer_name from purchases,employees,products,customers where purchases.eid=employees.eid and purchases.pid=products.pid and purchases.cid=customers.cid;
  END show_purchases;

  PROCEDURE add_customer(c_id IN CHAR, c_name IN VARCHAR, c_telephone# IN CHAR)
  AS
  BEGIN
      insert into customers(cid,name,telephone#,visits_made,last_visit_date)
values(c_id,c_name,c_telephone#,1,sysdate);
  END add_customer;
  
  PROCEDURE add_purchase(e_id IN CHAR, p_id IN CHAR, c_id IN CHAR, pur_qty IN
 NUMBER)
  AS
  n_original_price products.original_price%type;
  n_qoh products.qoh%type;
  n_qoh_threshold products.qoh_threshold%type;
  n_discnt_rate discounts.discnt_rate%type;
  n_discnt_price NUMBER;
  n_total_price NUMBER;
  n_sid char(2);
  n_product_id products.pid%type;
  n_new_qty NUMBER;
  n_new_supply_qty NUMBER;
  n_updated_qoh NUMBER;
  insufficient_qty_exception EXCEPTION;
  BEGIN
  n_product_id:=p_id;
  select qoh, qoh_threshold, original_price, discnt_rate into n_qoh, n_qoh_threshold, n_original_price, n_discnt_rate from products,discounts where products.pid=n_product_id and products.discnt_category=discounts.discnt_category;
  IF(pur_qty>n_qoh) then
	DBMS_OUTPUT.PUT_LINE('Insufficient quantity in stock');
	RAISE insufficient_qty_exception;	
  ELSE
	  n_total_price:=n_original_price*pur_qty;
	  n_discnt_price:=n_total_price*n_discnt_rate;
	  n_total_price:=n_total_price-n_discnt_price;
	  insert into purchases values(pur#.nextval,e_id,n_product_id,c_id,pur_qty,sysdate,n_total_price);
	  update products set qoh=qoh-pur_qty where pid=n_product_id;
	  n_new_qty:=n_qoh-pur_qty;
	  if((n_new_qty)<n_qoh_threshold) then
		DBMS_OUTPUT.PUT_LINE('Current QOH of the product is below the required threshold and new supply is required');
		n_new_supply_qty:=n_qoh_threshold-n_new_qty+1+10;
		select sid into n_sid from supplies where sid = (select min(sid) from supplies where pid=n_product_id) group by sid;
		insert into supplies values(sup#.nextval, n_product_id, n_sid, sysdate,n_new_supply_qty); 
		update products set qoh=qoh+n_new_supply_qty where pid=n_product_id;
		select qoh into n_updated_qoh from products where pid=n_product_id;
		DBMS_OUTPUT.PUT_LINE('Current QOH of the product is '||n_updated_qoh);
	  end if;
  END IF;
  update customers set visits_made=visits_made+1, last_visit_date=sysdate where cid=c_id;
  EXCEPTION
  WHEN insufficient_qty_exception THEN
    RAISE_APPLICATION_ERROR(-20001, 'Insufficient quantity in stock.');
  END add_purchase;
  
  PROCEDURE monthly_sale_activities(employee_id IN CHAR, out_prc OUT sys_refcursor)
  AS
  BEGIN
  open out_prc for select purchases.eid,employees.name, to_char(purchases.ptime,'MON YYYY') as ptime, count(purchases.pur#) as total_sales,sum(qty) as total_qty_sale, sum(total_price) as total_sale_price from purchases,employees where purchases.eid=employees.eid and purchases.eid=employee_id group by purchases.eid,employees.name,to_char(purchases.ptime,'MON YYYY');
  END monthly_sale_activities;

  PROCEDURE delete_purchase(pur# IN NUMBER)
  AS 
  pur_id NUMBER;
  pur_count NUMBER;
  p_id purchases.pid%type;
  c_id purchases.cid%type;
  n_qty purchases.qty%type;
  BEGIN
  pur_id:=pur#;
  select count(*) into pur_count from purchases where pur#=pur_id;
  if pur_count<1 then
	DBMS_OUTPUT.PUT_LINE('purchase not found');
  else
	select pid,cid,qty into p_id,c_id,n_qty from purchases where pur#=pur_id;
	DBMS_OUTPUT.PUT_LINE('purchase found');
	DBMS_OUTPUT.PUT_LINE('pid '||p_id||' qty '||n_qty);
	delete from purchases where pur#=pur_id;
	update products set qoh=qoh+n_qty where pid=p_id;
	update customers set visits_made=visits_made+1, last_visit_date=sysdate where cid=c_id;
  end if;
  END delete_purchase;
  end rbms;
  /