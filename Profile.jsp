<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cadet Profile</title>
    <link rel="stylesheet" href="profile.css">
</head>
<body>
<div class="profile-container">
    <h1>Cadet Profile</h1>
    <div class="profile-card">
        <img src="${photoPath}" alt="Cadet Photo" class="profile-photo"/>
        <div class="profile-info">
            <p><strong>Name:</strong> ${cadet_name}</p>
            <p><strong>Reg No:</strong> ${reg_no}</p>
            <p><strong>Email:</strong> ${email}</p>
            <a href="Cadet.jsp" class="back-btn">← Back to Dashboard</a>
        </div>
    </div>
</div>
</body>
</html>
