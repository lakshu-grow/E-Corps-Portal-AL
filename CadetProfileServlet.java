package Weblayer;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
@WebServlet("/CadetProfileServlet")
public class CadetProfileServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String cadetName = (session != null) ? (String) session.getAttribute("cadet_name") : null;

        if (cadetName == null || cadetName.isEmpty()) {
            response.sendRedirect("Login.html");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/corps", "root", "")) {

                String sql = "SELECT cadet_name, reg_no, email FROM cadet_details WHERE cadet_name=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, cadetName);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    request.setAttribute("cadet_name", rs.getString("cadet_name"));
                    request.setAttribute("reg_no", rs.getString("reg_no"));
                    request.setAttribute("email", rs.getString("email"));

                    // Photo from folder only
                    String photoPath = "cadet_photos/" + rs.getString("reg_no") + ".jpg";
                    request.setAttribute("photoPath", photoPath);
                }
            }

            RequestDispatcher rd = request.getRequestDispatcher("Profile.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Error fetching cadet profile", e);
        }
    }
}
