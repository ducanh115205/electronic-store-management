<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.Order3DAO" %>
<%@ page import="dao.DeliveryStaff3DAO" %>
<%@ page import="model.Order3" %>
<%@ page import="model.OrderDetail3" %>
<%@ page import="model.DeliveryStaff3" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
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
    Integer staffId = (Integer) session.getAttribute("warehouseStaffId");

    if (staffId == null) {
        response.sendRedirect("../../warehouseStaffLogin.jsp");
        return;
    }

    int orderId = 0;
    Order3 order = null;
    DeliveryStaff3[] staffList = new DeliveryStaff3[0];
    String errorMessage = null;

    try {
        orderId = Integer.parseInt(request.getParameter("orderId"));

        try (Order3DAO orderDAO = new Order3DAO();
             DeliveryStaff3DAO deliveryDAO = new DeliveryStaff3DAO()) {

            order = orderDAO.getOrderDetails(orderId);
            staffList = deliveryDAO.getDeliveryStaffList();
        }

        if (order == null) {
            errorMessage = "Không tìm thấy đơn hàng.";
        } else if (!"Chưa xuất".equals(order.getStatus())) {
            errorMessage = "Đơn hàng không còn ở trạng thái chưa xuất.";
        }

    } catch (NumberFormatException e) {
        errorMessage = "Mã đơn hàng không hợp lệ.";
    } catch (Exception e) {
        log("Lỗi tải chi tiết đơn hàng", e);
        errorMessage = "Không thể tải thông tin đơn hàng.";
    }

    String processError = request.getParameter("error");

    NumberFormat money = NumberFormat.getNumberInstance(
            new Locale("vi", "VN")
    );

    SimpleDateFormat dateFormat =
            new SimpleDateFormat("dd/MM/yyyy");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết đơn hàng</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
        }

        .container {
            max-width: 1100px;
            margin: auto;
        }

        h2, h3 {
            color: #176080;
        }

        .info-row {
            display: flex;
            gap: 20px;
        }

        .info-box {
            border: 1px solid #8db7a0;
            padding: 15px;
            flex: 1;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 25px;
        }

        th, td {
            border: 1px solid white;
            padding: 9px;
            text-align: left;
        }

        th {
            background: #176080;
            color: white;
        }

        tbody tr:nth-child(odd) {
            background: #cdd4d9;
        }

        tbody tr:nth-child(even) {
            background: #e5e8eb;
        }

        button {
            padding: 8px 14px;
            cursor: pointer;
        }

        button:disabled {
            cursor: not-allowed;
        }

        .error {
            color: #b00020;
        }

        .actions {
            display: flex;
            gap: 20px;
            margin-top: 25px;
        }
    </style>
</head>

<body>
<div class="container">

    <% if (errorMessage != null) { %>

        <p class="error"><%= html(errorMessage) %></p>

        <form action="pendingOrderList.jsp" method="get">
            <button type="submit" name="btnBack">
                Quay lại
            </button>
        </form>

    <% } else { %>

        <h2>
            Chi tiết đơn hàng
            DH<%= String.format("%02d", order.getId()) %>
        </h2>

        <% if ("delivery".equals(processError)) { %>

            <p class="error">
                Vui lòng chọn nhân viên giao hàng.
            </p>

        <% } else if ("failed".equals(processError)) { %>

            <p class="error">
                Xử lý không thành công. Đơn hàng hoặc tồn kho có thể đã thay đổi.
            </p>

        <% } %>

        <div class="info-row">

            <div class="info-box">
                <strong>Thông tin đơn hàng</strong>

                <p>
                    Mã đơn:
                    DH<%= String.format("%02d", order.getId()) %>
                </p>

                <p>
                    Ngày đặt:
                    <%= dateFormat.format(order.getOrderDate()) %>
                </p>

                <p>
                    Hình thức: Đặt hàng trực tuyến
                </p>
            </div>

            <div class="info-box">
                <strong>Thông tin nhận hàng</strong>

                <p>
                    Khách hàng:
                    <%= html(order.getCustomer().getFullName().toString()) %>
                </p>

                <p>
                    Số điện thoại:
                    <%= html(order.getRecipientPhone()) %>
                </p>

                <p>
                    Địa chỉ nhận:
                    <%= html(order.getDeliveryAddress().toString()) %>
                </p>
            </div>

        </div>

        <h3>Danh sách mặt hàng</h3>

        <table>
            <thead>
            <tr>
                <th>TT</th>
                <th>Mã mặt hàng</th>
                <th>Tên mặt hàng</th>
                <th>Số lượng</th>
                <th>Đơn giá</th>
                <th>Thành tiền</th>
            </tr>
            </thead>

            <tbody>
            <%
                OrderDetail3[] details = order.getDetails();

                for (int i = 0; i < details.length; i++) {
                    OrderDetail3 detail = details[i];
            %>

                <tr>
                    <td><%= i + 1 %></td>

                    <td>
                        MH<%= String.format("%02d",
                                detail.getProduct().getId()) %>
                    </td>

                    <td>
                        <%= html(detail.getProduct().getName()) %>
                    </td>

                    <td>
                        <%= detail.getQuantity() %>
                    </td>

                    <td>
                        <%= money.format(detail.getUnitPrice()) %> đồng
                    </td>

                    <td>
                        <%= money.format(
                                detail.getQuantity() * detail.getUnitPrice()
                        ) %> đồng
                    </td>
                </tr>

            <% } %>
            </tbody>
        </table>

        <p>
            <strong>Tổng tiền:</strong>
            <%= money.format(order.getTotalAmount()) %> đồng
        </p>

        <h3>Danh sách nhân viên giao hàng</h3>

        <form action="doApproveAndDispatch.jsp" method="post">

            <input type="hidden"
                   name="orderId"
                   value="<%= order.getId() %>">

            <input type="hidden"
                   id="selectedDeliveryStaffId"
                   name="deliveryStaffId"
                   value="">

            <% if (staffList.length == 0) { %>

                <p>Không có nhân viên giao hàng.</p>

            <% } else { %>

                <table>
                    <thead>
                    <tr>
                        <th>TT</th>
                        <th>Mã nhân viên</th>
                        <th>Tên nhân viên</th>
                        <th>Số điện thoại</th>
                        <th>Thao tác</th>
                    </tr>
                    </thead>

                    <tbody>
                    <%
                        for (int i = 0; i < staffList.length; i++) {
                            DeliveryStaff3 deliveryStaff = staffList[i];
                    %>

                        <tr>
                            <td>
                                <%= i + 1 %>
                            </td>

                            <td>
                                GH<%= String.format("%02d",
                                        deliveryStaff.getId()) %>
                            </td>

                            <td>
                                <%= html(
                                        deliveryStaff.getFullName().toString()
                                ) %>
                            </td>

                            <td>
                                <%= html(deliveryStaff.getPhone()) %>
                            </td>

                            <td>
                                <button
                                    type="button"
                                    name="btnSelectDeliveryStaff"
                                    data-id="<%= deliveryStaff.getId() %>"
                                    data-name="<%= html(
                                            deliveryStaff.getFullName().toString()
                                    ) %>"
                                    onclick="selectDeliveryStaff(this)">
                                    Chọn
                                </button>
                            </td>
                        </tr>

                    <% } %>
                    </tbody>
                </table>

                <p>
                    Nhân viên giao hàng đã chọn:
                    <strong id="selectedDeliveryStaffName">
                        Chưa chọn
                    </strong>
                </p>

            <% } %>

            <button
                type="submit"
                name="btnApproveAndDispatch"
                <%= staffList.length == 0 ? "disabled" : "" %>>
                Xác nhận duyệt và xuất kho
            </button>

        </form>

        <div class="actions">
            <form action="pendingOrderList.jsp" method="get">
                <button type="submit" name="btnBack">
                    Quay lại
                </button>
            </form>
        </div>

    <% } %>

</div>

<script>
    function selectDeliveryStaff(button) {
        document.getElementById("selectedDeliveryStaffId").value =
            button.dataset.id;

        document.getElementById("selectedDeliveryStaffName").textContent =
            button.dataset.name;
    }
</script>

</body>
</html>