<%@ page import="java.sql.*" %>
<%@ page contentType="application/json; charset=UTF-8" %>
<%
response.setHeader("Cache-Control","no-cache");
String orderId = request.getParameter("orderId");
Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;
StringBuilder json = new StringBuilder("{");
try {
    conn = util.DBConnectionManager.getConnectionFromPool();
    // Order header
    ps = conn.prepareStatement("SELECT po.*, ot.name as table_name FROM prod_order po JOIN order_tables ot ON po.table_id=ot.id WHERE po.id=?");
    ps.setInt(1, Integer.parseInt(orderId));
    rs = ps.executeQuery();
    if(rs.next()) {
        json.append("\"order_no\":\"").append(rs.getString("order_no").replace("\"","\\\"")).append("\",");
        json.append("\"table_name\":\"").append(rs.getString("table_name").replace("\"","\\\"")).append("\",");
        json.append("\"date\":\"").append(rs.getString("date")).append("\",");
        json.append("\"time\":\"").append(rs.getString("time")).append("\",");
    }
    rs.close(); ps.close();
    // Items
    ps = conn.prepareStatement("SELECT pod.id, pod.qty, pod.price, pod.total, pod.is_delivered, p.name, p.code FROM prod_order_details pod JOIN prod_product p ON pod.prod_id=p.id WHERE pod.order_id=?");
    ps.setInt(1, Integer.parseInt(orderId));
    rs = ps.executeQuery();
    json.append("\"items\":[");
    boolean firstItem = true;
    double grandTotal = 0;
    int pendingCount = 0;
    while(rs.next()) {
        if(!firstItem) json.append(","); firstItem = false;
        double tot = rs.getDouble("total"); grandTotal += tot;
        int isDel = rs.getInt("is_delivered");
        if(isDel == 0) pendingCount++;
        String name = rs.getString("name").replace("\\","\\\\").replace("\"","\\\"");
        String code = rs.getString("code") != null ? rs.getString("code").replace("\\","\\\\").replace("\"","\\\"") : "";
        json.append("{\"id\":").append(rs.getInt("id")).append(",")
            .append("\"name\":\"").append(name).append("\",")
            .append("\"code\":\"").append(code).append("\",")
            .append("\"qty\":").append(rs.getInt("qty")).append(",")
            .append("\"price\":").append(rs.getDouble("price")).append(",")
            .append("\"total\":").append(tot).append(",")
            .append("\"is_delivered\":").append(isDel).append("}");
    }
    json.append("],");
    json.append("\"grand_total\":").append(grandTotal).append(",");
    json.append("\"all_delivered\":").append(pendingCount == 0 ? "true" : "false");
    json.append("}");
} catch(Exception e) {
    json = new StringBuilder("{\"error\":\"" + e.getMessage().replace("\"","\\\"") + "\"}");
} finally {
    if(rs!=null) try{rs.close();}catch(Exception ex){}
    if(ps!=null) try{ps.close();}catch(Exception ex){}
    if(conn!=null) try{conn.close();}catch(Exception ex){}
}
out.print(json.toString());
%>