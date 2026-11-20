package model;

public class FullName3 {
    private int id;
    private String lastName;
    private String middleName;
    private String firstName;

    public FullName3() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getMiddleName() {
        return middleName;
    }

    public void setMiddleName(String middleName) {
        this.middleName = middleName;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    @Override
    public String toString() {
        StringBuilder fullName = new StringBuilder();

        if (lastName != null && !lastName.isBlank()) {
            fullName.append(lastName.trim());
        }

        if (middleName != null && !middleName.isBlank()) {
            if (fullName.length() > 0) {
                fullName.append(" ");
            }
            fullName.append(middleName.trim());
        }

        if (firstName != null && !firstName.isBlank()) {
            if (fullName.length() > 0) {
                fullName.append(" ");
            }
            fullName.append(firstName.trim());
        }

        return fullName.toString();
    }
}