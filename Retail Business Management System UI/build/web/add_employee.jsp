<%-- 
    Document   : add_employee
    Created on : Nov 12, 2017, 5:07:41 PM
    Author     : User
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="utils.DBHelper"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
            DBHelper db = new DBHelper();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add/Update Employee</title>
        <link href="style.css" rel="stylesheet" type="text/css" />
    </head>
    <body>
        <!--body start -->
    <%@include file="header.jsp" %>
        <div id="body">
            <!--left panel start -->
            <div id="left">
                <p class="text2">  
                    <%
                        String eid=request.getParameter("emp_id");
                        String e_name="",e_tel="",e_email="";
                        if(eid!=null){
                            //query to get employee data for given eid
                            try{
                                ResultSet rs=db.getData("select * from employees where eid='"+eid+"'");
                                if(rs.next()){
                                    e_name=rs.getString("name");
                                    e_tel=rs.getString("telephone#");
                                    e_email=rs.getString("email");
                                    System.out.print(e_name);
                                }
                            }catch(Exception ex){System.out.println("add_employee.jsp get employee : "+ex.toString());}
                        }
                    %>
                <form method="post">
                    <center>
                    <table class="no_border" style="width:50%">
                    <tr><td class="no_border">Eid:</td> <td class="no_border"><input type="text" name="eid" value="<% if (eid != null) {
                        out.print(eid);
                    }%>" required></td></tr>
                    <tr><td class="no_border">Name:</td> <td class="no_border"><input type="text" name="name" value="<% out.print(e_name);%>" required></td></tr>
                    <tr><td class="no_border">Telephone:</td> <td class="no_border"><input type="text" name="telephone#" value="<% out.print(e_tel);%>" required></tr>
                    <tr><td class="no_border">Email:</td> <td class="no_border"><input type="email" name="email" value="<% out.print(e_email);%>" required></tr>
                    <tr><td class="no_border"></td><td class="no_border" style="column-span: all;"><% if(eid==null){%><input id="positive_button" style="padding-left: 5px; padding-right: 5px;"type="submit" name="submit" value="Save"><%}else{%><input id="positive_button" style="padding-left: 5px; padding-right: 5px;"type="submit" name="submit" value="Update"><%}%></td></tr>
                    </center>
                </form>
                </p>
            </div>
            <br class="spacer" />
            <!--footer end -->
    </body>
    <%
        eid = request.getParameter("eid");           
        String name=request.getParameter("name");
        String telephone=request.getParameter("telephone#");
        String email=request.getParameter("email");
        String action=request.getParameter("submit");
        if(action!=null && action.equals("Save")){
           if(name!=null){
               //query to add employee data
               try{
                    int result=db.setData("insert into employees (eid, name, telephone#, email) values ('"+eid+"','"+name+"','"+telephone+"','"+email+"')");
                    if(result==0){
                        out.print("Employee not added, please check all input fields");
                    }
                    response.sendRedirect("employees.jsp?action=add");
               }catch(Exception ex){
                   out.print("Employee could not be added, please enter correct data");
                   System.out.println("add_employee.jsp add : "+ex.toString());
               }
           }
        }else if(action!=null && action.equals("Update")){
            //query to update employee data for given eid
            try{
                int result=db.setData("update employees set name='"+name+"', telephone#='"+telephone+"', email='"+email+"' where eid='"+eid+"'");
                if(result==0){
                    out.print("Employee not updated");
                    return;
                }
                response.sendRedirect("employees.jsp?action=update");
            }catch(Exception ex){
                out.print("Emplyee could not be updated, please enter correct data");
                System.out.println("add_employee.jsp update : "+ex.toString());
            }
        }
    %>
</html>