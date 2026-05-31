<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.sql.*" %>
<jsp:useBean id="user" class="user.userBean" />
<%
Integer uid = (Integer) session.getAttribute("userId");
if (uid == null) { out.print("[]"); return; }
Vector vecPer = user.getUserPermission(uid);
Set<Integer> permissions = new HashSet<Integer>();
for (int i=0;i<vecPer.size();i++) { Vector cat=(Vector)vecPer.get(i); permissions.add(Integer.parseInt(cat.elementAt(0).toString())); }
boolean isAdmin = permissions.contains(8);
String fromDate  = request.getParameter("fromDate");
String toDate    = request.getParameter("toDate");
String userFilter= request.getParameter("userId");
if (fromDate==null) fromDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
if (toDate==null)   toDate   = fromDate;
Connection con=null; PreparedStatement ps=null; ResultSet rs=null;
try {
    con = util.DBConnectionManager.getConnectionFromPool();
    StringBuilder sql = new StringBuilder();
    sql.append("SELECT a.entry_date, "
        +"DATE_FORMAT(a.in_time,'%H:%i') AS in1, DATE_FORMAT(a.out_time,'%H:%i') AS out1, "
        +"DATE_FORMAT(a.in_time2,'%H:%i') AS in2, DATE_FORMAT(a.out_time2,'%H:%i') AS out2, "
        +"DATE_FORMAT(a.in_time3,'%H:%i') AS in3, DATE_FORMAT(a.out_time3,'%H:%i') AS out3, "
        +"u.user_name, a.user_id FROM attendance a "
        +"JOIN users u ON u.id=a.user_id "
        +"WHERE a.entry_date BETWEEN ? AND ? ");
    if (isAdmin && userFilter!=null && !userFilter.isEmpty()) sql.append("AND a.user_id=? ");
    else if (!isAdmin) sql.append("AND a.user_id=? ");
    sql.append("ORDER BY a.entry_date DESC, u.user_name ASC");
    ps = con.prepareStatement(sql.toString());
    ps.setString(1,fromDate); ps.setString(2,toDate);
    int idx=3;
    if (isAdmin && userFilter!=null && !userFilter.isEmpty()) ps.setInt(idx++,Integer.parseInt(userFilter));
    else if (!isAdmin) ps.setInt(idx++,uid);
    rs = ps.executeQuery();
    StringBuilder sb = new StringBuilder("[");
    boolean first=true;
    while(rs.next()) {
        if(!first) sb.append(","); first=false;
        String i1=rs.getString("in1"); String o1=rs.getString("out1");
        String i2=rs.getString("in2"); String o2=rs.getString("out2");
        String i3=rs.getString("in3"); String o3=rs.getString("out3");
        sb.append("{"
            +"\"date\":\""+rs.getDate("entry_date")+"\","
            +"\"in1\":"+(i1!=null?"\""+i1+"\"":"null")+","
            +"\"out1\":"+(o1!=null?"\""+o1+"\"":"null")+","
            +"\"in2\":"+(i2!=null?"\""+i2+"\"":"null")+","
            +"\"out2\":"+(o2!=null?"\""+o2+"\"":"null")+","
            +"\"in3\":"+(i3!=null?"\""+i3+"\"":"null")+","
            +"\"out3\":"+(o3!=null?"\""+o3+"\"":"null")+","
            +"\"userName\":\""+rs.getString("user_name")+"\","
            +"\"userId\":"+rs.getInt("user_id")
            +"}");
    }
    sb.append("]");
    out.print(sb.toString());
} catch(Exception e) { out.print("[]"); }
finally {
    if(rs!=null)try{rs.close();}catch(Exception e){}
    if(ps!=null)try{ps.close();}catch(Exception e){}
    if(con!=null)try{con.close();}catch(Exception e){}
}
%>
