<%@ page import="java.sql.*, java.util.*" %>
<%
    request.setCharacterEncoding("UTF-8");

    // ✅ Get username from session
    String username = (String) session.getAttribute("username");

    String reg_no = "";
    String cadetName = "";
    int percentage = -1;
    int absentPercent = 0;
    List<String> absentDates = new ArrayList<>();
    String error = "";

    if (username != null) {   // user logged in
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/corps","root","");

            // 1️⃣ Get cadet details
            ps = con.prepareStatement("SELECT reg_no, cadet_name, attendance_percent FROM cadet_details WHERE cadet_name=?");
            ps.setString(1, username);
            rs = ps.executeQuery();

            if (rs.next()) {
                reg_no = rs.getString("reg_no");
                cadetName = rs.getString("cadet_name");
                percentage = rs.getInt("attendance_percent");
                absentPercent = 100 - percentage;
            }

            // 2️⃣ Get absent dates
            ps = con.prepareStatement("SELECT date FROM attendance WHERE reg_no=? AND status='Absent' ORDER BY date ASC");
            ps.setString(1, reg_no);
            rs = ps.executeQuery();
            while (rs.next()) {
                absentDates.add(rs.getString("date"));
            }

        } catch (Exception e) {
            error = "Error: " + e.getMessage();
        }
    } else {
        // user not logged in
        response.sendRedirect("Login.html");
    }
%>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Attendance</title>
    <link rel="stylesheet" href="attendance.css">
</head>
<body>
<div class="view-attendance-container">

    <div class="user-header">
        <h1>My Attendance</h1>
        <div>
          <a href="Cadet.jsp">Back</a> |
          <a href="LogoutServlet">Logout</a>
        </div>
    </div>

    <% if(!error.isEmpty()){ %>
       <p style="color:red;"><%=error%></p>
    <% } else { %>

        <div class="circle" style="--present:<%=percentage%>; --absent:<%=absentPercent%>;">
          <div class="circle-text">
            <%=percentage%>% Present
            <br>
            <span><%=absentPercent%>% Absent</span>
          </div>
        </div>
        <h2 style="text-align:center;"><%=cadetName%></h2>

        <h3 class="absent-title">Absent Dates</h3>
        <table>
            <tr><th>Date</th></tr>
            <% for(String d : absentDates){ %>
                <tr><td><%=d%></td></tr>
            <% } if(absentDates.size()==0){ %>
                <tr><td>No Absents 🎉</td></tr>
            <% } %>
        </table>
    <% } %>

</div>
</body>
</html>
