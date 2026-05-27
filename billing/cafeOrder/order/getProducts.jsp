<%@ page import="java.sql.*" %>
<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%
response.setHeader("Cache-Control","no-cache");
Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;
String categoryIdParam = request.getParameter("category_id");
Integer categoryId = null;
if(categoryIdParam != null && !categoryIdParam.isEmpty()) {
    try { categoryId = Integer.parseInt(categoryIdParam); } catch(NumberFormatException e) {}
}
StringBuilder json = new StringBuilder("[");
boolean first = true;
try {
    conn = util.DBConnectionManager.getConnectionFromPool();
    String sql = "SELECT p.id, p.name, p.code, IFNULL(MAX(b.mrp), 0) as mrp " +
                 "FROM prod_product p LEFT JOIN prod_batch b ON p.id = b.product_id " +
                 "WHERE p.is_active=1 ";
    if(categoryId != null) sql += "AND p.category_id = ? ";
    sql += "GROUP BY p.id, p.name, p.code ORDER BY p.name";
    ps = conn.prepareStatement(sql);
    if(categoryId != null) ps.setInt(1, categoryId);
    rs = ps.executeQuery();
    while(rs.next()) {
        if(!first) json.append(",");
        first = false;
        String name = rs.getString("name") != null ? rs.getString("name") : "";
        String code = rs.getString("code") != null ? rs.getString("code") : "";
        json.append("{");
        json.append("\"id\":").append(rs.getInt("id")).append(",");
        json.append("\"name\":\"").append(name.replace("\\","\\\\").replace("\"","\\\"")).append("\",");
        json.append("\"code\":\"").append(code.replace("\\","\\\\").replace("\"","\\\"")).append("\",");
        json.append("\"price\":").append(rs.getDouble("mrp"));
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