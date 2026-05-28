<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="billing" class="billing.billingBean" />
<%
response.setHeader("Cache-Control","no-cache");
Integer uid = (Integer) session.getAttribute("userId");
String action = request.getParameter("action");
if (uid == null || action == null) { out.print("{\"success\":false,\"message\":\"Invalid request\"}"); return; }
try {
    String[] res = billing.markAttendance(uid, action);
    if ("true".equals(res[0])) {
        out.print("{\"success\":true,\"time\":\"" + res[1] + "\"}");
    } else {
        out.print("{\"success\":false,\"message\":\"" + res[1].replace("\"","\\\"") + "\"}");
    }
} catch(Exception e) {
    String msg = e.getMessage(); if(msg==null) msg="Unknown error";
    out.print("{\"success\":false,\"message\":\"" + msg.replace("\\","\\\\").replace("\"","\\\"") + "\"}");
}
%>
