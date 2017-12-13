package parmailya_util;


import javafx.collections.FXCollections;
import javafx.collections.ObservableList;

import java.io.*;
import java.util.ArrayList;
import java.util.Properties;

public class MenuPropertyManager {

    private MenuPropertyManager() {}

    public static String getProperty(String toFetch){
         try {
             InputStream propsInput = new FileInputStream ("config.properties");
             Properties prop = new Properties();
             prop.load(propsInput);
             ParmaLogger.logINFO("Attempt to retrieve property: " + toFetch);
             return prop.getProperty(toFetch);

         } catch (FileNotFoundException e) {
             ParmaLogger.logERROR(e.toString() + "-" + e.getMessage());
         } catch (IOException err) {
             ParmaLogger.logERROR(err.toString() + "-" + err.getMessage());
         }
         return "";
    }

    public static ObservableList<String> getMenu(String menu) {
        try {
            InputStreamReader menuInput = new InputStreamReader(new FileInputStream("src/res/menu/"+menu));
            BufferedReader br = new BufferedReader(menuInput);
            String toAdd = "";
            ObservableList<String> menuItems = FXCollections.observableArrayList();

            while((toAdd = br.readLine())!=null) {
                menuItems.add(toAdd);
            }

            if(menuItems.isEmpty()) {
                ParmaLogger.logWARN("Something wrong here? Why would we have an empty menu?");
            } else {
                ParmaLogger.logINFO("Retrieved menu with: " + menuItems.size() + " items");
            }

            return menuItems;

        } catch (FileNotFoundException e) {
            ParmaLogger.logERROR(e.toString() + "-" + e.getMessage());
        } catch (IOException ex) {
            ParmaLogger.logERROR(ex.toString() + "-" + ex.getMessage());
        }
        return null;
    }


}
