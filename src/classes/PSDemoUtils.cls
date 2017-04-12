public class PSDemoUtils {
    public PSDemoUtils() {

    }

    public static Set<String> parseCSVString(String str) {
        Set<String> optList = new Set<String>();
        for (String key : str.split(',')) {
            optList.add(key.trim().tolowercase());
        }

        return optList;
    }
}