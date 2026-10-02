package com.chat;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");

        if (username == null || username.trim().isEmpty()) {
            response.getWriter().println("Please enter username");
            return;
        }

        username = username.trim();

        try (Connection con = DBConnection.getConnection()) {

            String sql = "SELECT username FROM users WHERE username = ?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                HttpSession session = request.getSession();
                session.setAttribute("username", username);

                response.sendRedirect("chat.jsp");

            } else {

                response.setContentType("text/html");
                response.getWriter().println(
                    "<h3>Invalid username</h3>" +
                    "<a href='login.jsp'>Go Back</a>"
                );
            }

        } catch (SQLException e) {

            e.printStackTrace();

            response.getWriter().println(
                "Database connection error: " + e.getMessage()
            );
        }
    }
}