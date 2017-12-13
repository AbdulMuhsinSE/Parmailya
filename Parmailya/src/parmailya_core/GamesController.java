package parmailya_core;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.EventHandler;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.geometry.Pos;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.StackPane;
import javafx.scene.text.Font;
import javafx.scene.text.FontWeight;
import javafx.stage.Modality;
import javafx.stage.Stage;
import org.controlsfx.control.Notifications;
import parmailya_datamodel.DataModelEnum;
import parmailya_datamodel.Game;
import parmailya_datamodel.UserInfoSingleton;
import parmailya_util.ConnectionManager;

import java.io.IOException;
import java.net.URL;
import java.util.ResourceBundle;

public class GamesController implements Initializable {

    @FXML
    AnchorPane dm_games_pane;
    @FXML
    TableView<Game> dm_games_table;
    @FXML
    Button enter_game_btn;


    private final UserInfoSingleton user_info = UserInfoSingleton.getInstance();


    @FXML
    public void initialize(URL location, ResourceBundle resourceBundle) {
        user_info.setGames(ConnectionManager.getInstance().getUserGames(user_info.getDatum(DataModelEnum.EMAIL_ADDRESS)));

        dm_games_pane.parentProperty().addListener((observable, oldValue, newValue) -> {
            StackPane.setAlignment(dm_games_pane, Pos.CENTER);
        });

        ObservableList<TableColumn<Game,?>> columns = dm_games_table.getColumns();
        columns.get(0).setCellValueFactory(new PropertyValueFactory<>("game_id"));
        columns.get(1).setCellValueFactory(new PropertyValueFactory<>("name"));
        columns.get(2).setCellValueFactory(new PropertyValueFactory<>("game_description"));
        columns.get(3).setCellValueFactory(new PropertyValueFactory<>("dungeon_master"));
        dm_games_table.setItems(FXCollections.observableArrayList(user_info.getGames()));


    }

    public void enterGame(){
        if(dm_games_table.getSelectionModel().getSelectedItem()!= null) {
            Notifications.create().title("Elven Wisdom").text(dm_games_table.getSelectionModel().getSelectedItem().toString()).showInformation();
        } else {
            Notifications.create().title("Elven Wisdom").text("No Choice Made").showWarning();
        }
    }

    public void createGame() {
        final Stage dialog = new Stage();
        dialog.setTitle("Confirmation");
        FXMLLoader dialogFXML = new FXMLLoader (getClass().getResource("../res/fxml/creategame_dialog.fxml"));
        Parent root = null;
        try {
            root = dialogFXML.load();
        } catch (IOException e) {
            e.printStackTrace();
        }
        CreateGameDialogController controller = dialogFXML.getController();
        dialog.setScene(new Scene(root));


        controller.submit_btn.addEventHandler(MouseEvent.MOUSE_CLICKED,
                new EventHandler<MouseEvent>() {
                    @Override
                    public void handle(MouseEvent e) {
                        String name = controller.new_game_textfield.getCharacters().toString();
                        String description = controller.new_game_description.getCharacters().toString();
                        if(!(name.isEmpty() || description.isEmpty())) {
                            user_info.addGame(name, description, user_info.getDatum(DataModelEnum.EMAIL_ADDRESS));
                            ConnectionManager.getInstance().updateGames(user_info.getDatum(DataModelEnum.EMAIL_ADDRESS), user_info.getGames());
                            dm_games_table.setItems(FXCollections.observableArrayList(user_info.getGames()));
                            dialog.close();
                        } else {
                            Notifications.create().title("Invest in INT Stat").text("Seriously even trolls can read common.").showWarning();
                        }
                    }
                });
        controller.cancel_btn.addEventHandler(MouseEvent.MOUSE_CLICKED,
                new EventHandler<MouseEvent>() {
                    @Override
                    public void handle(MouseEvent e) {
                        Notifications.create().title("Elven Wisdom").text("No Game Created").showWarning();
                        dialog.close();
                    }
                });


        dialog.show();
    }

    public void deleteGame() {
        if(dm_games_table.getSelectionModel().getSelectedItem()!= null) {
            Game game = dm_games_table.getSelectionModel().getSelectedItem();
            user_info.getGames().remove(game);
            dm_games_table.setItems(FXCollections.observableArrayList(user_info.getGames()));
            ConnectionManager.getInstance().deleteGame(game);
            Notifications.create().title("Elven Wisdom").text("Delete Complete").showInformation();
        } else {
            Notifications.create().title("Elven Wisdom").text("No Choice Made").showWarning();
        }
    }

}

