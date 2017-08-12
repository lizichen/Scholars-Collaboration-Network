import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

/**
 * Created by lizichen1 on 3/3/17.
 */
public class RetrieveAuthorPublicationURL {
    public static void main(String[] args) throws IOException {

        String file = args[0];
        String pre_url = "https://www.scopus.com/onclick/export.uri?oneClickExport=%7b%22Format%22%3a%22CSV%22%2c%22View%22%3a%22CiteOnly%22%7d&origin=AuthorProfile&zone=resultsListHeader&dataCheckoutTest=false&sort=plf-f&tabSelected=docLi&authorId=";
        String post_url = "&txGid=EDC2B2AFFD9E4AC24F0282233C3C7CCC.wsnAw8kcdt7IPYLO0V48gA%3a73";
//              System.out.println(pre_url + SID + post_url);


        try (BufferedReader br = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = br.readLine()) != null) {
                String SID = line;
                System.out.println(pre_url + SID + post_url);

            }
        }

    }
}
