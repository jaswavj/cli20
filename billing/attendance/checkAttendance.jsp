<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Vector" %>
<jsp:useBean id="billing" class="billing.billingBean" />
<%
response.setHeader("Cache-Control","no-cache");
Integer uid = (Integer) session.getAttribute("userId");
if (uid == null) { out.print("{\"hasEntry\":false}"); return; }
try {
    Vector r = billing.checkAttendance(uid);
    boolean hasEntry = (Boolean) r.get(0);
    if (!hasEntry) { out.print("{\"hasEntry\":false}"); return; }
    String i1=(String)r.get(1), o1=(String)r.get(2), i2=(String)r.get(3), o2=(String)r.get(4);
    out.print("{\"hasEntry\":true"
        + ",\"in1\":"  + (i1!=null ? "\""+i1+"\"" : "null")
        + ",\"out1\":" + (o1!=null ? "\""+o1+"\"" : "null")
        + ",\"in2\":"  + (i2!=null ? "\""+i2+"\"" : "null")
        + ",\"out2\":" + (o2!=null ? "\""+o2+"\"" : "null")
        + "}");
} catch(Exception e) {
    String msg = e.getMessage(); if(msg==null) msg="Unknown error";
    out.print("{\"error\":\"" + msg.replace("\\","\\\\").replace("\"","\\\"") + "\"}");
}
%>
