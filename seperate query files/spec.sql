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
PROCEDURE delete_purchase(pur# IN NUMBER);
end rbms;
/