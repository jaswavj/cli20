<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="billing" class="billing.billingBean" />
<%
response.setHeader("Cache-Control","no-cache");
Integer uid = (Integer) session.getAttribute("userId");
if (uid == null) { out.print("{\"error\":\"session\"}"); return; }

String fromDate = request.getParameter("fromDate");
String toDate   = request.getParameter("toDate");
if (fromDate == null || toDate == null || fromDate.isEmpty() || toDate.isEmpty()) {
    out.print("{\"error\":\"date range required\"}"); return;
}
try {
    java.util.HashMap<String,Object> d = billing.getDayCloserRange(fromDate, toDate);
    out.print("{" +
        "\"cashSale\":"        + d.get("cashSale")        + "," +
        "\"bankSale\":"        + d.get("bankSale")        + "," +
        "\"totalSale\":"       + d.get("totalSale")       + "," +
        "\"dueCash\":"         + d.get("dueCash")         + "," +
        "\"dueBank\":"         + d.get("dueBank")         + "," +
        "\"totalDue\":"        + d.get("totalDue")        + "," +
        "\"purchasePayCash\":" + d.get("purchasePayCash") + "," +
        "\"purchasePayBank\":" + d.get("purchasePayBank") + "," +
        "\"totalPurchPay\":"   + d.get("totalPurchPay")   + "," +
        "\"expense\":"         + d.get("expense")         + "," +
        "\"totalOpening\":"    + d.get("totalOpening")    + "," +
        "\"netCashInHand\":"   + d.get("netCashInHand")   + "," +
        "\"netCashInBank\":"   + d.get("netCashInBank")   +
    "}");
} catch (Exception e) {
    String msg = e.getMessage(); if (msg==null) msg="error";
    out.print("{\"error\":\"" + msg.replace("\\","\\\\").replace("\"","\\\"") + "\"}");
}
%>