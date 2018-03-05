<%-- 
    Document   : add_supplier
    Created on : Nov 17, 2017, 12:52:22 AM
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
        <title>Add/Update Supplier</title>
        <link href="style.css" rel="stylesheet" type="text/css" />
    </head>
    <body>
        <%@include file="header.jsp" %>
        <div id="body">
            <!--left panel start -->
            <div id="left">
                <p class="text2">  
                    <%
                        String sid=request.getParameter("sup_id");
                        String s_name="",s_city="",s_tel="",s_email="";
                        if(sid!=null){
                            try{
                            //query to get supplier data for given sid
                            ResultSet rs=db.getData("select * from suppliers where sid='"+sid+"'");
                            if(rs.next()){
                                s_name=rs.getString("name");
                                s_city=rs.getString("city");
                                s_tel=rs.getString("telephone#");
                                s_email=rs.getString("email");
                            }
                            }catch(Exception ex){
                            System.out.println("add_supplier.jsp get suppliers : "+ex.toString());
                            }
                        }
                    %>
                <form method="post">
                    <center>
                    <table class="no_border" style="width:50%">
                    <tr><td class="no_border">Sid:</td> <td class="no_border"><input type="text" name="sid" value="<% if (sid != null) {
                        out.print(sid);
                    }%>" required></td></tr>
                    <tr><td class="no_border">Name:</td> <td class="no_border"><input type="text" name="name" value="<% out.print(s_name);%>" required></td></tr>
                    <tr><td class="no_border">City:</td> <td class="no_border"><input type="text" name="city" value="<% out.print(s_city);%>" required></td></tr>
                    <tr><td class="no_border">Telephone:</td> <td class="no_border"><input type="text" name="telephone#" value="<% out.print(s_tel);%>" required></tr>
                    <tr><td class="no_border">Email:</td> <td class="no_border"><input type="email" name="email" value="<% out.print(s_email);%>" required></tr>
                    <tr><td class="no_border"></td><td class="no_border" style="column-span: all;"><% if(sid==null){%><input id="positive_button" style="padding-left: 5px; padding-right: 5px;"type="submit" name="submit" value="Save"><%}else{%><input id="positive_button" style="padding-left: 5px; padding-right: 5px;"type="submit" name="submit" value="Update"><%}%></td></tr>
                    </center>
                </form>
                </p>
            </div>
            <br class="spacer" />
            <!--footer end -->
    </body>
    <%
        sid = request.getParameter("sid");           
        String name=request.getParameter("name");
        String city=request.getParameter("city");
        String telephone=request.getParameter("telephone#");
        String email=request.getParameter("email");
        String action=request.getParameter("submit");
        if(action!=null && action.equals("Save")){
           if(name!=null){
               try{
               //query to add supplier data
               int result=db.setData("insert into suppliers (sid, name, city, telephone#, email) values ('"+sid+"','"+name+"','"+city+"','"+telephone+"','"+email+"')");
               if(result==0){
                   out.print("Supplier not added");
                   return;
               }
               response.sendRedirect("suppliers.jsp?action=add");
               }catch(Exception ex){
                   out.print("Supplier could not be add, Please enter correct data");
                   System.out.println("add_supplier.jsp add : "+ex.toString());
               }
           }
        }else if(action!=null && action.equals("Update")){
            try{
            //query to update supplier data for given sid
            int result=db.setData("update suppliers set name='"+name+"', city='"+city+"', telephone#='"+telephone+"', email='"+email+"' where sid='"+sid+"'");
            if(result==0){
                out.print("Supplier not updated");
                return;
            }
            response.sendRedirect("suppliers.jsp?action=update");
            }catch(Exception ex){
                out.print("Supplier could not be updated, Please enter correct data");
                System.out.println("add_supplier.jsp update : "+ex.toString());
            }
        }
    %>
</html>
