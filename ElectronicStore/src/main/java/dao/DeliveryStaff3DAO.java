package dao;

import model.DeliveryStaff3;
import model.FullName3;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DeliveryStaff3DAO extends DAO {

    public DeliveryStaff3DAO() throws SQLException {
        super();
    }

    public DeliveryStaff3[] getDeliveryStaffList()
            throws SQLException {

        String sql = "SELECT m.id, m.fullName, m.phone "
                + "FROM tblMember3 m "
                + "JOIN tblEmployee3 e ON e.memberId = m.id "
                + "WHERE m.role = 'DELIVERY_STAFF' "
                + "ORDER BY m.id";

        List<DeliveryStaff3> staffList = new ArrayList<>();

        try (PreparedStatement statement = con.prepareStatement(sql);
             ResultSet result = statement.executeQuery()) {

            while (result.next()) {
                DeliveryStaff3 staff = new DeliveryStaff3();

                staff.setId(result.getInt("id"));
                staff.setPhone(result.getString("phone"));

                FullName3 fullName = new FullName3();
                fullName.setFirstName(result.getString("fullName"));

                staff.setFullName(fullName);
                staffList.add(staff);
            }
        }

        return staffList.toArray(new DeliveryStaff3[0]);
    }
}