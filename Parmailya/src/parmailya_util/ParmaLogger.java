package parmailya_util;

import java.sql.Timestamp;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ParmaLogger {
    private static final Logger LOGGER = Logger.getLogger("Parma");

    private ParmaLogger(){};

    public static void logERROR(String errorString) {
        LOGGER.log(Level.SEVERE, new Timestamp(System.currentTimeMillis()).toString() + ": " + errorString);
    }

    public static void logWARN(String warnString) {
        LOGGER.log(Level.WARNING, new Timestamp(System.currentTimeMillis()).toString() + ": " + warnString);
    }

    public static void logINFO(String infoString) {
        LOGGER.log(Level.INFO, new Timestamp(System.currentTimeMillis()).toString() + ": " + infoString);
    }
}
