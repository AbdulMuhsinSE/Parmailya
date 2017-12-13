package parmailya_datamodel;

import parmailya_util.RandomString;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Random;

public class UserInfoSingleton {
    private static UserInfoSingleton instance;
    private HashMap<DataModelEnum,String> data;
    private ArrayList<Game> gamesList;


    private  UserInfoSingleton(){
        data = new HashMap<>();
        gamesList = new ArrayList<>();
    }

    public static UserInfoSingleton getInstance() {
        if(instance == null) {
            instance = new UserInfoSingleton();
        }
        return instance;
    }

    public void setUserProfileInfo(HashMap<DataModelEnum, String> data) {
        this.data = data;
    }

    public void update(DataModelEnum type,String datum) {
        data.put(type, datum);
    }

    public String getDatum(DataModelEnum type) {
        return data.get(type);
    }

    public ArrayList<Game> getGames() {
        return gamesList;
    }

    public void setGames(ArrayList<Game> games) {
        this.gamesList = games;
    }

    public void addGame(String name, String game_description, String dungeon_master) {
        //Game game = new Game(new RandomString(11).nextString(),name,game_description,dungeon_master);
        Game game = new Game(new Random().nextInt(99999999),name,game_description,dungeon_master);
        addGame(game);
    }

    public void addGame(Game game) {
        gamesList.add(game);
    }

    public boolean hasGames() {
        return !gamesList.isEmpty();
    }
}
