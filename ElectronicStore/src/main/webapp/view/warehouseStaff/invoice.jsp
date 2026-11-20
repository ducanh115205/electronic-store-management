<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Invoice3" %>
<%@ page import="model.InvoiceDetail3" %>
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

    Invoice3 invoice = (Invoice3) session.getAttribute("createdInvoice");

    if (invoice == null) {
        response.sendRedirect("pendingOrderList.jsp");
        return;
    }

    Order3 order = invoice.getOrder();

    NumberFormat money = NumberFormat.getNumberInstance(
            new Locale("vi", "VN")
    );

    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hóa đơn</title>

    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 950px; margin: auto; }
        h2 { color: #176080; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        th, td { border: 1px solid white; padding: 10px; text-align: left; }
        th { background: #176080; color: white; }
        tbody tr:nth-child(odd) { background: #cdd4d9; }
        tbody tr:nth-child(even) { background: #e5e8eb; }
        .actions { display: flex; gap: 20px; margin-top: 25px; }
        button { padding: 8px 14px; cursor: pointer; }

        @media print {
            .actions { display: none; }
        }
    </style>
</head>

<body>
<div class="container">

    <h2 id="lblInvoiceTitle">
        Hóa đơn bán hàng - HD<%= String.format("%02d", invoice.getId()) %>
    </h2>

    <p id="lblStoreInfo">Siêu thị điện máy</p>

    <p id="lblInvoiceDate">
        Ngày lập: <%= dateFormat.format(invoice.getCreatedDate()) %>
    </p>

    <table id="tblInvoiceInfo">
        <tbody>
        <tr>
            <th>Mã đơn hàng</th>
            <td>DH<%= String.format("%02d", order.getId()) %></td>
        </tr>
        <tr>
            <th>Khách hàng</th>
            <td><%= html(order.getCustomer().getFullName().toString()) %></td>
        </tr>
        <tr>
            <th>Số điện thoại</th>
            <td><%= html(order.getRecipientPhone()) %></td>
        </tr>
        <tr>
            <th>Địa chỉ nhận</th>
            <td><%= html(order.getDeliveryAddress().toString()) %></td>
        </tr>
        </tbody>
    </table>

    <h3>Danh sách mặt hàng</h3>

    <table id="tblInvoiceDetails">
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
            InvoiceDetail3[] invoiceDetails = invoice.getDetails();

            for (int i = 0; i < invoiceDetails.length; i++) {
                InvoiceDetail3 detail = invoiceDetails[i];
        %>
            <tr>
                <td><%= i + 1 %></td>
                <td>
                    MH<%= String.format("%02d", detail.getProduct().getId()) %>
                </td>
                <td><%= html(detail.getProduct().getName()) %></td>
                <td><%= detail.getQuantity() %></td>
                <td><%= money.format(detail.getUnitPrice()) %></td>
                <td>
                    <%= money.format(
                            detail.getQuantity() * detail.getUnitPrice()
                    ) %>
                </td>
            </tr>
        <% } %>
        </tbody>
    </table>

    <p id="lblTotalAmount">
        <strong>Tổng thanh toán:</strong>
        <%= money.format(invoice.getTotalAmount()) %> đồng
    </p>

    <div class="actions">
        <form action="pendingOrderList.jsp" method="get">
            <button type="submit" name="btnBackToOrderList">
                Quay lại danh sách đơn hàng
            </button>
        </form>

        <button type="button"
                name="btnPrintInvoice"
                onclick="window.print()">
            In hóa đơn
        </button>
    </div>

</div>
</body>
</html>