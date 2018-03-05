<%-- 
    Document   : add_purchase
    Created on : Nov 20, 2017, 6:38:06 PM
    Author     : User
--%>

<%@page import="utils.DBHelper"%>
<%@page import="oracle.jdbc.OracleTypes"%>
<%@page import="java.sql.CallableStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
            DBHelper db = new DBHelper();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add Purchase</title>
        <link href="style.css" rel="stylesheet" type="text/css" />
    </head>
    <body>
        <%@include file="header.jsp" %>
        <div id="body">
            <!--left panel start -->
            <div id="left">
                <p class="text2">  
                    <%
                        String pur_id=request.getParameter("pur_id");
                        String p_eid="",p_pid="",p_cid="",p_qty="";
                        if(pur_id!=null){
                            //query to get purchase data for given pur#
                            try{
                                ResultSet rs=db.getData("select * from purchases where pur#="+pur_id);
                                if(rs.next()){
                                    p_eid=rs.getString("eid");
                                    p_pid=rs.getString("pid");
                                    p_cid=rs.getString("cid");
                                    p_qty=rs.getString("qty");
                                }
                            }catch(Exception ex){System.out.println("add_purchase.sjp get purchases : "+ex.toString());}
                        }
                    %>
                <form method="post">
                    <center>
                    <table class="no_border" style="width:50%">
                        <input type="hidden" name="pur_id" value="<%out.print(pur_id);%>"/>
                        <tr><td class="no_border">Employee:</td> <td class="no_border"><select name="eid" value="<% out.print(p_eid);%>" required>
                                <%
                        try{
                                //query to call procedure to get all employees
                                String employeeQuery = "{call rbms.show_employees(?)}";
                                CallableStatement employeeStatement = db.prepareCall(employeeQuery);
                                employeeStatement.registerOutParameter(1, OracleTypes.CURSOR);
                                db.executeCallableStatement(employeeStatement);
                                ResultSet employees = (ResultSet) employeeStatement.getObject(1);
                                while(employees.next()){%>
                                <option value="<%out.print(employees.getString("eid"));%>" <%if(employees.getString("eid").equals(p_pid)){%>selected <%}%>><%out.print(employees.getString("eid"));%></option>
                                <%}
                        }catch(Exception ex){System.out.println("add_purchase.jsp get employees : "+ex.toString());}%>
                                </select>
                            </td>
                        </tr>
                        <tr><td class="no_border">Product:</td> <td class="no_border"><select name="pid" value="<% out.print(p_pid);%>" required>
                                <%
                        try{
                                //query to call procedure to get all products
                                String productQuery = "{call rbms.show_products(?)}";
                                CallableStatement productStatement = db.prepareCall(productQuery);
                                productStatement.registerOutParameter(1, OracleTypes.CURSOR);
                                db.executeCallableStatement(productStatement);
                                ResultSet products = (ResultSet) productStatement.getObject(1);
                                while(products.next()){%>
                                <option value="<%out.print(products.getString("pid"));%>" <%if(products.getString("pid").equals(p_pid)){%>selected <%}%>><%out.print(products.getString("name"));%></option>
                                <%}
                        }catch(Exception ex){System.out.println("add_purchase.jsp get products : "+ex.toString());}%>
                                </select>
                            </td>
                        </tr>
                        <tr><td class="no_border">Customer:</td> <td class="no_border"><select name="cid" value="<% out.print(p_cid);%>" required>
                                <% 
                        try{
                                //query to call procedure to get all customers    
                                String customerQuery = "{call rbms.show_customers(?)}";
                                CallableStatement customerStatement = db.prepareCall(customerQuery);
                                customerStatement.registerOutParameter(1, OracleTypes.CURSOR);
                                db.executeCallableStatement(customerStatement);
                                ResultSet customers = (ResultSet) customerStatement.getObject(1);
                                while(customers.next()){%>
                                <option value="<%out.print(customers.getString("cid"));%>" <%if(customers.getString("cid").equals(p_cid)){%>selected <%}%>><%out.print(customers.getString("cid"));%></option>
                                <%}
                        }catch(Exception ex){System.out.println("add_purchase.jsp get customers : "+ex.toString());}%>
                                </select>
                            </td>
                        </tr>
                    <tr><td class="no_border">Quantity:</td> <td class="no_border"><input type="number" name="quantity" value="<% out.print(p_qty);%>" required></tr>
                    <tr><td class="no_border"></td><td class="no_border" style="column-span: all;"><% if(pur_id==null){%><input id="positive_button" style="padding-left: 5px; padding-right: 5px;"type="submit" name="submit" value="Save"><%}else{%><input id="positive_button" style="padding-left: 5px; padding-right: 5px;"type="submit" name="submit" value="Update"><%}%></td></tr>
                    </center>
                </form>
                </p>
            </div>
            <br class="spacer" />
            <!--footer end -->
    </body>
    <%
        pur_id = request.getParameter("pur_id");
        String eid=request.getParameter("eid");
        String pid=request.getParameter("pid");
        String cid=request.getParameter("cid");
        String qty=request.getParameter("quantity");
        String action=request.getParameter("submit");
        if(action!=null && action.equals("Save")){
           if(qty!=null){
               try{
               //query to call procedure to add new purchase
                String callableQuery = "{call rbms.add_purchase(?,?,?,?)}";
                CallableStatement callableStatement = db.prepareCall(callableQuery);
                callableStatement.setString(1, eid);
                callableStatement.setString(2, pid);
                callableStatement.setString(3, cid);
                callableStatement.setString(4, qty);
                int result=db.executeCallableStatement(callableStatement);
                /*if(result==0){
                    out.print("Insufficient quantity in stock");
                    return;
                }*/
                response.sendRedirect("purchases.jsp?action=add");
               }catch(Exception ex){
                   out.print("Insufficient quantity in stock.<br>");
                   out.print("Purchase did not added, please enter valid quantity");
                   System.out.println("add_purchase.jsp add : "+ex.toString());
               }
           }
        }
    %>
</html>