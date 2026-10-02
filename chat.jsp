<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.chat.DBConnection" %>

<%
    String username = (String) session.getAttribute("username");

    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>

<head>

    <title>Chat System</title>

    <link rel="stylesheet" href="style.css">

</head>

<body>

<div class="chat-container">

    <div class="chat-header">

        <h2>💬 Chat System</h2>

        <p>
            Logged in as:
            <strong><%= username %></strong>
        </p>

    </div>

    <div class="user-section">

        <label>Select User:</label>

        <select id="receiver">

            <%
                try (Connection con = DBConnection.getConnection()) {

                    String sql =
                        "SELECT username FROM users WHERE username != ?";

                    PreparedStatement ps =
                        con.prepareStatement(sql);

                    ps.setString(1, username);

                    ResultSet rs = ps.executeQuery();

                    while (rs.next()) {
            %>

            <option value="<%= rs.getString("username") %>">
                <%= rs.getString("username") %>
            </option>

            <%
                    }

                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>

        </select>

    </div>

    <div id="messages" class="messages">

        <p class="empty">
            Select a user to view messages.
        </p>

    </div>

    <div class="message-box">

        <input
            type="text"
            id="message"
            placeholder="Type your message..."
        >

        <button onclick="sendMessage()">
            Send
        </button>

    </div>

</div>


<script>

let receiver = document.getElementById("receiver");

receiver.addEventListener("change", function() {
    loadMessages();
});

function sendMessage() {

    let messageBox = document.getElementById("message");

    let message = messageBox.value.trim();

    let selectedUser = receiver.value;

    if (message === "") {
        alert("Please enter a message");
        return;
    }

    let xhr = new XMLHttpRequest();

    xhr.open("POST", "chat", true);

    xhr.setRequestHeader(
        "Content-Type",
        "application/x-www-form-urlencoded"
    );

    xhr.onload = function() {

        if (xhr.status === 200) {

            messageBox.value = "";

            loadMessages();
        }
    };

    xhr.send(
        "receiver=" +
        encodeURIComponent(selectedUser) +
        "&message=" +
        encodeURIComponent(message)
    );
}


function loadMessages() {

    let selectedUser = receiver.value;

    if (!selectedUser) {
        return;
    }

    let xhr = new XMLHttpRequest();

    xhr.open(
        "GET",
        "chat?receiver=" +
        encodeURIComponent(selectedUser),
        true
    );

    xhr.onload = function() {

        if (xhr.status === 200) {

            document.getElementById("messages").innerHTML =
                xhr.responseText;

            let messages =
                document.getElementById("messages");

            messages.scrollTop = messages.scrollHeight;
        }
    };

    xhr.send();
}


// Automatically refresh messages every 2 seconds
setInterval(loadMessages, 2000);

loadMessages();

</script>

</body>
</html>