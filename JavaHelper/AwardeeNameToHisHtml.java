import java.io.*;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.stream.Stream;

/**
 * Created by lizichen1 on 3/16/17.
 */
public class AwardeeNameToHisHtml {

    /**
     * WARNING! JAVA WRITE FILE HAS BYTE LIMITATION!
     */

    private final static String ONE =   "https://www.scopus.com/results/authorNamesList.uri?origin=searchauthorlookup&src=al&edit=&poppUp=&basicTab=&affiliationTab=&advancedTab=&st1=";
    private final static String TWO =   "&st2=";
    private final static String THREE = "&institute=&orcidId=&authSubject=LFSC&_authSubject=on&authSubject=HLSC&_authSubject=on&authSubject=PHSC&_authSubject=on&authSubject=SOSC&_authSubject=on&s=AUTH--LAST--NAME%28";
    private final static String FOUR =  "%29+AND+AUTH--FIRST%28";
    private final static String FIVE =  "%29&sdt=al&sot=al&searchId=AE334DA44451A833E5056C31C4A03CB0.wsnAw8kcdt7IPYLO0V48gA%3A100&exactSearch=off&sid=AE334DA44451A833E5056C31C4A03CB0.wsnAw8kcdt7IPYLO0V48gA%3A100";

    public static void main(String[] args) {

        String src_file = "../collaboration_networks/Data_Scrapping_And_PreProcess/missing-awardee-names_mar17.txt";
        String url_file = "missing_awardee_htmls_682.txt";

        File fout = new File(url_file);

        int writtenlines = 0;

        try (BufferedReader br = new BufferedReader(new FileReader(src_file))) {
            FileOutputStream fos = new FileOutputStream(fout);
            BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(fos));

            String line;
            while ((line = br.readLine()) != null) {
                System.out.print(line+" ");
                String firstname = line.split("_")[0];
                String lastname = line.split("_")[1];

                line = ONE
                        + lastname
                        + TWO
                        + firstname
                        + THREE
                        + lastname
                        + FOUR
                        + firstname
                        + FIVE;

                System.out.println(line.length());
                bw.write(line);

                bw.newLine();
                writtenlines++;
            }
            bw.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        System.out.println("Number of written lines: "+writtenlines);
    }
}


