package model;

public class Address3 {
    private int id;
    private String houseNumber;
    private String ward;
    private String street;
    private String district;
    private String province;

    public Address3() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getHouseNumber() {
        return houseNumber;
    }

    public void setHouseNumber(String houseNumber) {
        this.houseNumber = houseNumber;
    }

    public String getWard() {
        return ward;
    }

    public void setWard(String ward) {
        this.ward = ward;
    }

    public String getStreet() {
        return street;
    }

    public void setStreet(String street) {
        this.street = street;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    @Override
    public String toString() {
        return String.join(", ",
                houseNumber == null ? "" : houseNumber,
                street == null ? "" : street,
                ward == null ? "" : ward,
                district == null ? "" : district,
                province == null ? "" : province);
    }
}