package parmailya_util;


import parmailya_datamodel.DataModelEnum;
import parmailya_datamodel.Game;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class ConnectionManager {
    private static ConnectionManager connectionManager;
    private static Connection connection;
    private PreparedStatement preparedStatement;
    private CallableStatement callableStatement;


    private static final String DB_DRIVER = "com.mysql.jdbc.Driver";
    private static final String USER = "root";
    private static final String PWD = "root";

    private static String server = "localhost";
    private static String db = "Parmailya";

    private static String url = "jdbc:mysql://" + server + "/" + db+ "?allowMultiQueries=true&useSSL=false";


    private ConnectionManager() {}

    public static ConnectionManager getInstance() {
        if (connectionManager==null) {
            connectionManager = new ConnectionManager();
        }
        return connectionManager;
    }

    private static boolean prepareConnection() {
        try {
            Class.forName(DB_DRIVER);
            connection = DriverManager.getConnection(url,USER,PWD);
            return true;
        } catch (SQLException e) {
            ParmaLogger.logERROR("Error preparing connection: " + e.getMessage());
            return false;
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            ParmaLogger.logERROR(e.getMessage());
            return false;
        }
    }



    public HashMap<DataModelEnum,String> validateUser(String email, String hash) {
        ParmaLogger.logINFO("Login Attempt");
        HashMap<DataModelEnum,String> user_info = new HashMap<>();
        try {
            if(connection == null) {
                this.prepareConnection();
            }

            connection.setAutoCommit(false);
            callableStatement = null;

            String sql = "{call get_user_info(?,?)}";
            callableStatement = connection.prepareCall(sql);

            callableStatement.setString(1,email);
            callableStatement.setString(2,hash);

            ResultSet rs = callableStatement.executeQuery();
            connection.commit();

            while(rs.next()) {
                user_info.put(DataModelEnum.USER_NAME,rs.getString("username"));
                user_info.put(DataModelEnum.EMAIL_ADDRESS,rs.getString("email"));
                user_info.put(DataModelEnum.DCI_NUMBER,rs.getString("DCI_Number"));
            }

            rs.close();
            callableStatement.close();
            connection.close();
            connection = null;

            if(user_info.isEmpty()) {
                ParmaLogger.logWARN("Login Attempt Failed: Bad Credentials");
                return new HashMap<>();
            } else {
                ParmaLogger.logINFO("Successful Login by User: " + user_info.get(DataModelEnum.USER_NAME));
                return user_info;
            }
        } catch (SQLException e) {

            ParmaLogger.logERROR(e.getMessage());
            if (connection != null) {
                try {
                    ParmaLogger.logWARN("Transaction is being rolled back");
                    connection.rollback();
                } catch(SQLException excep) {
                    ParmaLogger.logERROR(excep.getMessage());
                }
            }
            return null;
        } finally {
            if(connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                    connection = null;
                } catch (SQLException e) {
                    ParmaLogger.logERROR(e.getMessage());
                }
            }
        }
    }

    public boolean createUser(String uname, String hash, String email, String DCI_Number) {
        ParmaLogger.logINFO("Attempt to create user named: " + uname);
        try {
            if(connection == null) {
                this.prepareConnection();
            }

            connection.setAutoCommit(false);
            preparedStatement = null;

            String sql = "insert into Parmailya.User (username,password_hash,email,DCI_Number) values (?,?,?,?)";
            preparedStatement =connection.prepareStatement(sql);

            preparedStatement.setString(1,uname);
            preparedStatement.setString(2,hash);
            preparedStatement.setString(3,email);
            preparedStatement.setString(4,DCI_Number);

            boolean toReturn = preparedStatement.execute();
            connection.commit();
            connection.close();
            connection = null;

            ParmaLogger.logINFO("Attempt to create user named " + uname + " successful.");

            return true;

        } catch (SQLException e) {
            ParmaLogger.logERROR(e.getMessage());
            if (connection != null) {
                try {
                    ParmaLogger.logWARN("Transaction is being rolled back");
                    connection.rollback();
                    return false;
                } catch(SQLException excep) {
                    ParmaLogger.logERROR(excep.getMessage());
                }
            }
            return false;
        } finally {
            if(connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                    connection = null;
                } catch (SQLException e) {
                    ParmaLogger.logERROR(e.getMessage());
                }
            }
        }
    }

    public ArrayList<Game>  getUserGames(String user_email) {
        ArrayList<Game> games = new ArrayList<>();
        try {
            if(connection == null) {
                this.prepareConnection();
            }

            connection.setAutoCommit(false);
            callableStatement = null;

            String sql = "{call get_games(?)}";
            callableStatement = connection.prepareCall(sql);

            callableStatement.setString(1,user_email);

            ResultSet rs = callableStatement.executeQuery();
            connection.commit();

            while(rs.next()) {
                games.add(new Game(rs.getInt("idGame"),rs.getString("name"),rs.getString("description"),rs.getString("email")));
            }

            rs.close();
            callableStatement.close();
            connection.close();
            connection = null;

            if(games.isEmpty()) {
                ParmaLogger.logWARN("No Games Found");
                return new ArrayList<>();
            } else {
                ParmaLogger.logINFO("Found " + games.size() + " games for the current user");
                return games;
            }
        } catch (SQLException e) {

            ParmaLogger.logERROR(e.getMessage());
            if (connection != null) {
                try {
                    ParmaLogger.logWARN("Transaction is being rolled back");
                    connection.rollback();
                } catch(SQLException excep) {
                    ParmaLogger.logERROR(excep.getMessage());
                }
            }
            return null;
        } finally {
            if(connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                    connection = null;
                } catch (SQLException e) {
                    ParmaLogger.logERROR(e.getMessage());
                }
            }
        }
    }

    public void updateGames(String user_email, ArrayList<Game> games) {
        games.forEach(game -> {
            updateGame(user_email,game);
        });
    }

    public void updateGame(String user_email, Game game) {
        try {
            if (connection == null) {
                this.prepareConnection();
            }

            connection.setAutoCommit(false);
            callableStatement = null;

            String sql = "{call create_game_no_image(?,?,?,?)}";
            callableStatement = connection.prepareCall(sql);

            callableStatement.setString(1, user_email);
            callableStatement.setString(2, game.getName());
            callableStatement.setString(3, game.getGame_description());
            callableStatement.setInt(4, game.getGame_id());

            ResultSet rs = callableStatement.executeQuery();
            connection.commit();

            rs.close();
            callableStatement.close();
            connection.close();
            connection = null;

            ParmaLogger.logINFO("Attempt to create game named " + game.getName() + " successful.");
        } catch (SQLException e) {

            ParmaLogger.logERROR(e.getMessage());
            if (connection != null) {
                try {
                    ParmaLogger.logWARN("Transaction is being rolled back");
                    connection.rollback();
                } catch (SQLException excep) {
                    ParmaLogger.logERROR(excep.getMessage());
                }
            }
            return;
        } finally {
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                    connection = null;
                } catch (SQLException e) {
                    ParmaLogger.logERROR(e.getMessage());
                }
            }
        }
    }

    public void deleteGame(Game game) {
        try {
            if (connection == null) {
                this.prepareConnection();
            }

            connection.setAutoCommit(false);
            callableStatement = null;

            String sql = "{call delete_game(?)}";
            callableStatement = connection.prepareCall(sql);

            callableStatement.setInt(1, game.getGame_id());

            ResultSet rs = callableStatement.executeQuery();
            connection.commit();

            rs.close();
            callableStatement.close();
            connection.close();
            connection = null;

            ParmaLogger.logINFO("Attempt to delete game named " + game.getName() + " successful.");
        } catch (SQLException e) {

            ParmaLogger.logERROR(e.getMessage());
            if (connection != null) {
                try {
                    ParmaLogger.logWARN("Transaction is being rolled back");
                    connection.rollback();
                } catch (SQLException excep) {
                    ParmaLogger.logERROR(excep.getMessage());
                }
            }
            return;
        } finally {
            if (connection != null) {
                try {
                    connection.setAutoCommit(true);
                    connection.close();
                    connection = null;
                } catch (SQLException e) {
                    ParmaLogger.logERROR(e.getMessage());
                }
            }
        }
    }
}
