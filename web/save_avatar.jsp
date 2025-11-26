<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%
    String username = (String) session.getAttribute("newuser_username");
    String avatarFile = request.getParameter("avatar");

    if (username == null || avatarFile == null) {
        response.sendRedirect("login.html");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    boolean updateSuccess = false;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/riot_project", "root", "");


        String sql = "UPDATE users SET avatar = ? WHERE username = ?";
        
        ps = conn.prepareStatement(sql);
        ps.setString(1, avatarFile);
        ps.setString(2, username);

        int rowsAffected = ps.executeUpdate();
        if (rowsAffected > 0) {
            updateSuccess = true;
        }

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("avatar.jsp?error=1");
        return;
    } finally {
        try { if (ps != null) ps.close(); } catch (SQLException e) {}
        try { if (conn != null) conn.close(); } catch (SQLException e) {}
    }

    session.removeAttribute("newuser_username");

    if (updateSuccess) {
        response.sendRedirect("login.html?signup=success");
    } else {
        response.sendRedirect("avatar.jsp?error=1");
    }
    return;
%>