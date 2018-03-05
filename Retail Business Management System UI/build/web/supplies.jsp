<%-- 
    Document   : Supplies
    Created on : Nov 17, 2017, 1:16:15 AM
    Author     : User
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
                    <%
                        String sid=request.getParameter("sid");
                    %>
                    <a href="add_supply.jsp?sid=<%out.print(sid);%>">
                        <button id="positive_button">Add Supply</button>
                    </a>
                <div>
                    <%
                    DBHelper db = new DBHelper();
                    String action = request.getParameter("action");
                    
                    sid=request.getParameter("sid");
                    if (action != null && action.equals("delete")) {
                        String sup = request.getParameter("sup_id");
                        try{
                        //query to delete supply data for given sup#
                        db.setData("delete from supplies where sup#=" + sup);
                        response.sendRedirect("supplies.jsp?sid="+sid+"&action=del");
                        }catch(Exception ex){
                        out.print("Supply could not be deleted");
                        System.out.println("supplies.jsp - delete: "+ex.toString());
                        }
                    }else if(action!=null && action.equals("add")){
                        out.print("Supply successfully added");
                    }else if(action!=null && action.equals("update")){
                        out.print("Supply successfully updated");
                    }else if(action!=null && action.equals("del")){
                        out.print("Supply successfully deleted");
                    }
                    %>
                    
                </div>
                <table>
                    <tr><th>Sup</th><th>Product</th><th>Last Supplied Date</th><th>Quantity</th><th>Actions</th></tr>
                            <%
                                
                                try{
                                //query to call procedure to get all supplied data for given sid
                                String callableQuery = "{call rbms.show_supplies(?,?)}";
                                CallableStatement callableStatement = db.prepareCall(callableQuery);
                                callableStatement.setString(1, sid);
                                callableStatement.registerOutParameter(2, OracleTypes.CURSOR);
                                db.executeCallableStatement(callableStatement);
                                ResultSet suppliers = (ResultSet) callableStatement.getObject(2);
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
                            <% out.print(suppliers.getString("SDATE"));%>
                        </td>
                        <td>
                            <% out.print(suppliers.getString("QUANTITY"));%>
                        </td>
                        <td><a href="add_supply.jsp?sup_id=<%out.print(sup);%>&sid=<%out.print(sid);%>"><button id="positive_button">Update</button></a>
                            <a href="supplies.jsp?action=delete&sup_id=<%out.print(sup);%>&sid=<%out.print(sid);%>"><button id="negative_button">Delete</button></a>
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
