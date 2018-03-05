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
        <title>Discounts</title>
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
                            String action=request.getParameter("action");
                            if(action!=null && action.equals("delete")){
                                String discnt_category=request.getParameter("dis_id");
                                try{
                                //query to delete customer data for given cid
                                db.setData("delete from discounts where discnt_category='"+discnt_category+"'");
                                response.sendRedirect("discounts.jsp?action=del");
                                }catch(Exception ex){
                                    out.print("Customer could not be deleted, if it is involved in purchase");
                                    System.out.println("customers.jsp delete : "+ex.toString());
                                }
                            }else if(action!=null && action.equals("add")){
                                out.print("Discount successfully added");
                            }else if(action!=null && action.equals("update")){
                                out.print("Discount successfully updated");
                            }else if(action!=null && action.equals("del")){
                                out.print("Discount successfully deleted");
                            }
            %>
            </div>
                <table>
                    <tr><th>Discount Category</th><th>Discount Rate</th><th>Actions</th></tr>
                    <%
                                                
                        try{//query to get all discount rates
                        String callableQuery = "{call rbms.show_discounts(?)}";
                                CallableStatement callableStatement = db.prepareCall(callableQuery);
                                callableStatement.registerOutParameter(1, OracleTypes.CURSOR);
                                db.executeCallableStatement(callableStatement);
                                ResultSet categories = (ResultSet) callableStatement.getObject(1);
                                    while(categories.next()){
                                %>
                                <tr>
                                <td>
                                    <% String dis_id=categories.getString("discnt_category");
                                    out.print(dis_id); %>
                                </td>
                                <td>
                                    <% out.print(categories.getString("discnt_rate")); %>
                                </td>
                                <td><a href="add_discount.jsp?dis_id=<%out.print(dis_id);%>"><button id="positive_button">Update</button></a>
                                    <!--a href="discounts.jsp?action=delete&dis_id=<%out.print(dis_id);%>"><button id="negative_button">Delete</button></a -->
                                </td>
                                </tr>
                                <%
                            }
                        }catch(Exception ex){
                            System.out.println("discounts.jsp get discounts : "+ex.toString());
                        }
                    %>
                    </table>
                </p>
            </div>
            <br class="spacer" />
            <!--footer end -->
    </body>
</html>
