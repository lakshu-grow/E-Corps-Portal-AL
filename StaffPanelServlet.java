package Weblayer;

import java.io.*;
import java.sql.*;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/StaffPanelServlet")
public class StaffPanelServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/corps","root","");

            String sql = "SELECT c.reg_no, c.cadet_name, " +
                         "COALESCE(COUNT(a.id),0) AS total_days, " +
                         "COALESCE(SUM(CASE WHEN a.status='Present' THEN 1 ELSE 0 END),0) AS present_days, " +
                         "COALESCE(SUM(CASE WHEN a.status='Absent' THEN 1 ELSE 0 END),0) AS absent_days, " +
                         "CASE WHEN COUNT(a.id)=0 THEN 0 ELSE " +
                         "ROUND(SUM(CASE WHEN a.status='Present' THEN 1 ELSE 0 END)*100.0/COUNT(a.id),2) END AS attendance_percent " +
                         "FROM cadet_details c " +
                         "LEFT JOIN attendance a ON c.reg_no=a.reg_no " +
                         "GROUP BY c.reg_no, c.cadet_name " +
                         "ORDER BY c.reg_no";

            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            List<Map<String,Object>> attendanceList = new ArrayList<>();
            while (rs.next()) {
                Map<String,Object> row = new HashMap<>();
                row.put("reg_no", rs.getString("reg_no"));
                row.put("cadet_name", rs.getString("cadet_name"));
                row.put("total_days", rs.getInt("total_days"));
                row.put("present_days", rs.getInt("present_days"));
                row.put("absent_days", rs.getInt("absent_days"));
                row.put("attendance_percent", rs.getDouble("attendance_percent"));
                attendanceList.add(row);
            }

            request.setAttribute("attendanceList", attendanceList);
            RequestDispatcher rd = request.getRequestDispatcher("StaffPanel.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Error fetching attendance", e);
        } finally {
            try { if (con!=null) con.close(); } catch(SQLException ignored){}
        }
    }
}
