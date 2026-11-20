<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.Order3DAO" %>
<%@ page import="model.Order3" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>

<%!
    private String html(String value) {
        if (value == null) return "";

        return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>

<%
    Integer staffId = (Integer) session.getAttribute("warehouseStaffId");

    if (staffId == null) {
        response.sendRedirect("../../warehouseStaffLogin.jsp");
        return;
    }

    Order3[] orders = new Order3[0];
    String errorMessage = null;

    try (Order3DAO orderDAO = new Order3DAO()) {
        orders = orderDAO.getPendingOrders("Chưa xuất");
    } catch (Exception e) {
        log("Lỗi tải danh sách đơn hàng", e);
        errorMessage = "Không thể tải danh sách đơn hàng.";
    }

    NumberFormat money = NumberFormat.getNumberInstance(
            new Locale("vi", "VN")
    );

    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đơn hàng chưa xuất</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 1100px; margin: auto; }
        h2 { color: #176080; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid white; padding: 10px; }
        th { background: #176080; color: white; text-align: left; }
        tbody tr:nth-child(odd) { background: #cdd4d9; }
        tbody tr:nth-child(even) { background: #e5e8eb; }
        button { padding: 7px 12px; cursor: pointer; }
        .back { margin-top: 25px; }
        .error { color: #b00020; }
    </style>
</head>

<body>
<div class="container">

    <h2>Đơn hàng chờ duyệt và xuất kho</h2>

    <% if (errorMessage != null) { %>

        <p class="error"><%= html(errorMessage) %></p>

    <% } else if (orders.length == 0) { %>

        <p>Không có đơn hàng cần xử lý.</p>

    <% } else { %>

        <table>
            <thead>
            <tr>
                <th>TT</th>
                <th>Mã đơn</th>
                <th>Ngày đặt</th>
                <th>Tên khách hàng</th>
                <th>Tổng tiền</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
            </tr>
            </thead>

            <tbody>
            <% for (int i = 0; i < orders.length; i++) {
                Order3 order = orders[i];
            %>
                <tr>
                    <td><%= i + 1 %></td>
                    <td>DH<%= String.format("%02d", order.getId()) %></td>
                    <td>
                        <%= order.getOrderDate() == null
                                ? ""
                                : dateFormat.format(order.getOrderDate()) %>
                    </td>
                    <td>
                        <%= html(order.getCustomer().getFullName().toString()) %>
                    </td>
                    <td><%= money.format(order.getTotalAmount()) %> đồng</td>
                    <td><%= html(order.getStatus()) %></td>
                    <td>
                        <form action="orderDetails.jsp" method="get">
                            <input type="hidden"
                                   name="orderId"
                                   value="<%= order.getId() %>">

                            <button type="submit" name="btnReviewOrder">
                                Kiểm tra và duyệt
                            </button>
                        </form>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>

    <% } %>

    <form class="back" action="warehouseStaffHome.jsp" method="get">
        <button type="submit" name="btnBack">Quay lại</button>
    </form>

</div>
</body>
</html>