<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<jsp:useBean id="user" class="user.userBean" />
<jsp:useBean id="billing" class="billing.billingBean" />
<%
Integer uid = (Integer) session.getAttribute("userId");
if (uid == null) { out.print("{}"); return; }
Vector vecPer = user.getUserPermission(uid);
Set<Integer> permissions = new HashSet<Integer>();
for (int i=0;i<vecPer.size();i++){Vector cat=(Vector)vecPer.get(i);permissions.add(Integer.parseInt(cat.elementAt(0).toString()));}
if (!permissions.contains(7)) { out.print("{}"); return; }

String date   = request.getParameter("date");
String userId = request.getParameter("userId");
if (date==null||date.isEmpty()||userId==null||userId.isEmpty()) { out.print("{}"); return; }

try {
    Vector row = billing.getAttendanceForEdit(date, Integer.parseInt(userId));
    boolean found = "1".equals(row.get(0).toString());
    String i1=(String)row.get(1), o1=(String)row.get(2);
    String i2=(String)row.get(3), o2=(String)row.get(4);
    String i3=(String)row.get(5), o3=(String)row.get(6);
    out.print("{\"found\":"+(found?"true":"false")+","
        +"\"in1\":"+(!i1.isEmpty()?"\""+i1+"\"":"null")+","
        +"\"out1\":"+(!o1.isEmpty()?"\""+o1+"\"":"null")+","
        +"\"in2\":"+(!i2.isEmpty()?"\""+i2+"\"":"null")+","
        +"\"out2\":"+(!o2.isEmpty()?"\""+o2+"\"":"null")+","
        +"\"in3\":"+(!i3.isEmpty()?"\""+i3+"\"":"null")+","
        +"\"out3\":"+(!o3.isEmpty()?"\""+o3+"\"":"null")+"}");
} catch(Exception e) {
    out.print("{}");
}
%>
