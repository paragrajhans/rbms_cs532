<%-- 
    Document   : Products
    Created on : Nov 12, 2017, 3:14:05 PM
    Author     : User
--%>

<%@page import="oracle.jdbc.OracleTypes"%>
<%@page import="java.sql.CallableStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="utils.DBHelper"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Products</title>
        <link href="style.css" rel="stylesheet" type="text/css" />
    </head>
    <body
    <!--body start -->
    <%@include file="header.jsp" %>
        <div id="body">
            <!--left panel start -->
            <div id="left">
                <p class="text2"> 
                    <a href="add_product.jsp">
                        <button id="positive_button">Add Product</button>
                    </a>
                <div>
                    <%
                        DBHelper db = new DBHelper();
                        String action = request.getParameter("action");
                        
                        if (action != null && action.equals("delete")) {
                            String pid = request.getParameter("pro_id");
                            try{
                            //query to delete product data for given pid
                            int result=db.setData("delete from products where pid='" + pid+"'");
                            response.sendRedirect("products.jsp?action=del");
                            }catch(Exception ex){
                                out.print("Product could not be deleted, if it is involved in Purchase or Supply");
                                System.out.println("products.jsp delete : "+ex.toString());
                            }
                        }else if(action!=null && action.equals("add")){
                            out.print("Product successfully added");
                        }else if(action!=null && action.equals("update")){
                            out.print("Product successfully updated");
                        }else if(action!=null && action.equals("del")){
                            out.print("Product successfully deleted");
                        }
                    %>
                </div>
                <table>
                    <tr><th>Id</th><th>Name</th><th>QOH</th><th>QOH THRESHOLD</th><th>ORIGINAL PRICE</th><th>DISCOUNT</th><th>Actions</th></tr>
                            <%
                                
                                try{
                                //query to call procedure to get all products
                                String callableQuery = "{call rbms.show_products(?)}";
                                CallableStatement callableStatement = db.prepareCall(callableQuery);
                                callableStatement.registerOutParameter(1, OracleTypes.CURSOR);
                                db.executeCallableStatement(callableStatement);
                                ResultSet products = (ResultSet) callableStatement.getObject(1);
                                while (products.next()) {
                            %>
                    <tr>
                        <td>
                            <% String pid = products.getString("PID");
                                        out.print(pid);%>
                        </td>
                        <td>
                            <% out.print(products.getString("NAME"));%>
                        </td>
                        <td>
                            <% out.print(products.getString("QOH"));%>
                        </td>
                        <td>
                            <% out.print(products.getString("QOH_THRESHOLD"));%>
                        </td>
                        <td>
                            <% out.print(products.getString("ORIGINAL_PRICE"));%>
                        </td>
                        <td>
                            <% out.print(products.getString("DISCNT_RATE"));%>
                        </td>
                        <td><a href="add_product.jsp?pro_id=<%out.print(pid);%>"><button id="positive_button">Update</button></a>
                            <a href="products.jsp?action=delete&pro_id=<%out.print(pid);%>"><button id="negative_button">Delete</button></a>
                        </td>
                    </tr>
                    <%
                        }
                                }catch(Exception ex){
                                System.out.println("products.jsp get products : "+ex.toString());
                                }
                    %>
                </table>
                </p>
            </div>
            <br class="spacer" />
            <!--footer end -->
    </body>
</html>