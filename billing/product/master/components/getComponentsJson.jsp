<%@ page language="java" contentType="application/json; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<jsp:useBean id="prod" class="product.productBean" />
<%
    response.setHeader("Cache-Control", "no-cache");
    int productId = 0;
    try { productId = Integer.parseInt(request.getParameter("productId")); } catch (Exception e) {}
    StringBuilder sb = new StringBuilder("[");
    try {
        Vector components = prod.getProductComponents(productId);
        if (components != null) {
            for (int i = 0; i < components.size(); i++) {
                Vector row = (Vector) components.get(i);
                int compId   = (Integer) row.elementAt(0);
                String cName = row.elementAt(1).toString().replace("\"","&quot;");
                String cCode = row.elementAt(2).toString().replace("\"","&quot;");
                double qty   = (Double) row.elementAt(3);
                if (i > 0) sb.append(",");
                sb.append("{\"id\":").append(compId)
                  .append(",\"name\":\"").append(cName).append("\"")
                  .append(",\"code\":\"").append(cCode).append("\"")
                  .append(",\"qty\":").append(qty).append("}");
            }
        }
    } catch (Exception e) {}
    sb.append("]");
    out.print(sb.toString());
%>
