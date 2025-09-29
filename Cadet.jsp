<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Get session values
    HttpSession sess = request.getSession(false);
    String cadetName = null;
    String regNo = null;
    if (sess != null) {
        cadetName = (String) sess.getAttribute("cadet_name");
        regNo = (String) sess.getAttribute("reg_no"); // set at login if you have it
    }

    if (cadetName == null || cadetName.isEmpty()) {
        response.sendRedirect("Login.html");
        return;
    }

    // build photo path dynamically based on reg_no
    String photoPath = (regNo != null)
            ? "cadet_photos/" + regNo + ".jpg"
            : "cadet_photos/default.jpg";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Cadet Dashboard</title>
  <link rel="stylesheet" href="dashboard.css">
  <style>
    /* Circle photo style */
    .profile-circle {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      object-fit: cover;
      border: 2px solid #fff;
      vertical-align: middle;
      margin-right: 6px;
    }
    .user-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      background: #006699;
      padding: 15px;
      color: #fff;
      font-family: "Segoe UI", Arial, sans-serif;
    }
    .user-header h1 {
      margin: 0;
    }
    .welcome-box {
      display: flex;
      align-items: center;
      gap: 5px;
    }
  </style>
</head>
<body>
  <div class="user-header">
    <h1>Cadet Dashboard</h1>
    <div class="welcome-box">
      <a href="CadetProfileServlet"><img src="<%= photoPath %>" alt="Profile" class="profile-circle">
      <span><%= cadetName %></span> |</a>
      <a href="LogoutServlet" style="color:white;">Logout</a>
    </div>
  </div>
  <h2 style="text-align:center; margin-top:20px; color:#006699;">NCC Event Highlights</h2>
<!-- Slideshow Section -->



  <div class="user-container">
    <div class="user-card">
      <h3>Attendance</h3>
      <p>View your attendance record.</p>
      <a href="ViewAttendance.jsp">Go →</a>
    </div>

    <div class="user-card">
      <h3>Competitions</h3>
      <p>Learning for 14 competitions.</p>
      <a href="CadetCompetition.html">Go →</a>
    </div>


    <div class="user-card">
      <h3>Defence News</h3>
      <p>See latest defence announcements.</p>
      <a href="ViewNews.jsp">Go →</a>
    </div>
  </div>
  <script>
let slideIndex = 0;
showSlides();

function showSlides() {
  let i;
  let slides = document.getElementsByClassName("mySlides");
  for (i = 0; i < slides.length; i++) {
    slides[i].style.display = "none";  
  }
  slideIndex++;
  if (slideIndex > slides.length) {slideIndex = 1}    
  slides[slideIndex-1].style.display = "block";  
  setTimeout(showSlides, 3000); // Change slide every 3 seconds
}
</script>
  
</body>
</html>
