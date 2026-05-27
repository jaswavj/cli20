<%@ page import="java.sql.*" %>
<%@ page contentType="application/json; charset=UTF-8" %>
<%
response.setHeader("Cache-Control","no-cache");
String type = request.getParameter("type");
Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;
StringBuilder json = new StringBuilder("[");
boolean first = true;
try {
    conn = util.DBConnectionManager.getConnectionFromPool();
    String sql = "";
    if("pending".equals(type)) {
        sql = "SELECT po.id, po.order_no, po.date, po.time, ot.name as table_name FROM prod_order po " +
              "JOIN order_tables ot ON po.table_id = ot.id " +
              "WHERE po.is_delivered=0 AND po.is_billed=0 AND po.is_cancelled=0 ORDER BY po.date DESC, po.time DESC";
    } else if("delivered".equals(type)) {
        sql = "SELECT po.id, po.order_no, po.date, po.time, ot.name as table_name FROM prod_order po " +
              "JOIN order_tables ot ON po.table_id = ot.id " +
              "WHERE po.is_delivered=1 AND po.is_billed=0 AND po.is_cancelled=0 ORDER BY po.date DESC, po.time DESC";
    } else if("billed".equals(type)) {
        sql = "SELECT po.id, po.order_no, po.date, po.time, ot.name as table_name FROM prod_order po " +
              "JOIN order_tables ot ON po.table_id = ot.id " +
              "WHERE po.is_billed=1 ORDER BY po.date DESC, po.time DESC";
    }
    if(!sql.isEmpty()) {
        ps = conn.prepareStatement(sql);
        rs = ps.executeQuery();
        while(rs.next()) {
            if(!first) json.append(","); first = false;
            String esc = rs.getString("table_name").replace("\\","\\\\").replace("\"","\\\"");
            String on  = rs.getString("order_no").replace("\\","\\\\").replace("\"","\\\"");
            json.append("{\"id\":").append(rs.getInt("id")).append(",")
                .append("\"order_no\":\"").append(on).append("\",")
                .append("\"table_name\":\"").append(esc).append("\",")
                .append("\"date\":\"").append(rs.getString("date")).append("\",")
                .append("\"time\":\"").append(rs.getString("time")).append("\"}");
        }
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