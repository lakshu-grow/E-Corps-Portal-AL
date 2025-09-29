package Weblayer;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/ListFilesServlet")
public class ListFilesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String comp = request.getParameter("comp"); // Drill, Ship Modeling, etc.
        if (comp == null || comp.trim().isEmpty()) {
            response.setContentType("application/json");
            response.getWriter().write("[]");
            return;
        }

        // Normalize folder name: replace spaces with underscores
        String folderName = comp.trim().replaceAll(" ", "_"); // e.g., "Ship Modeling" -> "Ship_Modeling"

        // Get real path of competition folder in webapp
        String folderPath = getServletContext().getRealPath("/competitions/" + folderName);
        File folder = new File(folderPath);
        List<String> files = new ArrayList<>();

        // Check if folder exists
        if (folder.exists() && folder.isDirectory()) {
            File[] fileList = folder.listFiles();
            if (fileList != null) {
                for (File f : fileList) {
                    if (f.isFile()) {
                        // Convert to web-accessible path
                        String webPath = "competitions/" + folderName + "/" + f.getName();
                        files.add(webPath.replace("\\", "/")); // for Windows paths
                    }
                }
            }
        } else {
            System.out.println("Folder not found for competition: " + comp + " at path: " + folderPath);
        }

        // Return JSON manually
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < files.size(); i++) {
            json.append("\"").append(files.get(i)).append("\"");
            if (i < files.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json.toString());
    }
}
