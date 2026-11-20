<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    Integer warehouseStaffId =
            (Integer) session.getAttribute("warehouseStaffId");

    if (warehouseStaffId == null) {
        response.sendRedirect("../../warehouseStaffLogin.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang chủ nhân viên kho</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
        }

        .container {
            width: 450px;
            margin: 60px auto;
            border: 1px solid #ccc;
            padding: 25px;
            text-align: center;
        }

        h2 {
            color: #176080;
        }

        hr {
            border: 0;
            border-top: 2px solid #176080;
        }

        button {
            margin-top: 25px;
            padding: 10px 20px;
            cursor: pointer;
        }
    </style>
</head>

<body>

<div class="container">
    <h2 id="lblWarehouseStaffHome">Trang chủ nhân viên kho</h2>
    <hr>

    <form action="pendingOrderList.jsp" method="get">
        <button type="submit" name="btnApproveOrder">
            Duyệt đơn
        </button>
    </form>
</div>

</body>
</html>