package dao;

import model.Employee3;
import model.Invoice3;
import model.InvoiceDetail3;
import model.Order3;
import model.OrderDetail3;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class Invoice3DAO extends DAO {

    public Invoice3DAO() throws SQLException {
        super();
    }

    public Invoice3DAO(Connection connection) {
        super(connection);
    }

    public Invoice3 createInvoiceFromOrder(int orderId)
            throws SQLException {

        Order3 order;

        try (Order3DAO orderDAO = new Order3DAO(con)) {
            order = orderDAO.getOrderDetails(orderId);
        }

        if (order == null
                || order.getDetails() == null
                || order.getDetails().length == 0) {
            throw new SQLException(
                    "Không thể tạo hóa đơn vì đơn hàng không hợp lệ."
            );
        }

        String employeeSql = "SELECT warehouseStaffId "
                + "FROM tblOrder3 "
                + "WHERE id = ? AND status = 'Đã xuất'";

        int employeeId;

        try (PreparedStatement statement = con.prepareStatement(employeeSql)) {
            statement.setInt(1, orderId);

            try (ResultSet result = statement.executeQuery()) {
                if (!result.next()) {
                    throw new SQLException(
                            "Không tìm thấy đơn hàng đã xuất."
                    );
                }

                employeeId = result.getInt("warehouseStaffId");

                if (result.wasNull()) {
                    throw new SQLException(
                            "Đơn hàng chưa có nhân viên kho xử lý."
                    );
                }
            }
        }

        String invoiceSql = "INSERT INTO tblInvoice3 "
                + "(createdDate, purchaseType, orderId, employeeId) "
                + "VALUES (CURRENT_DATE, ?, ?, ?)";

        int invoiceId;

        try (PreparedStatement statement = con.prepareStatement(
                invoiceSql,
                Statement.RETURN_GENERATED_KEYS
        )) {
            statement.setString(1, "Đặt hàng trực tuyến");
            statement.setInt(2, orderId);
            statement.setInt(3, employeeId);

            if (statement.executeUpdate() != 1) {
                throw new SQLException("Không thể tạo hóa đơn.");
            }

            try (ResultSet keys = statement.getGeneratedKeys()) {
                if (!keys.next()) {
                    throw new SQLException("Không lấy được mã hóa đơn.");
                }

                invoiceId = keys.getInt(1);
            }
        }

        String detailSql = "INSERT INTO tblInvoiceDetail3 "
                + "(quantity, unitPrice, invoiceId, productId) "
                + "VALUES (?, ?, ?, ?)";

        OrderDetail3[] orderDetails = order.getDetails();
        InvoiceDetail3[] invoiceDetails =
                new InvoiceDetail3[orderDetails.length];

        try (PreparedStatement statement = con.prepareStatement(
                detailSql,
                Statement.RETURN_GENERATED_KEYS
        )) {
            for (int i = 0; i < orderDetails.length; i++) {
                OrderDetail3 orderDetail = orderDetails[i];

                statement.setInt(1, orderDetail.getQuantity());
                statement.setDouble(2, orderDetail.getUnitPrice());
                statement.setInt(3, invoiceId);
                statement.setInt(4, orderDetail.getProduct().getId());

                if (statement.executeUpdate() != 1) {
                    throw new SQLException(
                            "Không thể tạo chi tiết hóa đơn."
                    );
                }

                InvoiceDetail3 invoiceDetail = new InvoiceDetail3();
                invoiceDetail.setQuantity(orderDetail.getQuantity());
                invoiceDetail.setUnitPrice(orderDetail.getUnitPrice());
                invoiceDetail.setProduct(orderDetail.getProduct());

                try (ResultSet keys = statement.getGeneratedKeys()) {
                    if (keys.next()) {
                        invoiceDetail.setId(keys.getInt(1));
                    }
                }

                invoiceDetails[i] = invoiceDetail;
            }
        }

        Invoice3 invoice = new Invoice3();
        invoice.setId(invoiceId);
        invoice.setCreatedDate(new java.util.Date());
        invoice.setPurchaseType("Đặt hàng trực tuyến");
        invoice.setOrder(order);
        invoice.setTotalAmount(order.getTotalAmount());
        invoice.setDetails(invoiceDetails);

        Employee3 employee = new Employee3();
        employee.setId(employeeId);
        invoice.setCreatedBy(employee);

        return invoice;
    }
}