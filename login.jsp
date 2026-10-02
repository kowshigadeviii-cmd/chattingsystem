<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>

    <title>Chat System - Login</title>

    <link rel="stylesheet" href="style.css">

</head>

<body>

<div class="login-container">

    <h1>💬 Chat System</h1>

    <p>Login to start chatting</p>

    <form action="login" method="post">

        <input
            type="text"
            name="username"
            placeholder="Enter username"
            required
        >

        <button type="submit">
            Login
        </button>

    </form>

    <p class="users">
        Available users: Kowshika, Arun, Priya
    </p>

</div>

</body>
</html>