<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tìm kiếm mặt hàng</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 1000px; margin: auto; }
        .store-name {
            display: inline-block;
            background: #176080;
            color: #fff;
            padding: 12px 18px;
        }
        hr { border: 0; border-top: 2px solid #176080; }
        .search-form { margin-top: 25px; }
        input { padding: 8px; width: 65%; }
        button { padding: 8px 16px; cursor: pointer; }
        .error { color: #b00020; }
    </style>
</head>
<body>

<div class="container">
    <h1 id="lblStoreName" class="store-name">Siêu thị điện máy</h1>
    <hr>

    <div class="search-form">
        <form action="productSearchResult.jsp" method="get">
            <label id="lblSearchProduct" for="txtProductName">Tìm kiếm mặt hàng:</label>
            <br><br>

            <input
                type="text"
                id="txtProductName"
                name="productName"
                placeholder="Nhập tên mặt hàng..."
            >

            <button type="submit" name="btnSearch">Tìm kiếm</button>
        </form>

        <%
            if ("empty".equals(request.getParameter("error"))) {
        %>
            <p class="error">Vui lòng nhập tên mặt hàng cần tìm</p>
        <%
            }
        %>
    </div>
</div>

</body>
</html>