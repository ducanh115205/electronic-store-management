<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.Order3DAO" %>
<%@ page import="dao.Product3DAO" %>
<%@ page import="dao.Invoice3DAO" %>
<%@ page import="model.Order3" %>
<%@ page import="model.Invoice3" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%
    request.setCharacterEncoding("UTF-8");

    Integer warehouseStaffId =
            (Integer) session.getAttribute("warehouseStaffId");

    if (warehouseStaffId == null) {
        response.sendRedirect("../../warehouseStaffLogin.jsp");
        return;
    }

    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect("pendingOrderList.jsp");
        return;
    }

    int orderId;

    try {
        orderId = Integer.parseInt(request.getParameter("orderId"));
    } catch (Exception e) {
        response.sendRedirect("pendingOrderList.jsp");
        return;
    }

    String deliveryValue = request.getParameter("deliveryStaffId");

    if (deliveryValue == null || deliveryValue.trim().isEmpty()) {
        response.sendRedirect(
                "orderDetails.jsp?orderId=" + orderId + "&error=delivery"
        );
        return;
    }

    int deliveryStaffId;

    try {
        deliveryStaffId = Integer.parseInt(deliveryValue);
    } catch (NumberFormatException e) {
        response.sendRedirect(
                "orderDetails.jsp?orderId=" + orderId + "&error=delivery"
        );
        return;
    }

    Invoice3 invoice = null;
    boolean success = false;

    try (Order3DAO orderDAO = new Order3DAO()) {
        Connection connection = orderDAO.getConnection();
        connection.setAutoCommit(false);

        try {
            /*
             * Kiểm tra nhân viên được chọn thực sự có vai trò
             * nhân viên giao hàng.
             */
            String staffSql = "SELECT m.id "
                    + "FROM tblMember3 m "
                    + "JOIN tblEmployee3 e ON e.memberId = m.id "
                    + "WHERE m.id = ? AND m.role = 'DELIVERY_STAFF'";

            try (PreparedStatement statement =
                         connection.prepareStatement(staffSql)) {

                statement.setInt(1, deliveryStaffId);

                try (ResultSet result = statement.executeQuery()) {
                    if (!result.next()) {
                        throw new Exception(
                                "Nhân viên giao hàng không hợp lệ."
                        );
                    }
                }
            }

            Order3 order = orderDAO.getOrderDetails(orderId);

            if (order == null || !"Chưa xuất".equals(order.getStatus())) {
                throw new Exception("Đơn hàng không còn chờ xử lý.");
            }

            if (!orderDAO.updateApprovalInformation(
                    orderId,
                    warehouseStaffId,
                    deliveryStaffId
            )) {
                throw new Exception("Không cập nhật được đơn hàng.");
            }

            try (Product3DAO productDAO = new Product3DAO(connection)) {
                if (!productDAO.updateStock(order.getDetails())) {
                    throw new Exception("Không đủ tồn kho hoặc không thể cập nhật.");
                }
            }

            try (Invoice3DAO invoiceDAO = new Invoice3DAO(connection)) {
                invoice = invoiceDAO.createInvoiceFromOrder(orderId);
            }

            connection.commit();
            success = true;

        } catch (Exception e) {
            connection.rollback();
            log("Duyệt và xuất kho không thành công", e);
        }

    } catch (Exception e) {
        log("Lỗi kết nối khi duyệt và xuất kho", e);
    }

    if (!success) {
        response.sendRedirect(
                "orderDetails.jsp?orderId=" + orderId + "&error=failed"
        );
        return;
    }

    session.setAttribute("createdInvoice", invoice);
    response.sendRedirect("invoice.jsp");
%>