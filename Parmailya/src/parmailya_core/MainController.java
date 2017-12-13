package parmailya_core;

import javafx.event.EventHandler;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.control.ListView;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.StackPane;
import parmailya_util.MenuPropertyManager;
import parmailya_util.ParmaLogger;

import java.io.IOException;

public class MainController {
    @FXML
    ListView dmMenu;
    @FXML
    ListView playerMenu;
    @FXML
    StackPane game_pane;

    @FXML
    public void initialize () {
        dmMenu.setItems( MenuPropertyManager.getMenu("dm.txt"));
        playerMenu.setItems( MenuPropertyManager.getMenu("player.txt"));
        try {
            game_pane.getChildren().add((Node) FXMLLoader.load(getClass().getResource("../res/fxml/games.fxml")));
        } catch (IOException e) {
            ParmaLogger.logERROR(e.toString() + "-" + e.getMessage());
        }

        dmMenu.setOnMouseClicked(new EventHandler<>() {
            @Override
            public void handle(MouseEvent event) {
                try {
                    game_pane.getChildren().setAll((Node) FXMLLoader.load(getClass().getResource("../res/fxml/" + dmMenu.getSelectionModel().getSelectedItem().toString().toLowerCase() + ".fxml")));
                } catch (IOException e) {
                    ParmaLogger.logERROR(e.toString() + "-" + e.getMessage());
                }
            }
        });

        playerMenu.setOnMouseClicked(new EventHandler<>() {
            @Override
            public void handle(MouseEvent event) {
                try {
                    game_pane.getChildren().setAll((Node) FXMLLoader.load(getClass().getResource("../res/fxml/" + playerMenu.getSelectionModel().getSelectedItem().toString().toLowerCase() + ".fxml")));
                } catch (IOException e) {
                    ParmaLogger.logERROR(e.toString() + "-" + e.getMessage());
                }
            }
        });
    }



}
