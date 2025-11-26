<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%
    String loginError = "";
    
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String id = request.getParameter("userId");
        String pass = request.getParameter("userPass");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        boolean loginSuccess = false;

        try {            
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/riot_project?useSSL=false","root","");

            String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, id);
            ps.setString(2, pass);
            rs = ps.executeQuery();

            if (rs.next()) {
                loginSuccess = true;
            }

        } catch (Exception e) {
            loginError = "Error: " + e.getMessage();
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }

        if (loginSuccess) {
            session.setAttribute("username", id);
            response.sendRedirect("home.jsp");
            return;
        } else if (loginError.isEmpty()) {
            loginError = "Invalid username or password.";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Login Processing</title>
    <style>
        body { font-family: sans-serif; text-align: center; margin-top: 50px; }
        h2 { color: #D32F2F; }
        p { font-size: 16px; }
        a { color: #007bff; text-decoration: none; font-weight: bold; }
        a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <%
        if (!loginError.isEmpty()) {
            out.println("<h2>" + loginError + "</h2>");
            out.println("<p><a href='login.html'>Try again</a></p>");
            out.println("<p>Don't have an account? <a href='signup.html'>Create one now</a></p>");
        }
    %>
</body>
</html>