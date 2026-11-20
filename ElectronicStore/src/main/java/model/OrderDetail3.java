package model;

public class OrderDetail3 {
    private int id;
    private int quantity;
    private double unitPrice;
    private Product3 product;

    public OrderDetail3() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }

    public Product3 getProduct() {
        return product;
    }

    public void setProduct(Product3 product) {
        this.product = product;
    }
}