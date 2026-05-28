<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
response.setHeader("Cache-Control","no-cache");
Integer uid = (Integer) session.getAttribute("userId");
if (uid == null) { out.print("{\"hasEntry\":false}"); return; }
Connection con = null; PreparedStatement ps = null; ResultSet rs = null;
try {
    con = util.DBConnectionManager.getConnectionFromPool();
    String sql = "SELECT DATE_FORMAT(in_time,'%H:%i') AS i1, DATE_FORMAT(out_time,'%H:%i') AS o1, "
               + "DATE_FORMAT(in_time2,'%H:%i') AS i2, DATE_FORMAT(out_time2,'%H:%i') AS o2 "
               + "FROM attendance WHERE user_id=? AND entry_date=CURDATE()";
    ps = con.prepareStatement(sql);
    ps.setInt(1, uid);
    rs = ps.executeQuery();
    if (rs.next()) {
        String i1 = rs.getString("i1"); String o1 = rs.getString("o1");
        String i2 = rs.getString("i2"); String o2 = rs.getString("o2");
        out.print("{\"hasEntry\":true"
            + ",\"in1\":" + (i1!=null ? "\""+i1+"\"" : "null")
            + ",\"out1\":" + (o1!=null ? "\""+o1+"\"" : "null")
            + ",\"in2\":" + (i2!=null ? "\""+i2+"\"" : "null")
            + ",\"out2\":" + (o2!=null ? "\""+o2+"\"" : "null")
            + "}");
    } else {
        out.print("{\"hasEntry\":false}");
    }
} catch(Exception e) {
    out.print("{\"error\":\"" + e.getMessage().replace("\"","\\\"") + "\"}");
} finally {
    if(rs!=null) try{rs.close();}catch(Exception e){}
    if(ps!=null) try{ps.close();}catch(Exception e){}
    if(con!=null) try{con.close();}catch(Exception e){}
}
%>
