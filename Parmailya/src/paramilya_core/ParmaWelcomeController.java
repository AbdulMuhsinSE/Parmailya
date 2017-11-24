package paramilya_core;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;

import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Scene;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.scene.layout.Pane;
import javafx.scene.paint.Color;
import javafx.scene.text.Text;
import javafx.stage.Stage;
import parmailya_util.ConnectionManager;
import parmailya_util.ParmaLogger;
import parmailya_util.PropertyManager;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.math.BigInteger;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;


public class ParmaWelcomeController {
    @FXML
    public Text actiontarget_login_screen;
    public TextField uname_login_textfield;
    public PasswordField pass_login_textfield;


    @FXML
    public void login() {
        actiontarget_login_screen.setText("");
        actiontarget_login_screen.setFill(Color.FIREBRICK);
        if(uname_login_textfield.getCharacters() == null || pass_login_textfield.getCharacters() == null ||
                uname_login_textfield.getCharacters().toString().replaceAll(" ","").equals("") || pass_login_textfield.getCharacters().toString().replaceAll(" ","").equals("")){
            actiontarget_login_screen.setText("Even trolls should be able to read common: Fill both fields");
        } else {
            String uname = uname_login_textfield.getCharacters().toString();
            String pass = pass_login_textfield.getCharacters().toString();
            try {
                if (ConnectionManager.getInstance().validateUser(uname, generateHash(pass))) {
                    Stage stage = (Stage) actiontarget_login_screen.getScene().getWindow();
                    stage.setScene(new Scene(FXMLLoader.load(getClass().getResource("sample.fxml")),1080,720));
                } else {

                }
            } catch (Exception ex) {
                ParmaLogger.logERROR(ex.toString() + "-" + ex.getMessage());
            }
        }
    }

    private static String generateHash(String password) throws NoSuchAlgorithmException, InvalidKeySpecException {
        int iterations = 1000;
        String salt = PropertyManager.getProperty("localsalt");
        char[] chars = password.toCharArray();
        PBEKeySpec spec = new PBEKeySpec(chars,salt.getBytes(),1000,256);
        SecretKeyFactory skf =  SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
        byte[] hash = skf.generateSecret(spec).getEncoded();
        return iterations + ":" + toHex(hash);
    }

    private static String toHex(byte[] arr) throws NoSuchAlgorithmException {
        BigInteger bi = new BigInteger(1, arr);
        String hex = bi.toString(16);
        int paddingLength = (arr.length * 2) - hex.length();
        if(paddingLength > 0)
        {
            return String.format("%0"  +paddingLength + "d", 0) + hex;
        }else{
            return hex;
        }
    }
}
