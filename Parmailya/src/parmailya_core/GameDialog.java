package parmailya_core;

import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.control.Dialog;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;

public class GameDialog extends Dialog<ArrayList> {
    public GameDialog() {
        FXMLLoader dialogFXML = new FXMLLoader (getClass().getResource("../res/fxml/creategame_dialog.fxml"));
        try {
            Parent root = dialogFXML.load();
            CreateGameDialogController controller = dialogFXML.getController();
            getDialogPane().setContent(root);

            setResultConverter(buttonType -> {
                String name = controller.new_game_textfield.getCharacters().toString();
                String desc = controller.new_game_description.getText();
                return new ArrayList(Arrays.asList(new String[]{name,desc}));
            });
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
