<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page language="java" import= "java.util.*"%>
<%
// Prevent caching
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
%>
<jsp:useBean id="user" class="user.userBean" />
<%
    Integer uids = (Integer) session.getAttribute("userId");
    
    // Check if user is logged in
    if (uids == null) {
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }
    
    String contextPath = request.getContextPath();
%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BILLING APP</title>
    <link rel="icon" type="image/jpeg" href="jasxbill.jpeg">
	<style>*{margin:0;padding:0;box-sizing:border-box;}html,body{height:100%;overflow:hidden;}</style>
</head>
<body>
    
<iframe 
                    src="../cafeOrder/order/page.jsp" 
                    width="100%" 
                    height="100%" 
                    frameborder="0"
                    style="margin:0; padding:0; display:block; height: calc(107vh - 20px);">
                </iframe>
    
</body>
</html>