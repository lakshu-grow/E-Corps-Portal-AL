package Weblayer;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/Validation")
public class Validation extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String user = request.getParameter("uname");
        String pass = request.getParameter("pwd");

        try {
            // admin login
            if (user.equals("staff") && pass.equals("staff123")) {
                // browser URL will change to Staff.html
                response.sendRedirect("Staff.html");
                return;
            }

            // cadet login
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/corps", "root", "");

            String sql = "SELECT username, password FROM register WHERE username = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, user);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String dbUser = rs.getString("username");
                String dbPass = rs.getString("password");

                if (user.equals(dbUser) && pass.equals(dbPass)) {
                    // ✅ session for cadet_name/reg_no/email
                    HttpSession session = request.getSession();
                    session.setAttribute("cadet_name", user);

                    // fetch reg_no from cadet_details
                    String sql2 = "SELECT reg_no, email FROM cadet_details WHERE cadet_name = ?";
                    PreparedStatement ps2 = con.prepareStatement(sql2);
                    ps2.setString(1, user);
                    ResultSet rs2 = ps2.executeQuery();
                    if (rs2.next()) {
                        String reg = rs2.getString("reg_no");
                        String email = rs2.getString("email");
                        session.setAttribute("reg_no", reg);
                        session.setAttribute("email", email);
                    }

                    // ✅ second session attribute (if you need it separately)
                    HttpSession session1 = request.getSession();
                    session1.setAttribute("username", user);

                    // ✅ redirect to Cadet.jsp so URL changes
                    response.sendRedirect("Cadet.jsp");
                } else {
                    // password incorrect
                    response.sendRedirect("Login.html?error=1");
                }
            } else {
                // username not found
                response.sendRedirect("Login.html?error=1");
            }

            con.close();
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
        }
    }
}
