package dao;

import model.Product3;
import model.OrderDetail3;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class Product3DAO extends DAO {

    public Product3DAO() throws SQLException {
        super();
    }
    
    public Product3DAO(Connection connection) {
        super(connection);
    }
    public Product3[] getProductsByName(String productName)
            throws SQLException {

        String sql = "SELECT id, name, category, image, manufacturer, "
                + "model, description, unit, sellingPrice, "
                + "stockQuantity, warrantyMonths "
                + "FROM tblProduct3 "
                + "WHERE name LIKE ? "
                + "ORDER BY id";

        List<Product3> products = new ArrayList<>();

        try (PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setString(1, "%" + productName + "%");

            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    products.add(readProduct(result));
                }
            }
        }

        return products.toArray(new Product3[0]);
    }

    public Product3 getProductById(int productId)
            throws SQLException {

        String sql = "SELECT id, name, category, image, manufacturer, "
                + "model, description, unit, sellingPrice, "
                + "stockQuantity, warrantyMonths "
                + "FROM tblProduct3 "
                + "WHERE id = ?";

        try (PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setInt(1, productId);

            try (ResultSet result = statement.executeQuery()) {
                if (result.next()) {
                    return readProduct(result);
                }
            }
        }

        return null;
    }

    private Product3 readProduct(ResultSet result)
            throws SQLException {

        Product3 product = new Product3();

        product.setId(result.getInt("id"));
        product.setName(result.getString("name"));
        product.setCategory(result.getString("category"));
        product.setImage(result.getString("image"));
        product.setManufacturer(result.getString("manufacturer"));
        product.setModel(result.getString("model"));
        product.setDescription(result.getString("description"));
        product.setUnit(result.getString("unit"));
        product.setSellingPrice(result.getDouble("sellingPrice"));
        product.setStockQuantity(result.getInt("stockQuantity"));

        product.setWarrantyMonths(result.getInt("warrantyMonths"));

        return product;
    }
    
    public boolean updateStock(OrderDetail3[] orderDetails)
        throws SQLException {

        if (orderDetails == null || orderDetails.length == 0) {
            return false;
        }

        String sql = "UPDATE tblProduct3 "
                + "SET stockQuantity = stockQuantity - ? "
                + "WHERE id = ? AND stockQuantity >= ?";

        try (PreparedStatement statement = con.prepareStatement(sql)) {
            for (OrderDetail3 detail : orderDetails) {
                if (detail.getProduct() == null || detail.getQuantity() <= 0) {
                    return false;
                }

                statement.setInt(1, detail.getQuantity());
                statement.setInt(2, detail.getProduct().getId());
                statement.setInt(3, detail.getQuantity());

                if (statement.executeUpdate() != 1) {
                    return false;
                }
            }
        }

        return true;
    }
}