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
        <title>Logs</title>
        <link href="style.css" rel="stylesheet" type="text/css" />
    </head>
    <body>
        <%@include file="header.jsp" %>
    <div id="body">
            <!--left panel start -->
            <div id="left">
                <p class="text2"> 
                    <!--a href="add_discount.jsp">
                    <button id="positive_button">Add Discount</button>
                    </a -->
                <div>
<%
                            DBHelper db = new DBHelper();
                            
            %>
            </div>
                <table>
                    <tr><th>Log#</th><th>Username</th><th>Operation</th><th>Operation Time</th><th>Table Name</th><th>Key</th></tr>
                    <%
                                                
                        try{//query to get all logs
                        String callableQuery = "select * from logs";
                                ResultSet logs = (ResultSet) db.getData(callableQuery);
                                    while(logs.next()){
                                %>
                                <tr>
                                <td>
                                    <% 
                                    out.print(logs.getString("log#")); %>
                                </td>
                               <td>
                                    <% 
                                    out.print(logs.getString("user_name")); %>
                                </td>
                               
                                <td>
                                    <% 
                                    out.print(logs.getString("operation")); %>
                                </td>
                               <td>
                                    <% 
                                    out.print(logs.getString("op_time")); %>
                                </td>
                               <td>
                                    <% 
                                    out.print(logs.getString("table_name")); %>
                                </td>
                               <td>
                                    <% 
                                    out.print(logs.getString("tuple_pkey")); %>
                                </td>
                               
                                </tr>
                                <%
                            }
                        }catch(Exception ex){
                            System.out.println("logs.jsp get logs : "+ex.toString());
                        }
                    %>
                    </table>
                </p>
            </div>
            <br class="spacer" />
            <!--footer end -->
    </body>
</html>
