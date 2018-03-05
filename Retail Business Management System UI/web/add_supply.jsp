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
                        String sup_id=request.getParameter("sup_id");
                        String sid=request.getParameter("sid");
                        String s_pid="",s_quantity="";
                        if(sup_id!=null){
                            try{
                            //query to get all supplied data for given sup#
                            ResultSet rs=db.getData("select * from supplies where sup#="+sup_id);
                            if(rs.next()){
                                s_pid=rs.getString("pid");
                                s_quantity=rs.getString("quantity");
                            }
                            }catch(Exception ex){System.out.println("add_supply.jsp get supply : "+ex.toString());}
                        }
                    %>
                <form method="post">
                    <center>
                    <table class="no_border" style="width:50%">
                        <input type="hidden" name="sup_id" value="<%out.print(sup_id);%>"/>
                        <input type="hidden" name="sid" value="<%out.print(sid);%>"/>
                    <tr><td class="no_border">Product:</td> <td class="no_border"><select name="pid" value="<% out.print(s_pid);%>" required>
                                <% 
                    try{
                                //query to call procedure to get all products
                                String callableQuery = "{call rbms.show_products(?)}";
                                CallableStatement callableStatement = db.prepareCall(callableQuery);
                                callableStatement.registerOutParameter(1, OracleTypes.CURSOR);
                                db.executeCallableStatement(callableStatement);
                                ResultSet categories = (ResultSet) callableStatement.getObject(1);
                                while(categories.next()){%>
                                <option value="<%out.print(categories.getString("pid"));%>" <%if(categories.getString("pid").equals(s_pid)){%>selected <%}%>><%out.print(categories.getString("name"));%></option>
                                <%}
                    }catch(Exception ex){System.out.println("add_supply.jsp get_products : "+ex.toString());}%>
                            </select></tr>
                    <tr><td class="no_border">Quantity:</td> <td class="no_border"><input type="number" name="quantity" value="<% out.print(s_quantity);%>" required></tr>
                    <tr><td class="no_border"></td><td class="no_border" style="column-span: all;"><% if(sup_id==null){%><input id="positive_button" style="padding-left: 5px; padding-right: 5px;"type="submit" name="submit" value="Save"><%}else{%><input id="positive_button" style="padding-left: 5px; padding-right: 5px;"type="submit" name="submit" value="Update"><%}%></td></tr>
                    </center>
                </form>
                </p>
            </div>
            <br class="spacer" />
            <!--footer end -->
    </body>
    <%
        sup_id = request.getParameter("sup_id");
        sid=request.getParameter("sid");
        String quantity=request.getParameter("quantity");
        String pid=request.getParameter("pid");
        String action=request.getParameter("submit");
        if(action!=null && action.equals("Save")){
           if(quantity!=null){
               try{
               //query to save supply data for given sup#
               int result=db.setData("insert into supplies values (sup#.nextval,'"+pid+"','"+sid+"',sysdate,'"+quantity+"')");
               if(result==0){
                   out.print("Supply not added");
                   return;
               }
               response.sendRedirect("supplies.jsp?sid="+sid+"&action=add");
               }catch(Exception ex){
                   out.print("Supply could not be added, Please enter correct data");
                   System.out.println("add_supply.jsp add : "+ex.toString());
               }
           }
        }else if(action!=null && action.equals("Update")){
            try{
            //query to update supply data for given sup#
            int result=db.setData("update supplies set pid='"+pid+"', quantity='"+quantity+"', sdate=sysdate where sup#="+sup_id);
            if(result==0){
                out.print("Supply not updated");
                return;
            }
            response.sendRedirect("supplies.jsp?sid="+sid+"&action=update");
            }catch(Exception ex){
                out.print("Supply could not be updated, Please enter correct data");
                System.out.println("add_supply.jsp update : "+ex.toString());
            }
        }
    %>
</html>
