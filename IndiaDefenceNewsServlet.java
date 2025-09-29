package Weblayer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/indiaNews")
public class IndiaDefenceNewsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // RSS feed URL
        String feedUrl = "https://theprint.in/category/defence/feed/";

        List<Article> articles = RSSReader.read(feedUrl);

        request.setAttribute("articles", articles);
        request.getRequestDispatcher("IndiaNews.jsp").forward(request, response);
    }
}
