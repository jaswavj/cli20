<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="bill" class="billing.billingBean" />
<%
response.setHeader("Cache-Control", "no-cache");
Integer uid = (Integer) session.getAttribute("userId");

if (uid == null) {
    out.print("{\"success\":false,\"message\":\"Session expired. Please login again.\"}");
    return;
}

String userIdStr = request.getParameter("userId");
String amountStr = request.getParameter("amount");
String reason = request.getParameter("reason");
String notes = request.getParameter("notes");
String entryDate = request.getParameter("entryDate");

if (userIdStr == null || userIdStr.trim().isEmpty()) {
    out.print("{\"success\":false,\"message\":\"Please select a user\"}");
    return;
}
if (amountStr == null || amountStr.trim().isEmpty()) {
    out.print("{\"success\":false,\"message\":\"Please enter incentive amount\"}");
    return;
}
if (reason == null || reason.trim().isEmpty()) {
    out.print("{\"success\":false,\"message\":\"Please enter reason for incentive\"}");
    return;
}
if (entryDate == null || entryDate.trim().isEmpty()) {
    out.print("{\"success\":false,\"message\":\"Please select a date\"}");
    return;
}

try {
    int userId = Integer.parseInt(userIdStr.trim());
    double amount = Double.parseDouble(amountStr.trim());

    if (amount <= 0) {
        out.print("{\"success\":false,\"message\":\"Amount must be greater than 0\"}");
        return;
    }

    String safeReason = reason.trim();
    String safeNotes = (notes == null) ? "" : notes.trim();
    String safeEntryDate = entryDate.trim();

    boolean result = bill.saveIncentive(userId, amount, safeReason, safeNotes, safeEntryDate, uid.intValue());
    if (result) {
        out.print("{\"success\":true,\"message\":\"Incentive saved successfully\"}");
    } else {
        out.print("{\"success\":false,\"message\":\"Failed to save incentive\"}");
    }
} catch (NumberFormatException e) {
    out.print("{\"success\":false,\"message\":\"Invalid number format\"}");
} catch (Exception e) {
    String msg = e.getMessage();
    if (msg == null) msg = "Unknown error";
    msg = msg.replace("\\", "\\\\").replace("\"", "\\\"");
    out.print("{\"success\":false,\"message\":\"Error: " + msg + "\"}");
}
%>
