<%-- 
    Document   : suppliers
    Created on : Nov 14, 2017, 1:26:34 AM
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
        <title>Suppliers</title>
        <link href="style.css" rel="stylesheet" type="text/css" />
    </head>
    <body>
        <!--body start -->
        <%@include file="header.jsp" %>
        <div id="body">
            <!--left panel start -->
            <div id="left">
                <p class="text2"> 
                    <a href="add_supplier.jsp">
                        <button id="positive_button">Add Supplier</button>
                    </a>
                <div>
                    <%
                    DBHelper db = new DBHelper();
                    String action = request.getParameter("action");
                    if (action != null && action.equals("delete")) {
                        String sid = request.getParameter("sup_id");
                        try{
                        //query to delete supplier data for given sid
                        db.setData("delete from suppliers where sid='" + sid+"'");
                        response.sendRedirect("suppliers.jsp?action=del");
                        }catch(Exception ex){
                        out.print("Supplier could not be deleted if is supplying a product");
                        System.out.println("suppliers.jsp delete : "+ex.toString());
                        }
                    }else if(action!=null && action.equals("add")){
                        out.print("Supplier successfully added");
                    }else if(action!=null && action.equals("update")){
                        out.print("Supplier successfully updated");
                    }else if(action!=null && action.equals("del")){
                        out.print("Supplier successfully deleted");
                    }
                    %>
                </div>
                <table>
                    <tr><th>Id</th><th>Name</th><th>City</th><th>Telephone</th><th>Email</th><th>Actions</th></tr>
                            <%
                                
                                try{
                                //query to call procedure to get all supplier data
                                String callableQuery = "{call rbms.show_suppliers(?)}";
                                CallableStatement callableStatement = db.prepareCall(callableQuery);
                                callableStatement.registerOutParameter(1, OracleTypes.CURSOR);
                                db.executeCallableStatement(callableStatement);
                                ResultSet suppliers = (ResultSet) callableStatement.getObject(1);
                                while (suppliers.next()) {
                            %>
                    <tr>
                        <td>
                            <% String sid = suppliers.getString("SID");
                                        out.print(sid);%>
                        </td>
                        <td>
                            <% out.print(suppliers.getString("NAME"));%>
                        </td>
                        <td>
                            <% out.print(suppliers.getString("CITY"));%>
                        </td>
                        <td>
                            <% out.print(suppliers.getString("TELEPHONE#"));%>
                        </td>
                        <td>
                            <% out.print(suppliers.getString("EMAIL"));%>
                        </td>
                        <td><a href="add_supplier.jsp?sup_id=<%out.print(sid);%>"><button id="positive_button">Update</button></a>
                            <a href="suppliers.jsp?action=delete&sup_id=<%out.print(sid);%>"><button id="negative_button">Delete</button></a>
                            <a href="supplies.jsp?sid=<%out.print(sid);%>"><button id="positive_button">Supply</button></a>
                        </td>
                    </tr>
                    <%
                        }
                                }catch(Exception ex){
                                System.out.println("suppliers.jsp get suppliers : "+ex.toString());
                                }
                    %>
                </table>
                </p>
            </div>
            <br class="spacer" />
            <!--footer end -->
    </body>
</html>
