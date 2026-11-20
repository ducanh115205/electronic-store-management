<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.WarehouseStaff3DAO" %>

<%
    request.setCharacterEncoding("UTF-8");

    String errorMessage = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        username = username == null ? "" : username.trim();
        password = password == null ? "" : password;

        if (username.isEmpty() || password.isEmpty()) {
            errorMessage = "Vui lòng nhập tài khoản và mật khẩu.";
        } else {
            try (WarehouseStaff3DAO staffDAO = new WarehouseStaff3DAO()) {
                int staffId = staffDAO.login(username, password);

                if (staffId > 0) {
                    request.changeSessionId();
                    session.setAttribute("warehouseStaffId", staffId);

                    response.sendRedirect("warehouseStaffHome.jsp");
                    return;
                }

                errorMessage = "Tài khoản hoặc mật khẩu không đúng.";

            } catch (Exception e) {
                log("Lỗi đăng nhập nhân viên kho", e);
                errorMessage = "Không thể đăng nhập. Vui lòng thử lại.";
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập nhân viên kho</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
        }

        .container {
            width: 360px;
            margin: 60px auto;
            border: 1px solid #ccc;
            padding: 25px;
        }

        h2 {
            color: #176080;
        }

        label {
            display: block;
            margin-top: 15px;
        }

        input {
            box-sizing: border-box;
            width: 100%;
            padding: 8px;
            margin-top: 6px;
        }

        button {
            margin-top: 20px;
            padding: 8px 16px;
            cursor: pointer;
        }

        .error {
            color: #b00020;
        }
    </style>
</head>

<body>

<div class="container">
    <h2>Đăng nhập nhân viên kho</h2>

    <form action="warehouseStaffLogin.jsp" method="post">
        <label for="username">Tài khoản:</label>
        <input type="text" id="username" name="username">

        <label for="password">Mật khẩu:</label>
        <input type="password" id="password" name="password">

        <button type="submit">Đăng nhập</button>
    </form>

    <% if (errorMessage != null) { %>
        <p class="error"><%= errorMessage %></p>
    <% } %>
</div>

</body>
</html>