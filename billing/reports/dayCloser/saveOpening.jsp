<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="billing" class="billing.billingBean" />
<%
response.setHeader("Cache-Control","no-cache");
Integer uid = (Integer) session.getAttribute("userId");
if (uid == null) { out.print("{\"success\":false,\"message\":\"Session expired\"}"); return; }

String date   = request.getParameter("date");
String amtStr = request.getParameter("amount");
if (date == null || amtStr == null) {
    out.print("{\"success\":false,\"message\":\"Missing parameters\"}"); return;
}
double amount;
try { amount = Double.parseDouble(amtStr); } catch (Exception e) {
    out.print("{\"success\":false,\"message\":\"Invalid amount\"}"); return;
}
try {
    String err = billing.saveDayCloserOpening(date, amount, uid);
    if (err == null) out.print("{\"success\":true}");
    else out.print("{\"success\":false,\"message\":\"" + err.replace("\"","\\\"") + "\"}");
} catch (Exception e) {
    String msg = e.getMessage(); if (msg==null) msg="error";
    out.print("{\"success\":false,\"message\":\"" + msg.replace("\\","\\\\").replace("\"","\\\"") + "\"}");
}
%>