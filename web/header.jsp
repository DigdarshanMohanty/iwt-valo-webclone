<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String username = (String) session.getAttribute("username");
    String avatar = (String) session.getAttribute("avatar");
%>
<header class="main-header">
    <div class="container">
        <nav class="main-nav">
<a href="home.jsp">
    <svg class="riot-logo" role="img" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
        <title>Riot Games</title>
        <path d="M12.534 21.77l-1.09-2.81 10.52.54-.451 4.5zM15.06 0L.307 6.969 2.59 17.471H5.6l-.52-7.512.461-.144 1.81 7.656h3.126l-.116-9.15.462-.144 1.582 9.294h3.31l.78-11.053.462-.144.82 11.197h4.376l1.54-15.37Z" fill="#ff0000"></path>
    </svg>
</a>
            <ul class="nav-links">
                <li><a href="#">Events</a></li>
                <li><a href="#games">Our Games</a></li>
                <li><a href="#news">News</a></li>
                <li style="color: cyan;"><a href="https://riot-ping-checker-8fpr.vercel.app/">Check Ping</a></li>
            </ul>
            <div class="nav-actions">
                <%
                if (username != null) {
                %>
                    <a href="profile.jsp" class="user-avatar-link">
                        <img src="avatar1/<%= avatar %>" alt="Avatar">
                        <%= username %>
                    </a>
                <%
                } else {
                %>
                    <a href="login.html" class="btn btn-primary">Sign In</a>
                <%
                }
                %>
            </div>
        </nav>
    </div>
</header>
