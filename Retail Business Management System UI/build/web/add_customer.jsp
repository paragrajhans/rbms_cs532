<%-- x
    Document   : add_customer
    Created on : Nov 12, 2017, 11:39:29 PM
    Author     : User
--%>

<%@page import="java.sql.CallableStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="utils.DBHelper"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    DBHelper db = new DBHelper();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add/Update Customer</title>
        <link href="style.css" rel="stylesheet" type="text/css" />
    </head>
    <body>
        <!--body start -->
        <%@include file="header.jsp" %>
        <div id="body">
            <!--left panel start -->
            <div id="left">
                <p class="text2">  
                    <%
                        String cid = request.getParameter("cus_id");
                        String c_name = "", c_tel = "", c_email = "";
                        if (cid != null) {
                            //query to get customer data for given cid
                            try{
                                ResultSet rs = db.getData("select * from customers where cid='" + cid+"'");
                                if (rs.next()) {
                                    c_name = rs.getString("name");
                                    c_tel = rs.getString("telephone#");
                                }
                            }catch(Exception ex){System.out.println("add_customer.jsp-get_data : "+ ex.toString());}
                        }
                    %>
                <form method="post">
                    <center>
                        <table class="no_border" style="width:50%">
                            <tr><td class="no_border">Cid:</td> <td class="no_border"><input type="text" name="cid" value="<% if (cid != null) {
                            out.print(cid);
                        }%>" required></td></tr>
                            <tr><td class="no_border">Name:</td> <td class="no_border"><input type="text" name="name" value="<% out.print(c_name);%>" required></td></tr>
                            <tr><td class="no_border">Telephone:</td> <td class="no_border"><input type="text" name="telephone#" value="<% out.print(c_tel);%>" required></tr>
                            <tr><td class="no_border"></td><td class="no_border" style="column-span: all;"><% if (cid == null) {%><input id="positive_button" style="padding-left: 5px; padding-right: 5px;"type="submit" name="submit" value="Save"><%} else {%><input id="positive_button" style="padding-left: 5px; padding-right: 5px;"type="submit" name="submit" value="Update"><%}%></td></tr>
                    </center>
                </form>
                </p>
            </div>
            <br class="spacer" />
            <!--footer end -->
    </body>
    <%
        cid = request.getParameter("cid");
        String name = request.getParameter("name");
        String telephone = request.getParameter("telephone#");
        String action = request.getParameter("submit");
        if (action != null && action.equals("Save")) {
            if (name != null) {
                //query to call procedure to add customer
                try{
                    String callableQuery = "{call rbms.add_customer(?,?,?)}";
                    CallableStatement callableStatement = db.prepareCall(callableQuery);
                    callableStatement.setString(1, cid);
                    callableStatement.setString(2, name);
                    callableStatement.setString(3, telephone);
                    db.executeCallableStatement(callableStatement);
                    response.sendRedirect("customers.jsp?action=add");
                }catch(Exception ex){
                    //out.print("Customer could not be added, Please enter correct data");
                    out.print("Customer could not be added, Customer Id Already Exist");
                    System.out.println("add_customer.jsp-add : "+ex.toString());
                }
            }
        } else if (action != null && action.equals("Update")) {
            //query to update customer data for given cid
            try{
            int result=db.setData("update customers set name='" + name + "', telephone#='" + telephone + "' where cid='" + cid+"'");
            if(result==0){
                out.print("Customer not updated");
                return;
            }
            response.sendRedirect("customers.jsp?action=update");
            }catch(Exception ex){
                out.print("Customer could not be updated, Please enter correct data");
                System.out.println("add_customer.jsp-update : "+ex.toString());
            }
        }
    %>
</html>