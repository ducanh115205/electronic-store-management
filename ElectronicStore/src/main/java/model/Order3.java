package model;

import java.util.Date;

public class Order3 {
    private int id;
    private Date orderDate;
    private String recipientPhone;
    private String status;
    private double totalAmount;
    private Customer3 customer;
    private Address3 deliveryAddress;
    private WarehouseStaff3 warehouseStaff;
    private DeliveryStaff3 deliveryStaff;
    private OrderDetail3[] details;

    public Order3() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }

    public String getRecipientPhone() {
        return recipientPhone;
    }

    public void setRecipientPhone(String recipientPhone) {
        this.recipientPhone = recipientPhone;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public Customer3 getCustomer() {
        return customer;
    }

    public void setCustomer(Customer3 customer) {
        this.customer = customer;
    }

    public Address3 getDeliveryAddress() {
        return deliveryAddress;
    }

    public void setDeliveryAddress(Address3 deliveryAddress) {
        this.deliveryAddress = deliveryAddress;
    }

    public WarehouseStaff3 getWarehouseStaff() {
        return warehouseStaff;
    }

    public void setWarehouseStaff(WarehouseStaff3 warehouseStaff) {
        this.warehouseStaff = warehouseStaff;
    }

    public DeliveryStaff3 getDeliveryStaff() {
        return deliveryStaff;
    }

    public void setDeliveryStaff(DeliveryStaff3 deliveryStaff) {
        this.deliveryStaff = deliveryStaff;
    }

    public OrderDetail3[] getDetails() {
        return details;
    }

    public void setDetails(OrderDetail3[] details) {
        this.details = details;
    }
}