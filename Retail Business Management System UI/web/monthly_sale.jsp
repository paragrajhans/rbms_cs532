<%-- 
    Document   : monthly_sale
    Created on : Nov 23, 2017, 1:23:59 AM
    Author     : User
--%>

<%@page import="oracle.jdbc.OracleTypes"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.CallableStatement"%>
<%@page import="utils.DBHelper"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Monthly Sale Activity</title>
        <link href="style.css" rel="stylesheet" type="text/css" />
    </head>
    <body>
        <%@include file="header.jsp" %>
    <div id="body">
            <!--left panel start -->
            <div id="left">
                <p class="text2"> 
                    <a href="add_purchase.jsp">
                        <button id="positive_button">Add Purchase</button>
                    </a>
                <table>
                    <tr><th>EID</th><th>EMPLOYEE NAME</th><th>MONTH YEAR</th><th>SALES COUNT</th><th>TOTAL SOLD QUANTITY</th><th>TOTAL AMOUNT</th></tr>
                            <%
                                String emp_id=request.getParameter("emp_id");
                                DBHelper db = new DBHelper();
                                try{
                                //query to call procedure to get monthly sale for given eid
                                String callableQuery = "{call rbms.monthly_sale_activities(?,?)}";
                                CallableStatement callableStatement = db.prepareCall(callableQuery);
                                callableStatement.setString(1, emp_id);
                                callableStatement.registerOutParameter(2, OracleTypes.CURSOR);
                                db.executeCallableStatement(callableStatement);
                                ResultSet purchases = (ResultSet) callableStatement.getObject(2);
                                while (purchases.next()) {
                            %>
                    <tr>
                        <td>
                            <% String pur = purchases.getString("EID");
                                        out.print(pur);%>
                        </td>
                        <td>
                            <% out.print(purchases.getString("NAME"));%>
                        </td>
                        <td>
                            <% out.print(purchases.getString("PTIME"));%>
                        </td>
                        <td>
                            <% out.print(purchases.getString("TOTAL_SALES"));%>
                        </td>
                        <td>
                            <% out.print(purchases.getString("TOTAL_QTY_SALE"));%>
                        </td>
                        <td>
                            <% out.print(purchases.getString("TOTAL_SALE_PRICE"));%>
                        </td>
                    </tr>
                    <%
                        }
                                }catch(Exception ex){System.out.println("monthly sale.sjp get sales : "+ex.toString());}
                    %>
                </table>
                </p>
            </div>
            <br class="spacer" />
            <!--footer end -->
    </body>
</html>