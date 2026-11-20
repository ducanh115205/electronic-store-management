package model;

import java.util.Date;

public class Invoice3 {
    private int id;
    private Date createdDate;
    private String purchaseType;
    private double totalAmount;
    private Order3 order;
    private Employee3 createdBy;
    private InvoiceDetail3[] details;

    public Invoice3() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public String getPurchaseType() {
        return purchaseType;
    }

    public void setPurchaseType(String purchaseType) {
        this.purchaseType = purchaseType;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public Order3 getOrder() {
        return order;
    }

    public void setOrder(Order3 order) {
        this.order = order;
    }

    public Employee3 getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Employee3 createdBy) {
        this.createdBy = createdBy;
    }

    public InvoiceDetail3[] getDetails() {
        return details;
    }

    public void setDetails(InvoiceDetail3[] details) {
        this.details = details;
    }
}