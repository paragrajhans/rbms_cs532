<%-- 
    Document   : employees
    Created on : Nov 12, 2017, 3:21:06 PM
    Author     : User
--%>
<%@page import="java.sql.CallableStatement"%>
<%@page import="oracle.jdbc.OracleTypes"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="utils.DBHelper"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Employees</title>
        <link href="style.css" rel="stylesheet" type="text/css" />
    </head>
    <body
        <!--body start -->
        <%@include file="header.jsp" %>
        <div id="body">
            <!--left panel start -->
            <div id="left">
                <p class="text2"> 
                    <a href="add_employee.jsp">
                        <button id="positive_button">Add Employee</button>
                    </a>
                <div>
                    <%
                    DBHelper db = new DBHelper();
                    
                    String action = request.getParameter("action");
                
                    if (action != null && action.equals("delete")) {
                        String eid = request.getParameter("emp_id");
                        try{
                        //query to delete employee data for given eid
                        db.setData("delete from employees where eid='" + eid+"'");
                        response.sendRedirect("employees.jsp?action=del");
                        }catch(Exception ex){
                            out.print("Employee could not be deleted, if it is involved in purchase");
                            System.out.println(ex.toString());
                        }
                    }else if(action!=null && action.equals("add")){
                        out.print("Employee successfully added");
                    }else if(action!=null && action.equals("update")){
                        out.print("Employee successfully updated");
                    }else if(action!=null && action.equals("del")){
                        out.print("Employee successfully deleted");
                    }
                    %>
                </div>
                <table>
                    <tr><th>Id</th><th>Name</th><th>Telephone</th><th>Email</th><th>Actions</th></tr>
                            <%
                                
                                try{
                                //query to get all employee data
                                String callableQuery = "{call rbms.show_employees(?)}";
                                CallableStatement callableStatement = db.prepareCall(callableQuery);
                                callableStatement.registerOutParameter(1, OracleTypes.CURSOR);
                                db.executeCallableStatement(callableStatement);
                                ResultSet employees = (ResultSet) callableStatement.getObject(1);
                                while (employees.next()) {
                            %>
                    <tr>
                        <td>
                            <% String eid = employees.getString("EID");
                                        out.print(eid);%>
                        </td>
                        <td>
                            <% out.print(employees.getString("NAME"));%>
                        </td>
                        <td>
                            <% out.print(employees.getString("TELEPHONE#"));%>
                        </td>
                        <td>
                            <% out.print(employees.getString("EMAIL"));%>
                        </td>
                        <td><a href="add_employee.jsp?emp_id=<%out.print(eid);%>"><button id="positive_button">Update</button></a>
                            <a href="employees.jsp?action=delete&emp_id=<%out.print(eid);%>"><button id="negative_button">Delete</button></a>
                            <a href="monthly_sale.jsp?emp_id=<%out.print(eid);%>"><button id="positive_button">Monthly Sale Activity</button></a>
                        </td>
                    </tr>
                    <%
                        }
                                }catch(Exception ex){
                                    System.out.println(ex.toString());
                                }
                    %>
                </table>
                </p>
            </div>
            <br class="spacer" />
            <!--footer end -->
    </body>
</html>
