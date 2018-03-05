<%-- 
    Document   : index
    Created on : Nov 8, 2017, 11:55:39 PM
    Author     : User
--%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="utils.DBHelper"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <title>Retail Business Management System</title>
        <link href="style.css" rel="stylesheet" type="text/css" />
    </head>
    <body>
        <%@include file="header.jsp" %>
        <!--body start -->
        <div id="body">
            <!--left panel start -->
            <div id="left">
                <br>
                <center>
                <h3>Dashboard</h3>
                </center>
                <p class="text2">
                    <b> 
                        <%
                            DBHelper db = new DBHelper();
                        %>
                    </b>
                  
                <center>
                    <div style="width: 100%; float:left">
                    <div style="width: 150px; height: 70px; margin: 10px; background-color:#880000; color: #ffffff; float: left; text-align: center" >
                        <br>
                        <%
                            //query to call function to get total number of products
                        ResultSet products=db.getData("select rbms.get_total_products from dual");
                            if(products.next()){
                                int count=Integer.parseInt(products.getString(1));
                                out.println(count);
                            }else{
                                out.println("0");
                            }
                        %>
                        <br>
                        Products
                    </div>
                        
                    <div style="width: 150px; height: 70px; margin: 10px; background-color:#888800; color: #ffffff; float: left; text-align: center" >
                        <br>
                        <%
                            //query to call function to get total number of purchases
                        ResultSet purchases=db.getData("select rbms.get_total_purchases from dual");
                            if(purchases.next()){
                                int count=Integer.parseInt(purchases.getString(1));
                                out.println(count);
                            }else{
                                out.println("0");
                            }
                        %>
                        <br>
                        Purchases
                    </div>
                        
                    <div style="width: 150px; height: 70px; margin: 10px; background-color:#008800; color: #ffffff; float: left; text-align: center" >
                        <br>
                        <%
                            //query to call function to get total number of customers
                            ResultSet customers=db.getData("select rbms.get_total_customers from dual");
                            if(customers.next()){
                                int count=Integer.parseInt(customers.getString(1));
                                out.println(count);
                            }else{
                                out.println("0");
                            }
                        %>
                        <br>
                        Customers
                    </div>
                        
                    <div style="width: 150px; height: 70px; margin: 10px; background-color:#000088; color: #ffffff; float: left; text-align: center" >
                        <br>
                        <%
                            //query to call function to get total number of employees
                            ResultSet employees=db.getData("select rbms.get_total_employees from dual");
                            if(employees.next()){
                                int count=Integer.parseInt(employees.getString(1));
                                out.println(count);
                            }else{
                                out.println("0");
                            }
                        %>
                        <br>
                        Employees
                    </div>
                        
                    <div style="width: 150px; height: 70px; margin: 10px; background-color:#008888; color: #ffffff; float: left; text-align: center" >
                        <br>
                        <%
                            //query to call function to get total number of suppliers
                            ResultSet suppliers=db.getData("select rbms.get_total_suppliers from dual");
                            if(suppliers.next()){
                                int count=Integer.parseInt(suppliers.getString(1));
                                out.println(count);
                            }else{
                                out.println("0");
                            }
                        %>
                        <br>
                        Suppliers
                    </div>
                    
                </div>
                </center>
                </p>
            </div>
            <br class="spacer" />

            <!--footer end -->
    </body>
</html>