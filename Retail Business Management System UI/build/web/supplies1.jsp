<%-- 
    Document   : discounts.jsp
    Created on : Dec 2, 2017, 12:15:55 AM
    Author     : Dhananjay Jakhadi
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="oracle.jdbc.OracleTypes"%>
<%@page import="java.sql.CallableStatement"%>
<%@page import="utils.DBHelper"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Supplies</title>
        <link href="style.css" rel="stylesheet" type="text/css" />
    </head>
    <body>
        <%@include file="header.jsp" %>
        <div id="body">
            <!--left panel start -->
            <div id="left">
                <p class="text2"> 
                                  <div>
                    <%
                    DBHelper db = new DBHelper();
                    
                    %>
                    
                </div>
                <table>
                    <tr><th>Sup</th><th>Product</th><th>Supplier</th><th>Last Supplied Date</th><th>Quantity</th></tr>
                            <%
                                
                                try{
                                //query to call procedure to get all supplied data
                                String callableQuery = "select sup#,supplies.pid,products.name as product,supplies.sid,suppliers.name as supplier, sdate,quantity from supplies,products,suppliers where supplies.pid=products.pid and supplies.sid=suppliers.sid";
                                ResultSet suppliers = db.getData(callableQuery);
                                while (suppliers.next()) {
                            %>
                    <tr>
                        <td>
                            <% String sup = suppliers.getString("SUP#");
                                        out.print(sup);%>
                        </td>
                        <td>
                            <% out.print(suppliers.getString("PRODUCT"));%>
                        </td>
                        <td>
                            <% out.print(suppliers.getString("SUPPLIER"));%>
                        </td>
                        <td>
                            <% out.print(suppliers.getString("SDATE"));%>
                        </td>
                        <td>
                            <% out.print(suppliers.getString("QUANTITY"));%>
                        </td>
                        
                    </tr>
                    <%
                        }
                                }catch(Exception ex){
                                System.out.println("supplies.jsp getdata: "+ex.toString());
                                }
                    %>
                </table>
                </p>
            </div>
            <br class="spacer" />
            <!--footer end -->
    </body>
</html>
