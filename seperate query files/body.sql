create or replace package body rbms as
  --Funtion to return total number of employees
  FUNCTION get_total_employees RETURN NUMBER
  IS
      NumberOfEmployee NUMBER;
  BEGIN
      SELECT COUNT(*) INTO NumberOfEmployee FROM employees;
      RETURN NumberOfEmployee;
  END get_total_employees;

  --Funtion to return total number of customers
  FUNCTION get_total_customers RETURN NUMBER
  IS
      NumberOfCustomer NUMBER;
  BEGIN
      SELECT COUNT(*) INTO NumberOfCustomer FROM customers;
      RETURN NumberOfCustomer;
  END get_total_customers;

  --Funtion to return total number of products
  FUNCTION get_total_products RETURN NUMBER
  IS
      NumberOfProduct NUMBER;
  BEGIN
      SELECT COUNT(*) INTO NumberOfProduct FROM products;
      RETURN NumberOfProduct;
  END get_total_products;

  --Funtion to return total number of suppliers
  FUNCTION get_total_suppliers RETURN NUMBER
  IS
      NumberOfSuppliers NUMBER;
  BEGIN
      SELECT COUNT(*) INTO NumberOfSuppliers FROM suppliers;
      RETURN NumberOfSuppliers;
  END get_total_suppliers;

  --Funtion to return total number of supplies by supplier
  FUNCTION get_total_supplies(s_id IN CHAR) RETURN NUMBER
  IS
      NumberOfSupplies NUMBER;
  BEGIN
      SELECT COUNT(*) INTO NumberOfSupplies FROM supplies where sid=s_id;
      RETURN NumberOfSupplies;
  END get_total_supplies;

  --Funtion to return total number of purchases
  FUNCTION get_total_purchases RETURN NUMBER
  IS
      NumberOfPurchases NUMBER;
  BEGIN
      SELECT COUNT(*) INTO NumberOfPurchases FROM purchases;
      RETURN NumberOfPurchases;
  END get_total_purchases;

    --Funtion to return total saving for pur#
  FUNCTION purchase_saving(pur# IN CHAR) RETURN NUMBER
  IS
  pur_id NUMBER;
  total_saving NUMBER;
  BEGIN
  pur_id:=pur#;
  select (original_price*qty-total_price) as total_saving into total_saving from purchases,products where purchases.pur#=pur_id and purchases.pid=products.pid;
  RETURN total_saving;
  END purchase_saving;
  
  --Procedure to return all employee record
  PROCEDURE show_employees(out_prc OUT sys_refcursor)
  AS
  BEGIN
      OPEN out_prc for select * from employees;
  END show_employees;

  --Procedure to return all customer record
  PROCEDURE show_customers(out_prc OUT sys_refcursor)
  AS
  BEGIN
      OPEN out_prc for select * from customers;
  END show_customers;

  --Procedure to return all product record
  PROCEDURE show_products(out_prc OUT sys_refcursor)
  AS
  BEGIN
      OPEN out_prc for select * from products,discounts where products.discnt_category=discounts.discnt_category;
  END show_products;

  --Procedure to return all discount record
  PROCEDURE show_discounts(out_prc OUT sys_refcursor)
  AS
  BEGIN
      OPEN out_prc for select * from discounts;
  END show_discounts;

  --Procedure to return all suppliers record
  PROCEDURE show_suppliers(out_prc OUT sys_refcursor)
  AS
  BEGIN
      OPEN out_prc for select * from suppliers;
  END show_suppliers;

  --Procedure to return all products supplied by given supplier
  PROCEDURE show_supplies(s_id IN CHAR, out_prc OUT sys_refcursor)
  AS
  BEGIN
      OPEN out_prc for select sup#,supplies.pid,products.name as product,sid,sdate,quantity from supplies,products where supplies.pid=products.pid and supplies.sid=s_id;
  END show_supplies;

  --Procedure to return all purchase record
  PROCEDURE show_purchases(out_prc OUT sys_refcursor)
  AS
  BEGIN
      OPEN out_prc for select purchases.pur#, purchases.eid, purchases.pid, purchases.cid, products.original_price, purchases.qty, purchases.total_price, purchases.ptime, employees.name as employee_name, products.name as product_name, customers.name as customer_name from purchases,employees,products,customers where purchases.eid=employees.eid and purchases.pid=products.pid and purchases.cid=customers.cid;
  END show_purchases;

  --Procedure to add customer record
  PROCEDURE add_customer(c_id IN CHAR, c_name IN VARCHAR, c_telephone# IN CHAR)
  AS
  BEGIN
      insert into customers(cid,name,telephone#,visits_made,last_visit_date)
values(c_id,c_name,c_telephone#,1,sysdate);
  END add_customer;
  
  --Procedure to add purchase record
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
  
  --Check if purchase quantity is more than quantity on hold
  IF(pur_qty>n_qoh) then
	DBMS_OUTPUT.PUT_LINE('Insufficient quantity in stock');
	RAISE insufficient_qty_exception;	
  ELSE
	  n_total_price:=n_original_price*pur_qty;
	  n_discnt_price:=n_total_price*n_discnt_rate;
	  n_total_price:=n_total_price-n_discnt_price;
	  
	  --Add purchase record
	  insert into purchases values(pur#.nextval,e_id,n_product_id,c_id,pur_qty,sysdate,n_total_price);
	  
	  --Update product quantity
	  update products set qoh=qoh-pur_qty where pid=n_product_id;
	  n_new_qty:=n_qoh-pur_qty;
	  
	  --Check if new quantity is less than threshold
	  if((n_new_qty)<n_qoh_threshold) then
		DBMS_OUTPUT.PUT_LINE('Current QOH of the product is below the required threshold and new supply is required');
		n_new_supply_qty:=n_qoh_threshold-n_new_qty+1+10;
		
		--Get product supplied by supplier
		select sid into n_sid from supplies where sid = (select min(sid) from supplies where pid=n_product_id) group by sid;
		
		--Add Supply entry
		insert into supplies values(sup#.nextval, n_product_id, n_sid, sysdate,n_new_supply_qty); 
		
		--Udpate product quantity
		update products set qoh=qoh+n_new_supply_qty where pid=n_product_id;
		select qoh into n_updated_qoh from products where pid=n_product_id;
		DBMS_OUTPUT.PUT_LINE('Current QOH of the product is '||n_updated_qoh);
	  end if;
  END IF;
  --Update customer visit
  update customers set visits_made=visits_made+1, last_visit_date=sysdate where cid=c_id;
  EXCEPTION
  WHEN insufficient_qty_exception THEN
    RAISE_APPLICATION_ERROR(-20001, 'Insufficient quantity in stock.');
  END add_purchase;
  
  --Procedure to return monthly sales made by given employee
  PROCEDURE monthly_sale_activities(employee_id IN CHAR, out_prc OUT sys_refcursor)
  AS
  BEGIN
  open out_prc for select purchases.eid,employees.name, to_char(purchases.ptime,'MON YYYY') as ptime, count(purchases.pur#) as total_sales,sum(qty) as total_qty_sale, sum(total_price) as total_sale_price from purchases,employees where purchases.eid=employees.eid and purchases.eid=employee_id group by purchases.eid,employees.name,to_char(purchases.ptime,'MON YYYY');
  END monthly_sale_activities;

  --Procedure to delete given purchase
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
  --Check if purchase is available
  if pur_count<1 then
	DBMS_OUTPUT.PUT_LINE('purchase not found');
  else
	select pid,cid,qty into p_id,c_id,n_qty from purchases where pur#=pur_id;
	DBMS_OUTPUT.PUT_LINE('purchase found');
	DBMS_OUTPUT.PUT_LINE('pid '||p_id||' qty '||n_qty);
	--Delete purchase record
	delete from purchases where pur#=pur_id;
	
	--update product quantity
	update products set qoh=qoh+n_qty where pid=p_id;
	
	--update customer visit
	update customers set visits_made=visits_made+1, last_visit_date=sysdate where cid=c_id;
  end if;
  END delete_purchase;
  end rbms;
  /