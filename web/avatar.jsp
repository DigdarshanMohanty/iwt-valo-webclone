<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("newuser_username") == null) {
        response.sendRedirect("login.html");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Choose Your Avatar</title>
    <style>
        body { font-family: sans-serif; text-align: center; margin-top: 50px; background-color: #f0f2f5; }
        h1 { color: #333; }
        .avatar-grid {
            display: grid;
            grid-template-columns: repeat(9, 1fr);
            gap: 15px;
            width: 80%;
            max-width: 900px;
            margin: 30px auto;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .avatar-item {
            border: 2px solid transparent;
            border-radius: 50%;
            overflow: hidden;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .avatar-item:hover {
            border-color: red;
            transform: scale(1.1);
        }
        .avatar-item img {
            width: 100%;
            height: 100%;
            display: block;
        }
        input[type="radio"] {
            display: none;
        }
        input[type="radio"]:checked + label {
            border-color: red;
            transform: scale(1.1);
            box-shadow: 0 0 10px rgba(255,0,0,0.5);
        }
        .button {
            height: 45px;
            width: 300px;
            border-radius: 15px;
            border: none;
            background-color: red;
            color: white;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            margin-top: 20px;
        }
    </style>
</head>
<body>

    <h1>Welcome, <%= session.getAttribute("newuser_username") %>!</h1>
    <h2>Choose your avatar</h2>

    <form action="save_avatar.jsp" method="post">
        <div class="avatar-grid">
            <%
                //looping 45 times to display all avatars
                for (int i = 1; i <= 45; i++) {
                    String avatarFilename = "avatar1/" + i + ".jpeg";
            %>
                <div>
                    <input type="radio" name="avatar" value="<%= avatarFilename %>" id="avatar<%= i %>" required>
                    
                    <label class="avatar-item" for="avatar<%= i %>">
                        <img src="<%= avatarFilename %>" alt="Avatar <%= i %>">
                    </label>
                </div>
            <%
                }
            %>
        </div>
        
        <button type="submit" class="button">Save Avatar</button>
    </form>

</body>
</html>