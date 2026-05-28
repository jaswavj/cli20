<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
response.setHeader("Cache-Control","no-cache");
Integer uid = (Integer) session.getAttribute("userId");
String action = request.getParameter("action"); // in1 | out1 | in2 | out2
if (uid == null || action == null) { out.print("{\"success\":false,\"message\":\"Invalid request\"}"); return; }
Connection con = null; PreparedStatement ps = null; ResultSet rs = null;
try {
    con = util.DBConnectionManager.getConnectionFromPool();
    // Get today's row
    ps = con.prepareStatement("SELECT id,in_time,out_time,in_time2,out_time2 FROM attendance WHERE user_id=? AND entry_date=CURDATE()");
    ps.setInt(1,uid); rs = ps.executeQuery();
    boolean hasRow = rs.next();
    String i1 = hasRow ? rs.getString("in_time")  : null;
    String o1 = hasRow ? rs.getString("out_time") : null;
    String i2 = hasRow ? rs.getString("in_time2") : null;
    String o2 = hasRow ? rs.getString("out_time2"): null;
    rs.close(); ps.close();

    String sql = null; String timeCol = null;
    if ("in1".equals(action)) {
        if (i1 != null) { out.print("{\"success\":false,\"message\":\"Shift 1 already started\"}"); return; }
        if (!hasRow) sql = "INSERT INTO attendance (user_id,entry_date,in_time) VALUES (?,CURDATE(),CURTIME())";
        else         sql = "UPDATE attendance SET in_time=CURTIME() WHERE user_id=? AND entry_date=CURDATE()";
        timeCol = "in_time";
    } else if ("out1".equals(action)) {
        if (i1 == null) { out.print("{\"success\":false,\"message\":\"Start Shift 1 first\"}"); return; }
        if (o1 != null) { out.print("{\"success\":false,\"message\":\"Shift 1 already ended\"}"); return; }
        sql = "UPDATE attendance SET out_time=CURTIME() WHERE user_id=? AND entry_date=CURDATE()";
        timeCol = "out_time";
    } else if ("in2".equals(action)) {
        if (o1 == null) { out.print("{\"success\":false,\"message\":\"Complete Shift 1 first\"}"); return; }
        if (i2 != null) { out.print("{\"success\":false,\"message\":\"Shift 2 already started\"}"); return; }
        sql = "UPDATE attendance SET in_time2=CURTIME() WHERE user_id=? AND entry_date=CURDATE()";
        timeCol = "in_time2";
    } else if ("out2".equals(action)) {
        if (i2 == null) { out.print("{\"success\":false,\"message\":\"Start Shift 2 first\"}"); return; }
        if (o2 != null) { out.print("{\"success\":false,\"message\":\"Shift 2 already ended\"}"); return; }
        sql = "UPDATE attendance SET out_time2=CURTIME() WHERE user_id=? AND entry_date=CURDATE()";
        timeCol = "out_time2";
    } else {
        out.print("{\"success\":false,\"message\":\"Invalid action\"}"); return;
    }
    ps = con.prepareStatement(sql);
    ps.setInt(1,uid); ps.executeUpdate(); ps.close();
    // Read back the time
    ps = con.prepareStatement("SELECT DATE_FORMAT("+timeCol+",'%H:%i') AS t FROM attendance WHERE user_id=? AND entry_date=CURDATE()");
    ps.setInt(1,uid); rs = ps.executeQuery();
    String t = rs.next() ? rs.getString("t") : "";
    out.print("{\"success\":true,\"time\":\""+t+"\"}");
} catch(Exception e) {
    out.print("{\"success\":false,\"message\":\""+e.getMessage().replace("\"","\\\"")+"\"}");
} finally {
    if(rs!=null)try{rs.close();}catch(Exception e){}
    if(ps!=null)try{ps.close();}catch(Exception e){}
    if(con!=null)try{con.close();}catch(Exception e){}
}
%>
