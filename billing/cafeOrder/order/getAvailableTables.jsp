<%@ page import="java.sql.*" %>
<%@ page contentType="application/json; charset=UTF-8" %>
<%
response.setHeader("Cache-Control","no-cache");
Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;
StringBuilder json = new StringBuilder("[");
boolean first = true;
try {
    conn = util.DBConnectionManager.getConnectionFromPool();
    ps = conn.prepareStatement("SELECT id, name, is_occupied FROM order_tables ORDER BY name");
    rs = ps.executeQuery();
    while(rs.next()) {
        if(!first) json.append(",");
        first = false;
        json.append("{");
        json.append("\"id\":").append(rs.getInt("id")).append(",");
        json.append("\"name\":\"").append(rs.getString("name").replace("\\","\\\\").replace("\"","\\\"")).append("\",");
        json.append("\"is_occupied\":").append(rs.getInt("is_occupied"));
        json.append("}");
    }
} catch(Exception e) {
    json = new StringBuilder("[]");
} finally {
    if(rs!=null) try{rs.close();}catch(Exception e){}
    if(ps!=null) try{ps.close();}catch(Exception e){}
    if(conn!=null) try{conn.close();}catch(Exception e){}
}
json.append("]");
out.print(json.toString());
%>
