<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="billing" class="billing.billingBean" />
<%
response.setHeader("Cache-Control","no-cache");
Integer uid = (Integer) session.getAttribute("userId");
if (uid == null) { out.print("{\"error\":\"session\"}"); return; }

String date = request.getParameter("date");
if (date == null || date.isEmpty()) { out.print("{\"error\":\"date required\"}"); return; }

try {
    java.util.HashMap<String,Object> d = billing.getDayCloserStatus(date);
    // d is never null now — status is "no_entry"/"open"/"closed"

    String notes     = d.get("notes").toString().replace("\\","\\\\").replace("\"","\\\"").replace("\n","\\n").replace("\r","");
    String openDt    = d.get("openDt").toString().replace("\"","\\\"");
    String closeDt   = d.get("closeDt").toString().replace("\"","\\\"");
    String openUser  = d.get("openUser").toString().replace("\"","\\\"");
    String closeUser = d.get("closeUser").toString().replace("\"","\\\"");

    out.print("{" +
        "\"status\":\""         + d.get("status")          + "\"," +
        "\"openingBal\":"       + d.get("openingBal")       + "," +
        "\"cashSale\":"         + d.get("cashSale")         + "," +
        "\"bankSale\":"         + d.get("bankSale")         + "," +
        "\"dueCash\":"          + d.get("dueCash")          + "," +
        "\"dueBank\":"          + d.get("dueBank")          + "," +
        "\"totalSale\":"        + d.get("totalSale")        + "," +
        "\"purchase\":"         + d.get("purchase")         + "," +
        "\"purchasePayCash\":"  + d.get("purchasePayCash")  + "," +
        "\"purchasePayBank\":"  + d.get("purchasePayBank")  + "," +
        "\"expense\":"          + d.get("expense")          + "," +
        "\"cashInHand\":"       + d.get("cashInHand")       + "," +
        "\"cashInBank\":"       + d.get("cashInBank")       + "," +
        "\"closingBal\":"       + d.get("closingBal")       + "," +
        "\"notes\":\""          + notes     + "\"," +
        "\"openDt\":\""         + openDt    + "\"," +
        "\"closeDt\":\""        + closeDt   + "\"," +
        "\"openUser\":\""       + openUser  + "\"," +
        "\"closeUser\":\""      + closeUser + "\"" +
    "}");
} catch (Exception e) {
    String msg = e.getMessage(); if (msg==null) msg="error";
    out.print("{\"error\":\"" + msg.replace("\\","\\\\").replace("\"","\\\"") + "\"}");
}
%>