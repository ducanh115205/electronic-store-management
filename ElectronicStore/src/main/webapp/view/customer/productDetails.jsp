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

    if (productName == null) {
        productName = "";
    }

    String backUrl = productName.trim().isEmpty()
            ? "productSearch.jsp"
            : "productSearchResult.jsp?productName="
                + URLEncoder.encode(productName, "UTF-8");

    Product3 product = null;
    String errorMessage = null;

    try {
        int productId = Integer.parseInt(
                request.getParameter("productId")
        );

        try (Product3DAO productDAO = new Product3DAO()) {
            product = productDAO.getProductById(productId);
        }

        if (product == null) {
            errorMessage = "Mặt hàng không còn tồn tại.";
        }

    } catch (NumberFormatException e) {
        errorMessage = "Mã mặt hàng không hợp lệ.";

    } catch (Exception e) {
        log("Lỗi tải chi tiết mặt hàng", e);
        errorMessage = "Không thể tải thông tin mặt hàng. Vui lòng thử lại.";
    }

    NumberFormat money = NumberFormat.getNumberInstance(
            new Locale("vi", "VN")
    );
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết mặt hàng</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
        }

        .container {
            max-width: 1000px;
            margin: auto;
        }

        .store-name {
            display: inline-block;
            background: #176080;
            color: #fff;
            padding: 12px 18px;
        }

        hr {
            border: 0;
            border-top: 2px solid #176080;
        }

        .details {
            display: flex;
            gap: 40px;
            margin-top: 35px;
        }

        .image-box {
            width: 300px;
            min-height: 220px;
            background: #e5e8eb;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .image-box img {
            max-width: 100%;
            max-height: 300px;
            object-fit: contain;
        }

        .price {
            color: #c00;
            font-size: 22px;
            font-weight: bold;
        }

        .info p {
            margin: 10px 0;
        }

        .back {
            margin-top: 30px;
        }

        .error {
            color: #b00020;
        }
    </style>
</head>

<body>
<div class="container">

    <h1 id="lblStoreName" class="store-name">Siêu thị điện máy</h1>
    <h2 id="lblProductDetails">Chi tiết mặt hàng</h2>
    <hr>

    <% if (errorMessage != null) { %>

        <p class="error"><%= html(errorMessage) %></p>

    <% } else { %>

        <div class="details">

            <div class="image-box">
                <% if (product.getImage() != null
                        && !product.getImage().isEmpty()) { %>

                    <img id="imgProduct"
                         src="<%= html(product.getImage()) %>"
                         alt="<%= html(product.getName()) %>">

                <% } else { %>

                    Chưa có ảnh

                <% } %>
            </div>

            <div id="divProductInfo" class="info">
                <h2><%= html(product.getName()) %></h2>

                <p class="price">
                    <%= money.format(product.getSellingPrice()) %> đồng
                </p>

                <p>
                    <strong>Mã mặt hàng:</strong>
                    <%= product.getId() %>
                </p>

                <p>
                    <strong>Danh mục:</strong>
                    <%= html(product.getCategory()) %>
                </p>

                <p>
                    <strong>Hãng sản xuất:</strong>
                    <%= html(product.getManufacturer()) %>
                </p>

                <p>
                    <strong>Model:</strong>
                    <%= html(product.getModel()) %>
                </p>

                <p>
                    <strong>Đơn vị tính:</strong>
                    <%= html(product.getUnit()) %>
                </p>

                <p>
                    <strong>Bảo hành:</strong>
                    <%= product.getWarrantyMonths() == 0
                            ? "Không bảo hành"
                            : product.getWarrantyMonths() + " tháng" %>
                </p>

                <p>
                    <strong>Mô tả:</strong>
                    <%= html(product.getDescription()) %>
                </p>
            </div>
        </div>

    <% } %>

    <p class="back">
        <button type="button"
                name="btnBack"
                data-url="<%= html(backUrl) %>"
                onclick="window.location.href = this.dataset.url">
            Quay lại kết quả tìm kiếm
        </button>
    </p>

</div>
</body>
</html>