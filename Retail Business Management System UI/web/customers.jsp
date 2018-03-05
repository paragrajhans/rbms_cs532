<%-- 
    Document   : customers
    Created on : Nov 12, 2017, 3:19:30 PM
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
        <title>Customers</title>
        <link href="style.css" rel="stylesheet" type="text/css" />
    </head>
    <body>
        <%@include file="header.jsp" %>
    <div id="body">
            <!--left panel start -->
            <div id="left">
                <p class="text2"> 
                    <a href="add_customer.jsp">
                    <button id="positive_button">Add Customer</button>
                    </a>
                <div>
<%
                            DBHelper db = new DBHelper();
                            String action=request.getParameter("action");
                            if(action!=null && action.equals("delete")){
                                String cid=request.getParameter("cus_id");
                                try{
                                //query to delete customer data for given cid
                                db.setData("delete from customers where cid='"+cid+"'");
                                response.sendRedirect("customers.jsp?action=del");
                                }catch(Exception ex){
                                    out.print("Customer could not be deleted, if it is involved in purchase");
                                    System.out.println("customers.jsp delete : "+ex.toString());
                                }
                            }else if(action!=null && action.equals("add")){
                                out.print("Customer successfully added");
                            }else if(action!=null && action.equals("update")){
                                out.print("Customer successfully updated");
                            }else if(action!=null && action.equals("del")){
                                out.print("Customer successfully deleted");
                            }
            %>
            </div>
                <table>
                    <tr><th>Id</th><th>Name</th><th>Telephone</th><th>Visits</th><th>Last Visit</th><th>Actions</th></tr>
                    <%
                                                
                        try{//query to get all customers data
                        String callableQuery = "{call rbms.show_customers(?)}";
			CallableStatement callableStatement = db.prepareCall(callableQuery);
			callableStatement.registerOutParameter(1, OracleTypes.CURSOR);
			db.executeCallableStatement(callableStatement);
			ResultSet customers = (ResultSet) callableStatement.getObject(1);
                            while(customers.next()){
                                %>
                                <tr>
                                <td>
                                    <% String cid=customers.getString("CID");
                                    out.print(cid); %>
                                </td>
                                <td>
                                    <% out.print(customers.getString("NAME")); %>
                                </td>
                                <td>
                                    <% out.print(customers.getString("TELEPHONE#")); %>
                                </td>
                                <td>
                                    <% String visits=customers.getString("VISITS_MADE");
                                    if(visits!=null && !visits.equals("null")){
                                        out.print(visits);
                                    } %>
                                </td>
                                <td>
                                    <% String last_visit_date=customers.getString("LAST_VISIT_DATE");
                                    if(last_visit_date!=null && !last_visit_date.equals("null")){
                                        out.print(last_visit_date);
                                    } %>
                                </td>
                                <td><a href="add_customer.jsp?cus_id=<%out.print(cid);%>"><button id="positive_button">Update</button></a>
                                    <a href="customers.jsp?action=delete&cus_id=<%out.print(cid);%>"><button id="negative_button">Delete</button></a>
                                </td>
                                </tr>
                                <%
                            }
                        }catch(Exception ex){
                            System.out.println("customers.jsp get customers : "+ex.toString());
                        }
                    %>
                    </table>
                </p>
            </div>
            <br class="spacer" />
            
            <script>
                function deletePurchase(pur) {
                    if (confirm("Are you sure to delete!"+cid) == true) {
                        window.location="customers.jsp?action=delete&cus_id="+cid;
                    }
                }
            </script>

            <!--footer end -->
    </body>
</html>
