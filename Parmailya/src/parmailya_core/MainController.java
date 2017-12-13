package parmailya_core;

import javafx.event.EventHandler;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.ListView;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.StackPane;
import javafx.stage.Stage;
import parmailya_datamodel.UserInfoSingleton;
import parmailya_util.MenuPropertyManager;
import parmailya_util.ParmaLogger;

import java.io.IOException;

public class MainController {
    @FXML
    ListView dmMenu;
    @FXML
    ListView playerMenu;
    @FXML
    ListView optionsMenu;

    @FXML
    StackPane game_pane;

    @FXML
    public void initialize () {
        dmMenu.setItems( MenuPropertyManager.getMenu("dm.txt"));
        playerMenu.setItems( MenuPropertyManager.getMenu("player.txt"));
        optionsMenu.setItems(MenuPropertyManager.getMenu("options.txt"));
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

        optionsMenu.setOnMouseClicked(new EventHandler<>() {
            @Override
            public void handle(MouseEvent event) {
                try {
                    String choice = optionsMenu.getSelectionModel().getSelectedItem().toString().toLowerCase();
                    switch (choice) {
                        case "log out":
                            UserInfoSingleton.getInstance().destroySession();
                            Stage stage = (Stage) game_pane.getScene().getWindow();
                            stage.setScene(new Scene(FXMLLoader.load(getClass().getResource("../res/fxml/parmawelcome.fxml")),500,275));
                    }
                } catch (IOException e) {
                    ParmaLogger.logERROR(e.toString() + "-" + e.getMessage());
                }
            }
        });
    }



}
