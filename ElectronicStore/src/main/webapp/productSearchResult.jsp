<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.Product3DAO" %>
<%@ page import="model.Product3" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>

<%!
    private String html(String value) {
        if (value == null) {
            return "";
        }

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
    request.setCharacterEncoding("UTF-8");

    String productName = request.getParameter("productName");

    if (productName == null || productName.trim().isEmpty()) {
        response.sendRedirect("productSearch.jsp?error=empty");
        return;
    }

    productName = productName.trim();

    Product3[] products = new Product3[0];
    String errorMessage = null;

    try (Product3DAO productDAO = new Product3DAO()) {
        products = productDAO.getProductsByName(productName);
    } catch (Exception e) {
        log("Lỗi tìm kiếm mặt hàng", e);
        errorMessage = "Không thể tải danh sách mặt hàng. Vui lòng thử lại.";
    }

    String encodedName = URLEncoder.encode(productName, "UTF-8");
    NumberFormat money = NumberFormat.getNumberInstance(
            new Locale("vi", "VN")
    );
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kết quả tìm kiếm</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 1100px; margin: auto; }
        .store-name {
            display: inline-block;
            background: #176080;
            color: #fff;
            padding: 12px 18px;
        }
        hr { border: 0; border-top: 2px solid #176080; }
        form { margin: 25px 0; }
        input { padding: 8px; width: 60%; }
        button { padding: 8px 16px; cursor: pointer; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #fff; padding: 10px; text-align: left; }
        th { background: #176080; color: white; }
        tr:nth-child(even) { background: #e5e8eb; }
        tr:nth-child(odd) { background: #cdd4d9; }
        .product-image { width: 80px; height: 60px; object-fit: contain; }
        .error { color: #b00020; }
    </style>
</head>
<body>

<div class="container">
    <h1 class="store-name">Siêu thị điện máy</h1>
    <hr>

    <form action="productSearchResult.jsp" method="get">
        <label for="txtProductName">Tìm kiếm mặt hàng:</label>
        <br><br>

        <input
            type="text"
            id="txtProductName"
            name="productName"
            value="<%= html(productName) %>"
        >

        <button type="submit" name="btnSearch">Tìm kiếm</button>
    </form>

    <% if (errorMessage != null) { %>
        <p class="error"><%= html(errorMessage) %></p>
    <% } else if (products.length == 0) { %>
        <p>Không tìm thấy mặt hàng phù hợp</p>
    <% } else { %>

        <table>
            <thead>
            <tr>
                <th>Ảnh</th>
                <th>Tên mặt hàng</th>
                <th>Danh mục</th>
                <th>Hãng</th>
                <th>Model</th>
                <th>Giá bán</th>
                <th>Thao tác</th>
            </tr>
            </thead>

            <tbody>
            <% for (Product3 product : products) { %>
                <tr>
                    <td>
                        <% if (product.getImage() != null
                                && !product.getImage().isEmpty()) { %>
                            <img class="product-image"
                                 src="<%= html(product.getImage()) %>"
                                 alt="<%= html(product.getName()) %>">
                        <% } else { %>
                            Chưa có ảnh
                        <% } %>
                    </td>

                    <td><%= html(product.getName()) %></td>
                    <td><%= html(product.getCategory()) %></td>
                    <td><%= html(product.getManufacturer()) %></td>
                    <td><%= html(product.getModel()) %></td>
                    <td><%= money.format(product.getSellingPrice()) %> đồng</td>

                    <td>
                        <a href="productDetails.jsp?productId=<%= product.getId() %>&amp;productName=<%= encodedName %>">
                            Xem chi tiết
                        </a>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>

    <% } %>
</div>

</body>
</html>