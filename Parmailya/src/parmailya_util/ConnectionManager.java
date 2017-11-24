package parmailya_util;


public class ConnectionManager {
    private static ConnectionManager connectionManager;

    private ConnectionManager() {}

    public static ConnectionManager getInstance() {
        if (connectionManager==null) {
            connectionManager = new ConnectionManager();
        }
        return connectionManager;
    }

    public boolean validateUser(String uname, String hash) {
        ParmaLogger.logINFO("Login Attempt");
        return true;
    }

}
