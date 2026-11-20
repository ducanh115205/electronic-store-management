package dao;

import model.Address3;
import model.Customer3;
import model.FullName3;
import model.Order3;
import model.OrderDetail3;
import model.Product3;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class Order3DAO extends DAO {

    public Order3DAO() throws SQLException {
        super();
    }

    public Order3DAO(Connection connection) {
        super(connection);
    }

    public Order3[] getPendingOrders(String status)
            throws SQLException {

        String sql = "SELECT o.id, o.orderDate, o.status, "
                + "m.id AS customerId, m.fullName, "
                + "COALESCE(SUM(d.quantity * d.unitPrice), 0) AS totalAmount "
                + "FROM tblOrder3 o "
                + "JOIN tblMember3 m ON o.customerId = m.id "
                + "LEFT JOIN tblOrderDetail3 d ON d.orderId = o.id "
                + "WHERE o.status = ? "
                + "GROUP BY o.id, o.orderDate, o.status, "
                + "m.id, m.fullName "
                + "ORDER BY o.id";

        List<Order3> orders = new ArrayList<>();

        try (PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setString(1, status);

            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    Order3 order = new Order3();

                    order.setId(result.getInt("id"));
                    order.setOrderDate(result.getDate("orderDate"));
                    order.setStatus(result.getString("status"));
                    order.setTotalAmount(result.getDouble("totalAmount"));

                    Customer3 customer = new Customer3();
                    customer.setId(result.getInt("customerId"));
                    customer.setFullName(
                            parseFullName(result.getString("fullName"))
                    );

                    order.setCustomer(customer);
                    orders.add(order);
                }
            }
        }

        return orders.toArray(new Order3[0]);
    }

    public Order3 getOrderDetails(int orderId)
            throws SQLException {

        String sql = "SELECT o.id, o.orderDate, o.recipientPhone, "
                + "o.status, m.id AS customerId, m.fullName, "
                + "a.id AS addressId, a.houseNumber, a.street, "
                + "a.ward, a.district, a.province "
                + "FROM tblOrder3 o "
                + "JOIN tblMember3 m ON o.customerId = m.id "
                + "JOIN tblAddress3 a ON o.deliveryAddressId = a.id "
                + "WHERE o.id = ?";

        Order3 order = null;

        try (PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setInt(1, orderId);

            try (ResultSet result = statement.executeQuery()) {
                if (result.next()) {
                    order = new Order3();

                    order.setId(result.getInt("id"));
                    order.setOrderDate(result.getDate("orderDate"));
                    order.setRecipientPhone(
                            result.getString("recipientPhone")
                    );
                    order.setStatus(result.getString("status"));

                    Customer3 customer = new Customer3();
                    customer.setId(result.getInt("customerId"));
                    customer.setFullName(
                            parseFullName(result.getString("fullName"))
                    );
                    order.setCustomer(customer);

                    Address3 address = new Address3();
                    address.setId(result.getInt("addressId"));
                    address.setHouseNumber(result.getString("houseNumber"));
                    address.setStreet(result.getString("street"));
                    address.setWard(result.getString("ward"));
                    address.setDistrict(result.getString("district"));
                    address.setProvince(result.getString("province"));

                    order.setDeliveryAddress(address);
                }
            }
        }

        if (order == null) {
            return null;
        }

        String detailSql = "SELECT d.id, d.quantity, d.unitPrice, "
                + "p.id AS productId, p.name "
                + "FROM tblOrderDetail3 d "
                + "JOIN tblProduct3 p ON d.productId = p.id "
                + "WHERE d.orderId = ? "
                + "ORDER BY d.id";

        List<OrderDetail3> details = new ArrayList<>();
        double totalAmount = 0;

        try (PreparedStatement statement = con.prepareStatement(detailSql)) {
            statement.setInt(1, orderId);

            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    Product3 product = new Product3();
                    product.setId(result.getInt("productId"));
                    product.setName(result.getString("name"));

                    OrderDetail3 detail = new OrderDetail3();
                    detail.setId(result.getInt("id"));
                    detail.setQuantity(result.getInt("quantity"));
                    detail.setUnitPrice(result.getDouble("unitPrice"));
                    detail.setProduct(product);

                    details.add(detail);
                    totalAmount += detail.getQuantity()
                            * detail.getUnitPrice();
                }
            }
        }

        order.setDetails(details.toArray(new OrderDetail3[0]));
        order.setTotalAmount(totalAmount);

        return order;
    }

    public boolean updateApprovalInformation(
            int orderId,
            int warehouseStaffId,
            int deliveryStaffId
    ) throws SQLException {

        String sql = "UPDATE tblOrder3 "
                + "SET warehouseStaffId = ?, "
                + "deliveryStaffId = ?, status = 'Đã xuất' "
                + "WHERE id = ? AND status = 'Chưa xuất'";

        try (PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setInt(1, warehouseStaffId);
            statement.setInt(2, deliveryStaffId);
            statement.setInt(3, orderId);

            return statement.executeUpdate() == 1;
        }
    }

    private FullName3 parseFullName(String value) {
        FullName3 fullName = new FullName3();

        if (value == null || value.trim().isEmpty()) {
            return fullName;
        }

        String[] parts = value.trim().split("\\s+");

        if (parts.length == 1) {
            fullName.setFirstName(parts[0]);
            return fullName;
        }

        fullName.setLastName(parts[0]);
        fullName.setFirstName(parts[parts.length - 1]);

        if (parts.length > 2) {
            StringBuilder middleName = new StringBuilder();

            for (int i = 1; i < parts.length - 1; i++) {
                if (middleName.length() > 0) {
                    middleName.append(" ");
                }

                middleName.append(parts[i]);
            }

            fullName.setMiddleName(middleName.toString());
        }

        return fullName;
    }
}