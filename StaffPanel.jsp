<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%
    List<Map<String, Object>> attendanceList = 
        (List<Map<String, Object>>) request.getAttribute("attendanceList");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Staff Panel - Cadet Attendance</title>
  <link rel="stylesheet" href="panel.css">
</head>
<body>
  <div class="header">
    <h1>Staff Panel - Cadet Attendance</h1>
    <a href="Staff.html" class="back-btn">← Back to Dashboard</a>
  </div>

  <h2>📊 Attendance Percentage</h2>

  <table class="styled-table">
    <thead>
      <tr>
        <th>Cadet Reg No</th>
        <th>Cadet Name</th>
        <th>Total Days</th>
        <th>Present</th>
        <th>Absent</th>
        <th>Attendance %</th>
      </tr>
    </thead>
    <tbody>
    <%
      if (attendanceList != null && !attendanceList.isEmpty()) {
          for (Map<String, Object> row : attendanceList) {
    %>
        <tr>
          <td><%= row.get("reg_no") %></td>
          <td><%= row.get("cadet_name") %></td>
          <td><%= row.get("total_days") %></td>
          <td><%= row.get("present_days") %></td>
          <td><%= row.get("absent_days") %></td>
          <td><%= row.get("attendance_percent") %> %</td>
        </tr>
    <%
          }
      } else {
    %>
        <tr><td colspan="6">⚠ No attendance records found</td></tr>
    <%
      }
    %>
    </tbody>
  </table>
</body>
</html>
