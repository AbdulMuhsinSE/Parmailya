package parmailya_util;


import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import java.util.logging.Logger;

public class PropertyManager {
    private static Logger log = Logger.getLogger("Dev");

    private PropertyManager() {}

    public static String getProperty(String toFetch){
         try {
             InputStream propsInput = new FileInputStream ("config.properties");
             Properties prop = new Properties();
             prop.load(propsInput);
             return prop.getProperty(toFetch);

         } catch (FileNotFoundException e) {
             ParmaLogger.logERROR(e.toString() + "-" + e.getMessage());
         } catch (IOException err) {
             ParmaLogger.logERROR(err.toString() + "-" + err.getMessage());
         }
         return "";
    }



}
