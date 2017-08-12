import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.stream.Stream;

/**
 * Created by lizichen1 on 2/28/17.
 */
public class CsvToHtml {

    private final static String ONE = "https://www.scopus.com/results/authorNamesList.uri?origin=searchauthorlookup&src=al&edit=&poppUp=&basicTab=&affiliationTab=&advancedTab=&st1=";
    private final static String TWO = "&st2=";
    private final static String THREE = "&institute=&orcidId=&authSubject=LFSC&_authSubject=on&authSubject=HLSC&_authSubject=on&authSubject=PHSC&_authSubject=on&authSubject=SOSC&_authSubject=on&s=AUTH--LAST--NAME%28";
    private final static String FOUR = "%29+AND+AUTH--FIRST%28";
    private final static String FIVE = "%29&sdt=al&sot=al&searchId=289973FBE5588B66CF9987EB31BCF573.wsnAw8kcdt7IPYLO0V48gA%3A60&exactSearch=off&sid=289973FBE5588B66CF9987EB31BCF573.wsnAw8kcdt7IPYLO0V48gA%3A60";

    public static void main(String[] args) {

        String csv_file = "investigator.csv";
        String url_file = "authors_urls";

        File fout = new File(url_file+"1.txt");

        try (BufferedReader br = new BufferedReader(new FileReader(csv_file))) {
            FileOutputStream fos = new FileOutputStream(fout);
            BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(fos));

            String line;
            int i = 1;
            while ((line = br.readLine()) != null) {
                String firstname = line.split(",")[1];
                String lastname = line.split(",")[2];
                firstname = firstname.substring(1, firstname.length()-1);
                lastname = lastname.substring(1, lastname.length()-1);

                line = ONE
                        +lastname
                        +TWO
                        +firstname
                        +THREE
                        +lastname
                        +FOUR
                        +firstname
                        +FIVE;

                bw.write(line);
                bw.newLine();
                i++;
                if(i%3500 == 0){
                    bw.close();
                    int j = i / 3500;
                    fout = new File(url_file+j+".txt");
                    fos = new FileOutputStream(fout);
                    bw = new BufferedWriter(new OutputStreamWriter(fos));
                }
            }
            bw.close();
        } catch (IOException e) {
            e.printStackTrace();
        }


    }
}
