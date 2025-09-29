package Weblayer;

import java.io.InputStream;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

public class RSSReader {

    public static List<Article> read(String feedUrl) {
        List<Article> articles = new ArrayList<>();

        try {
            URL url = new URL(feedUrl);
            InputStream stream = url.openStream();

            Document doc = DocumentBuilderFactory.newInstance()
                              .newDocumentBuilder()
                              .parse(stream);
            doc.getDocumentElement().normalize();

            NodeList items = doc.getElementsByTagName("item");

            for (int i = 0; i < items.getLength(); i++) {
                Element item = (Element) items.item(i);

                String title = getTagValue("title", item);
                String link = getTagValue("link", item);
                String description = getTagValue("description", item);
                String pubDate = getTagValue("pubDate", item);

                articles.add(new Article(title, link, description, pubDate));
            }

            stream.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return articles;
    }

    private static String getTagValue(String tag, Element element) {
        NodeList nl = element.getElementsByTagName(tag);
        if (nl != null && nl.getLength() > 0) {
            return nl.item(0).getTextContent();
        }
        return "";
    }
}
