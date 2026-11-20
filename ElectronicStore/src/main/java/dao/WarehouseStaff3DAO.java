package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class WarehouseStaff3DAO extends DAO {

    public WarehouseStaff3DAO() throws SQLException {
        super();
    }

    /**
     * Kiểm tra tài khoản nhân viên kho.
     *
     * @return ID nhân viên nếu đúng; -1 nếu không hợp lệ.
     */
    public int login(String username, String password)
            throws SQLException {

        String sql = "SELECT m.id "
                + "FROM tblMember3 m "
                + "JOIN tblEmployee3 e ON e.memberId = m.id "
                + "WHERE m.username = ? "
                + "AND m.password = SHA2(?, 256) "
                + "AND m.role = 'WAREHOUSE_STAFF'";

        try (PreparedStatement statement = con.prepareStatement(sql)) {
            statement.setString(1, username);
            statement.setString(2, password);

            try (ResultSet result = statement.executeQuery()) {
                if (result.next()) {
                    return result.getInt("id");
                }
            }
        }

        return -1;
    }
}