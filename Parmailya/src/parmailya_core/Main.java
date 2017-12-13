package parmailya_core;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.text.Font;
import javafx.stage.Stage;

public class Main extends Application {

    @Override
    public void start(Stage primaryStage) throws Exception{
        Parent root = FXMLLoader.load(getClass().getResource("../res/fxml/parmawelcome.fxml"));
        primaryStage.setTitle("Login");
        Scene scene = new Scene(root, 600, 275);
        System.out.println(Font.loadFont(getClass().getResourceAsStream("../res/fonts/Cinzel/Cinzel-Regular.ttf"),32).getName());
        scene.getStylesheets().add(getClass().getResource("../res/stylesheet.css").toExternalForm());
        primaryStage.setMinHeight(275);
        primaryStage.setMinWidth(600);
        primaryStage.setScene(scene);
        primaryStage.show();
    }


    public static void main(String[] args) {
        launch(args);
    }
}
