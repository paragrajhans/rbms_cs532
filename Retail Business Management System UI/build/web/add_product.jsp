<%-- 
    Document   : add_product
    Created on : Nov 16, 2017, 1:02:35 AM
    Author     : User
--%>

<%@page import="java.sql.CallableStatement"%>
<%@page import="oracle.jdbc.OracleTypes"%>
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
        <title>Add/Update Product</title>
        <link href="style.css" rel="stylesheet" type="text/css" />
    </head>
    <body>
        <%@include file="header.jsp" %>
        <div id="body">
            <!--left panel start -->
            <div id="left">
                <p class="text2">  
                    <%
                        String pid=request.getParameter("pro_id");
                        String p_name="",p_qoh="",p_qoh_threshold="",p_original_price="",p_discount_category="";
                        if(pid!=null){
                            //query to get product data for given pid
                            try{
                                ResultSet rs=db.getData("select * from products where pid='"+pid+"'");
                                if(rs.next()){
                                    p_name=rs.getString("name");
                                    p_qoh=rs.getString("qoh");
                                    p_qoh_threshold=rs.getString("qoh_threshold");
                                    p_original_price=rs.getString("original_price");
                                    p_discount_category=rs.getString("discnt_category");
                                }
                            }catch(Exception ex){
                            System.out.println("add_product.jsp get product : "+ex.toString());
                            }
                        }
                    %>
                <form method="post">
                    <center>
                    <table class="no_border" style="width:50%">
                    <tr><td class="no_border">Pid:</td> <td class="no_border"><input type="text" name="pid" value="<% if (pid != null) {
                        out.print(pid);
                    }%>" required></td></tr>
                    <tr><td class="no_border">Name:</td> <td class="no_border"><input type="text" name="name" value="<% out.print(p_name);%>" required></td></tr>
                    <tr><td class="no_border">QOH:</td> <td class="no_border"><input type="number" name="qoh" value="<% out.print(p_qoh);%>" required></tr>
                    <tr><td class="no_border">QOH Threshold:</td> <td class="no_border"><input type="number" name="qoh_threshold" value="<% out.print(p_qoh_threshold);%>" required></tr>
                    <tr><td class="no_border">Original Price:</td> <td class="no_border"><input type="number" name="original_price" value="<% out.print(p_original_price);%>" required></tr>
                    <tr><td class="no_border">Discount:</td> <td class="no_border"><select name="discount_category" value="<% out.print(p_discount_category);%>" required>
                                <%
                    try{
                                        //query to call procedure to get list of discounts
                                String callableQuery = "{call rbms.show_discounts(?)}";
                                CallableStatement callableStatement = db.prepareCall(callableQuery);
                                callableStatement.registerOutParameter(1, OracleTypes.CURSOR);
                                db.executeCallableStatement(callableStatement);
                                ResultSet categories = (ResultSet) callableStatement.getObject(1);
                                while(categories.next()){%>
                                <option value="<%out.print(categories.getString("discnt_category"));%>" <%if(categories.getString("discnt_category").equals(p_discount_category)){%>selected <%}%>><%out.print(categories.getString("discnt_rate"));%></option>
                                <%}
                    }catch(Exception ex){System.out.println("add_product.jsp get discounts : "+ex.toString());}%>
                            </select></tr>
                    <tr><td class="no_border"></td><td class="no_border" style="column-span: all;"><% if(pid==null){%><input id="positive_button" style="padding-left: 5px; padding-right: 5px;"type="submit" name="submit" value="Save"><%}else{%><input id="positive_button" style="padding-left: 5px; padding-right: 5px;"type="submit" name="submit" value="Update"><%}%></td></tr>
                    </center>
                </form>
                </p>
            </div>
            <br class="spacer" />
            <!--footer end -->
    </body>
    <%
        pid = request.getParameter("pid");           
        String name=request.getParameter("name");
        String qoh=request.getParameter("qoh");
        String qoh_threshold=request.getParameter("qoh_threshold");
        String original_price=request.getParameter("original_price");
        String discount_category=request.getParameter("discount_category");
        String action=request.getParameter("submit");
        if(action!=null && action.equals("Save")){
           if(name!=null){
               
               try{
                   //query to add product data for
               int result=db.setData("insert into products (pid, name, qoh, qoh_threshold, original_price, discnt_category) values ('"+pid+"','"+name+"','"+qoh+"','"+qoh_threshold+"','"+original_price+"','"+discount_category+"')");
               if(result==0){
                   out.print("Product not added");
                   return;
               }
               response.sendRedirect("products.jsp?action=add");
               }catch(Exception ex){
                   out.print("Product could not be added, Please enter correct data");
                   System.out.println("add_product.jsp add : "+ex.toString());
               }
           }
        }else if(action!=null && action.equals("Update")){
            //query update product data for given pid
            try{
            int result=db.setData("update products set name='"+name+"', qoh='"+qoh+"', qoh_threshold='"+qoh_threshold+"', original_price='"+original_price+"', discnt_category='"+discount_category+"' where pid='"+pid+"'");
            if(result==0){
                out.print("Product not updated");
                return;
            }
            response.sendRedirect("products.jsp?action=update");
            }catch(Exception ex){
                out.println("Product could not be updated, Please enter correct data");
                System.out.println("add_product.jsp update : "+ex.toString());
            }
        }
    %>
</html>
