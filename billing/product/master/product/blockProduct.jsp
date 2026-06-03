<%@page language="java" %>
<jsp:useBean id="prod" class="product.productBean" />
<%
Integer userId = (Integer) session.getAttribute("userId");
if (userId == null) {
    response.sendRedirect(request.getContextPath() + "/index.jsp");
    return;
}

String productIdParam = request.getParameter("productId");
if (productIdParam == null || productIdParam.trim().isEmpty()) {
    response.sendRedirect(request.getContextPath() + "/product/master/product/product.jsp?msg=Product+ID+is+missing&type=danger");
    return;
}

try {
    int productId = Integer.parseInt(productIdParam);
    prod.blockProduct(productId);
    response.sendRedirect(request.getContextPath() + "/product/master/product/product.jsp?msg=Product+blocked+successfully!&type=success");
} catch (NumberFormatException e) {
    response.sendRedirect(request.getContextPath() + "/product/master/product/product.jsp?msg=Invalid+Product+ID&type=danger");
} catch (Exception e) {
    response.sendRedirect(request.getContextPath() + "/product/master/product/product.jsp?msg=Error+blocking+product&type=danger");
}
%>
