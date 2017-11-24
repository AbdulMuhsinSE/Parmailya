package parmailya_util;

import java.sql.Timestamp;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ParmaLogger {
    private static Logger logger = Logger.getLogger("Parma");

    public static void logERROR(String errorString) {
        logger.log(Level.SEVERE, new Timestamp(System.currentTimeMillis()).toString() + ": " + errorString);
    }

    public static void logWARN(String warnString) {
        logger.log(Level.WARNING, new Timestamp(System.currentTimeMillis()).toString() + ": " + warnString);
    }

    public static void logINFO(String infoString) {
        logger.log(Level.INFO, new Timestamp(System.currentTimeMillis()).toString() + ": " + infoString);
    }
}
