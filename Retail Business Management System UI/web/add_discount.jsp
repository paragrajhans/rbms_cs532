<%-- 
    Document   : add_supply
    Created on : Nov 17, 2017, 1:41:09 AM
    Author     : User
--%>

<%@page import="oracle.jdbc.OracleTypes"%>
<%@page import="java.sql.CallableStatement"%>
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
        <title>Add/Update Supply</title>
        <link href="style.css" rel="stylesheet" type="text/css" />
    </head>
    <body>
        <%@include file="header.jsp" %>
        <div id="body">
            <!--left panel start -->
            <div id="left">
                <p class="text2">  
                    <%
                        String dis_id=request.getParameter("dis_id");
                        String dis_rate="";
                        if(dis_id!=null){
                            try{
                            //query to get all supplied data for given sup#
                            ResultSet rs=db.getData("select * from discounts where discnt_category="+dis_id);
                            if(rs.next()){
                               dis_rate=rs.getString("discnt_rate");
                            }
                            }catch(Exception ex){System.out.println("add_discount.jsp get discount : "+ex.toString());}
                        }
                    %>
                <form method="post">
                    <center>
                    <table class="no_border" style="width:50%">
                        <tr><td class="no_border">Discount Category Id:</td><td class="no_border"><%out.print(dis_id);%></td></tr>
                    <tr><td class="no_border">Discount Rate:</td> <td class="no_border"><input type="text" name="dis_rate" value="<% out.print(dis_rate);%>" required></tr>
                    <tr><td class="no_border"></td><td class="no_border" style="column-span: all;"><% if(dis_id==null){%><input id="positive_button" style="padding-left: 5px; padding-right: 5px;"type="submit" name="submit" value="Save"><%}else{%><input id="positive_button" style="padding-left: 5px; padding-right: 5px;"type="submit" name="submit" value="Update"><%}%></td></tr>
                    </center>
                </form>
                </p>
            </div>
            <br class="spacer" />
            <!--footer end -->
    </body>
    <%
        dis_id = request.getParameter("dis_id");
        String discnt_rate=request.getParameter("dis_rate");
        String action=request.getParameter("submit");
        if(action!=null && action.equals("Save")){
           if(dis_id!=null){
               try{
               //query to save discount rate
               int result=db.setData("insert into discounts values ("+dis_id+","+discnt_rate+")");
               if(result==0){
                   out.print("Discount not added");
                   return;
               }
               response.sendRedirect("discounts.jsp?action=add");
               }catch(Exception ex){
                   out.print("Discount could not be added, Please enter correct data");
                   System.out.println("add_discount.jsp add : "+ex.toString());
               }
           }
        }else if(action!=null && action.equals("Update")){
            try{
            //query to update discount data for given discount category
            int result=db.setData("update discounts set discnt_rate="+discnt_rate+" where discnt_category="+dis_id);
            if(result==0){
                out.print("Discount not updated");
                return;
            }
            response.sendRedirect("discounts.jsp?&action=update");
            }catch(Exception ex){
                out.print("Discount could not be updated, Please enter correct data");
                System.out.println("add_discount.jsp update : "+ex.toString());
            }
        }
    %>
</html>
