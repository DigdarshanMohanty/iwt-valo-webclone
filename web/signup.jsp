<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.io.*" %>

<%
String errorMessage = "";
if ("POST".equalsIgnoreCase(request.getMethod())) {
    String user = request.getParameter("username");
    String tag = request.getParameter("Email");
    String pass1 = request.getParameter("password");
    String pass2 = request.getParameter("confirm_password");

    if (user == null || tag == null || pass1 == null || pass2 == null ||
        user.isEmpty() || tag.isEmpty() || pass1.isEmpty() || pass2.isEmpty()) {
        errorMessage = "Error: All fields are required.";
    } else if (!pass1.equals(pass2)) {
        errorMessage = "Error: Passwords do not match.";
    } else {
        Connection con = null;
        PreparedStatement ps = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String jdbcUrl = "jdbc:mysql://127.0.0.1:3306/riot_project?useSSL=false&serverTimezone=UTC";
            con = DriverManager.getConnection(jdbcUrl, "root", "");

            String sql = "INSERT INTO users (username, Email, password) VALUES (?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setString(1, user);
            ps.setString(2, tag);
            ps.setString(3, pass1);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                HttpURLConnection conn = null;
                try {
                    URL url = new URL("http://127.0.0.1:5000/send-welcome");
                    conn = (HttpURLConnection) url.openConnection();
                    conn.setRequestMethod("POST");
                    conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
                    conn.setConnectTimeout(5000);
                    conn.setReadTimeout(5000);
                    conn.setDoOutput(true);
                    String json = String.format("{\"user_id\":\"%s\"}", tag.replace("\"", "\\\""));

                    OutputStream os = conn.getOutputStream();
                    try {
                        os.write(json.getBytes("UTF-8"));
                        os.flush();
                    } finally {
                        os.close();
                    }

                    int code = conn.getResponseCode();
                    InputStream is = (code >= 200 && code < 300) ? conn.getInputStream() : conn.getErrorStream();
                    StringBuilder resp = new StringBuilder();
                    if (is != null) {
                        BufferedReader br = new BufferedReader(new InputStreamReader(is, "UTF-8"));
                        try {
                            String line;
                            while ((line = br.readLine()) != null) resp.append(line);
                        } finally {
                            br.close();
                        }
                    }
                    if (code / 100 != 2) {
                        System.err.println("Automator call failed: HTTP " + code + " - " + resp.toString());
                    } else {
                        System.out.println("Automator response: " + resp.toString());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (conn != null) conn.disconnect();
                }

                session.setAttribute("newuser_username", user);
                response.sendRedirect("avatar.jsp");
                return;
            } else {
                errorMessage = "Error: Account could not be created. Please try again.";
            }
        } catch (SQLException e) {
            errorMessage = e.getErrorCode() == 1062
                ? "Error: This username or email is already taken."
                : "Database Error: " + e.getMessage();
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            errorMessage = "Driver Error: " + e.getMessage();
            e.printStackTrace();
        } catch (Exception e) {
            errorMessage = "Error: " + e.getMessage();
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) { }
            try { if (con != null) con.close(); } catch (SQLException e) { }
        }
    }
}
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Account Creation</title>
    <style>
        body { font-family: sans-serif; text-align: center; margin-top: 50px; }
        .message { padding: 20px; border-radius: 5px; display: inline-block; }
        .error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        a { color: #007bff; text-decoration: none; font-weight: bold; }
        pre { text-align: left; display:inline-block; }
    </style>
</head>
<body>
    <h2>Sign Up</h2>
    <% if (!errorMessage.isEmpty()) { %>
        <div class="message error"><%= errorMessage %> <a href="signup.html">Go Back</a></div>
    <% } %>
</body>
</html>