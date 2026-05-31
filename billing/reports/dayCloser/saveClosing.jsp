<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="billing" class="billing.billingBean" />
<%
response.setHeader("Cache-Control","no-cache");
Integer uid = (Integer) session.getAttribute("userId");
if (uid == null) { out.print("{\"success\":false,\"message\":\"Session expired\"}"); return; }

String date         = request.getParameter("date");
String closingStr   = request.getParameter("closingBalance");
String totalSaleStr = request.getParameter("totalSale");
String purchaseStr  = request.getParameter("purchase");
String expenseStr   = request.getParameter("expense");
String notes        = request.getParameter("notes");

if (date == null || closingStr == null) {
    out.print("{\"success\":false,\"message\":\"Missing parameters\"}"); return;
}
double closingBal, totalSale, purchase, expense;
try {
    closingBal = Double.parseDouble(closingStr);
    totalSale  = totalSaleStr != null ? Double.parseDouble(totalSaleStr) : 0;
    purchase   = purchaseStr  != null ? Double.parseDouble(purchaseStr)  : 0;
    expense    = expenseStr   != null ? Double.parseDouble(expenseStr)   : 0;
} catch (Exception e) {
    out.print("{\"success\":false,\"message\":\"Invalid amount\"}"); return;
}
if (notes == null) notes = "";
try {
    String err = billing.saveDayCloserClosing(date, closingBal, totalSale, purchase, expense, notes, uid);
    if (err == null) out.print("{\"success\":true}");
    else out.print("{\"success\":false,\"message\":\"" + err.replace("\"","\\\"") + "\"}");
} catch (Exception e) {
    String msg = e.getMessage(); if (msg==null) msg="error";
    out.print("{\"success\":false,\"message\":\"" + msg.replace("\\","\\\\").replace("\"","\\\"") + "\"}");
}
%>