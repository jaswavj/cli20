<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="prod" class="product.productBean" />
<%
boolean isAjax = "1".equals(request.getParameter("ajax"));
try {
    int id = Integer.parseInt(request.getParameter("id"));
    int productId = Integer.parseInt(request.getParameter("productId"));
    String productName = request.getParameter("productName");
    
    prod.deleteProductComponent(id);
    
    if (isAjax) {
        response.setContentType("application/json");
        out.print("{\"ok\":true}");
    } else {
        response.sendRedirect(request.getContextPath() + "/product/master/components/viewComponents.jsp?productId=" + productId + "&productName=" + java.net.URLEncoder.encode(productName, "UTF-8") + "&msg=Component+deleted&type=success");
    }
} catch (Exception e) {
    if (isAjax) {
        response.setContentType("application/json");
        response.setStatus(500);
        out.print("{\"ok\":false}");
    } else {
        response.sendRedirect(request.getContextPath() + "/product/master/components/page.jsp?msg=Error:+" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8") + "&type=danger");
    }
}
%>
