<%-- 
    Document   : purchases
    Created on : Nov 12, 2017, 3:19:40 PM
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
        <title>Purchases</title>
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
                <div>
                    <%
                    DBHelper db = new DBHelper();
                    String action = request.getParameter("action");
                    String pur_id = request.getParameter("pur_id");
                    if (action != null && action.equals("delete")) {
                        try{
                            //query to delete purchase data for given pur#
                            String deleteQuery = "{call rbms.delete_purchase(?)}";
                            CallableStatement deleteStatement = db.prepareCall(deleteQuery);
                            deleteStatement.setString(1, pur_id);
                            db.executeCallableStatement(deleteStatement);
                            response.sendRedirect("purchases.jsp?action=del");
                        }catch(Exception ex){
                            out.print("Purchase could not be deleted");
                            System.out.println("purchases.jsp delete purchase : "+ex.toString());
                        }
                    }else if(action!=null && action.equals("add")){
                        out.print("Purchase successfully added");
                    }else if(action!=null && action.equals("del")){
                        out.print("Purchase successfully deleted");
                    }
                    %>
                </div>
                <table>
                    <tr><th>PUR#</th><th>PURCHASE DATE</th><th>EMPLOYEE</th><th>PRODUCT</th><th>CUSTOMER</th><th>ORIGINAL PRICE</th><th>QUANTITY</th><th>TOTAL PRICE</th><th>TOTAL SAVING</th><th>Actions</th></tr>
                            <%
                                
                                try{
                                //query to call procedure to get all purchases
                                String callableQuery = "{call rbms.show_purchases(?)}";
                                CallableStatement callableStatement = db.prepareCall(callableQuery);
                                callableStatement.registerOutParameter(1, OracleTypes.CURSOR);
                                db.executeCallableStatement(callableStatement);
                                ResultSet purchases = (ResultSet) callableStatement.getObject(1);
                                while (purchases.next()) {
                            %>
                    <tr>
                        <td>
                            <% String pur = purchases.getString("PUR#");
                                        out.print(pur);%>
                        </td>
                        <td>
                            <% out.print(purchases.getString("PTIME"));%>
                        </td>
                        <td>
                            <% out.print(purchases.getString("EMPLOYEE_NAME"));%>
                        </td>
                        <td>
                            <% out.print(purchases.getString("PRODUCT_NAME"));%>
                        </td>
                        <td>
                            <% out.print(purchases.getString("CUSTOMER_NAME"));%>
                        </td>
                        <td>
                            <% out.print(purchases.getString("ORIGINAL_PRICE"));%>
                        </td>
                        <td>
                            <% out.print(purchases.getString("QTY"));%>
                        </td>
                        <td>
                            <% out.print(purchases.getString("TOTAL_PRICE"));%>
                        </td>
                        <td>
                            <%
                            //query to call function to get total saving for given pur#
                            ResultSet savings=db.getData("select rbms.purchase_saving("+pur+") from dual");
                            if(savings.next()){
                                out.println(savings.getString(1));
                            }else{
                                out.println("0");
                            }
                        %>
                        </td>
                        <td>
                            <button id="negative_button" onClick=deletePurchase(<%out.print(pur);%>)>Delete</button>
                        </td>
                    </tr>
                    <%
                        }
                                }catch(Exception ex){System.out.println("purchases.jsp get purchases : "+ex.toString());}
                    %>
                </table>
                </p>
            </div>
            <br class="spacer" />
            <script>
                function deletePurchase(pur) {
                    if (confirm("Are you sure to delete!") == true) {
                        window.location="purchases.jsp?action=delete&pur_id="+pur;
                    }
                }
            </script>
            <!--footer end -->
    </body>
</html>
