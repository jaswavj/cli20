<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
response.setHeader("Cache-Control","no-cache");
Integer uid = (Integer) session.getAttribute("userId");
if (uid == null) { out.print("[]"); return; }
Connection con = null; PreparedStatement ps = null; ResultSet rs = null;
try {
    con = util.DBConnectionManager.getConnectionFromPool();
    ps = con.prepareStatement("SELECT id, user_name FROM users WHERE is_active=1 ORDER BY user_name");
    rs = ps.executeQuery();
    StringBuilder sb = new StringBuilder("[");
    boolean first = true;
    while (rs.next()) {
        if (!first) sb.append(","); first = false;
        sb.append("{\"id\":").append(rs.getInt("id"))
          .append(",\"name\":\"").append(rs.getString("user_name").replace("\"","\\\"")).append("\"}");
    }
    sb.append("]");
    out.print(sb.toString());
} catch (Exception e) {
    out.print("[]");
} finally {
    if (rs  != null) try { rs.close();  } catch (Exception e) {}
    if (ps  != null) try { ps.close();  } catch (Exception e) {}
    if (con != null) try { con.close(); } catch (Exception e) {}
}
%>
