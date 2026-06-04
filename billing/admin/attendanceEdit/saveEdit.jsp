<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<jsp:useBean id="user" class="user.userBean" />
<jsp:useBean id="billing" class="billing.billingBean" />
<%
response.setHeader("Cache-Control", "no-cache");
Integer uid = (Integer) session.getAttribute("userId");
if (uid == null) { out.print("{\"success\":false,\"message\":\"Session expired\"}"); return; }
Vector vecPer = user.getUserPermission(uid);
Set<Integer> permissions = new HashSet<Integer>();
for (int i=0;i<vecPer.size();i++){Vector cat=(Vector)vecPer.get(i);permissions.add(Integer.parseInt(cat.elementAt(0).toString()));}
if (!permissions.contains(7)) { out.print("{\"success\":false,\"message\":\"Access denied\"}"); return; }

String date    = request.getParameter("date");
String userId  = request.getParameter("userId");
String remarks = request.getParameter("remarks");
if (date==null||date.isEmpty()||userId==null||userId.isEmpty()||remarks==null||remarks.trim().isEmpty()) {
    out.print("{\"success\":false,\"message\":\"Missing required fields\"}");
    return;
}

try {
    String[] res = billing.saveAttendanceEdit(
        date, Integer.parseInt(userId), uid,
        request.getParameter("in1"),  request.getParameter("out1"),
        request.getParameter("in2"),  request.getParameter("out2"),
        request.getParameter("in3"),  request.getParameter("out3"),
        remarks);
    if ("true".equals(res[0])) {
        out.print("{\"success\":true}");
    } else {
        String msg = res.length > 1 ? res[1] : "Unknown error";
        msg = msg.replace("\\","\\\\").replace("\"","\\\"").replace("\n"," ").replace("\r","");
        out.print("{\"success\":false,\"message\":\""+msg+"\"}");
    }
} catch(Exception e) {
    String msg = e.getMessage(); if(msg==null) msg="Unknown error";
    msg = msg.replace("\\","\\\\").replace("\"","\\\"").replace("\n"," ").replace("\r","");
    out.print("{\"success\":false,\"message\":\""+msg+"\"}");
}
%>
