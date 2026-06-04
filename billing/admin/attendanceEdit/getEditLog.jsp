<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<jsp:useBean id="user" class="user.userBean" />
<jsp:useBean id="billing" class="billing.billingBean" />
<%
Integer uid = (Integer) session.getAttribute("userId");
if (uid == null) { out.print("[]"); return; }
Vector vecPer = user.getUserPermission(uid);
Set<Integer> permissions = new HashSet<Integer>();
for (int i=0;i<vecPer.size();i++){Vector cat=(Vector)vecPer.get(i);permissions.add(Integer.parseInt(cat.elementAt(0).toString()));}
if (!permissions.contains(7)) { out.print("[]"); return; }

String attDate  = request.getParameter("attDate");
String empId    = request.getParameter("empId");
String fromDate = request.getParameter("fromDate");
String toDate   = request.getParameter("toDate");
String userId   = request.getParameter("userId");

try {
    Vector logs = billing.getAttendanceEditLog(attDate, empId, fromDate, toDate, userId);
    StringBuilder sb = new StringBuilder("[");
    boolean first = true;
    for (int i = 0; i < logs.size(); i++) {
        if (!first) sb.append(","); first = false;
        Vector row = (Vector) logs.get(i);
        // indices: 0=attDate,1=editedAt,2=empName,3=editorName,4=remarks,
        //   5=oi1,6=oo1,7=oi2,8=oo2,9=oi3,10=oo3, 11=ni1,12=no1,13=ni2,14=no2,15=ni3,16=no3
        String rmk = row.get(4).toString().replace("\\","\\\\").replace("\"","\\\"").replace("\n"," ").replace("\r","");
        sb.append("{")
          .append("\"attDate\":\"").append(row.get(0)).append("\",")
          .append("\"editedAt\":\"").append(row.get(1)).append("\",")
          .append("\"empName\":\"").append(row.get(2).toString().replace("\"","\\\"")).append("\",")
          .append("\"editedBy\":\"").append(row.get(3).toString().replace("\"","\\\"")).append("\",")
          .append("\"remarks\":\"").append(rmk).append("\",")
          .append("\"oldIn1\":").append(!row.get(5).toString().isEmpty() ? "\""+row.get(5)+"\"" : "null").append(",")
          .append("\"oldOut1\":").append(!row.get(6).toString().isEmpty() ? "\""+row.get(6)+"\"" : "null").append(",")
          .append("\"oldIn2\":").append(!row.get(7).toString().isEmpty() ? "\""+row.get(7)+"\"" : "null").append(",")
          .append("\"oldOut2\":").append(!row.get(8).toString().isEmpty() ? "\""+row.get(8)+"\"" : "null").append(",")
          .append("\"oldIn3\":").append(!row.get(9).toString().isEmpty() ? "\""+row.get(9)+"\"" : "null").append(",")
          .append("\"oldOut3\":").append(!row.get(10).toString().isEmpty() ? "\""+row.get(10)+"\"" : "null").append(",")
          .append("\"newIn1\":").append(!row.get(11).toString().isEmpty() ? "\""+row.get(11)+"\"" : "null").append(",")
          .append("\"newOut1\":").append(!row.get(12).toString().isEmpty() ? "\""+row.get(12)+"\"" : "null").append(",")
          .append("\"newIn2\":").append(!row.get(13).toString().isEmpty() ? "\""+row.get(13)+"\"" : "null").append(",")
          .append("\"newOut2\":").append(!row.get(14).toString().isEmpty() ? "\""+row.get(14)+"\"" : "null").append(",")
          .append("\"newIn3\":").append(!row.get(15).toString().isEmpty() ? "\""+row.get(15)+"\"" : "null").append(",")
          .append("\"newOut3\":").append(!row.get(16).toString().isEmpty() ? "\""+row.get(16)+"\"" : "null")
          .append("}");
    }
    sb.append("]");
    out.print(sb.toString());
} catch(Exception e) {
    out.print("[]");
}
%>
