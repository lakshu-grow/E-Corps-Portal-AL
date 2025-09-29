<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, Weblayer.Article" %>
<%
    List<Article> articles = (List<Article>) request.getAttribute("articles");

    // ✅ If no articles (first visit), redirect to indiaNews servlet
    if (articles == null) {
        response.sendRedirect(request.getContextPath() + "/indiaNews");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cadet Defence News</title>
    <link rel="stylesheet" type="text/css" href="news.css">
</head>
<body>
    <!-- ✅ Same Navbar -->
    <div class="navbar">
        <a href="<%=request.getContextPath()%>/indiaNews" class="active">🔄 Refresh News</a>
        <a href="Links.html">🌐 Useful Links</a>
        <a href="Cadet.html" class="dashboard-btn">🏠 Back to Dashboard</a>
    </div>

    <!-- ✅ Page Title -->
    <h2 class="page-title">🪖 Cadet Defence News</h2>

    <!-- ✅ News List -->
    <div class="news-list">
    <% if (!articles.isEmpty()) {
         for (Article a : articles) { %>
        <div class="news-card">
            <h3><a href="<%=a.getLink()%>" target="_blank"><%=a.getTitle()%></a></h3>
            <p><%=a.getDescription()%></p>
            <small><%=a.getPubDate()%></small>
        </div>
    <%   }
       } else { %>
        <p class="no-news">⚠ No news found. Please try again later.</p>
    <% } %>
    </div>
</body>
</html>
