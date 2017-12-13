package parmailya_datamodel;

import javafx.beans.property.SimpleIntegerProperty;
import javafx.beans.property.SimpleStringProperty;

public class Game {
    private SimpleIntegerProperty game_id;
    private SimpleStringProperty name;
    private SimpleStringProperty game_description;
    private SimpleStringProperty dungeon_master;


    public Game(int game_id, String name, String game_description, String dungeon_master) {
        this.game_id = new SimpleIntegerProperty(game_id);
        this.name = new SimpleStringProperty(name);
        this.game_description = new SimpleStringProperty(game_description);
        this.dungeon_master = new SimpleStringProperty(dungeon_master);
    }


    public int getGame_id() {
        return game_id.intValue();
    }

    public void setGame_id(int game_id) {
        this.game_id = new SimpleIntegerProperty(game_id);
    }

    public String getName() {
        return name.getValue();
    }

    public void setName(String name) {
        this.name = new SimpleStringProperty(name);
    }

    public String getGame_description() {
        return game_description.getValue();
    }

    public void setGame_description(String game_description) {
        this.game_description = new SimpleStringProperty(game_description);
    }

    public String getDungeon_master() {
        return dungeon_master.getValue();
    }

    public void setDungeon_master(String dungeon_master) {
        this.dungeon_master = new SimpleStringProperty(dungeon_master);
    }

    @Override
    public String toString() {
        return "Game Info:\n id:" + getGame_id() + "\n name: " + getName() + "\n description: " + getGame_description();
    }
}
