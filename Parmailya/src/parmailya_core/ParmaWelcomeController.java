package parmailya_core;

import javafx.fxml.FXML;

import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.scene.paint.Color;
import javafx.scene.text.Text;
import javafx.stage.Stage;
import org.controlsfx.control.Notifications;
import parmailya_datamodel.DataModelEnum;
import parmailya_datamodel.UserInfoSingleton;
import parmailya_util.ConnectionManager;
import parmailya_util.ParmaLogger;
import parmailya_util.MenuPropertyManager;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.io.IOException;
import java.math.BigInteger;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;


public class ParmaWelcomeController {
    @FXML
    public Text actiontarget_login_screen;
    public TextField uname_login_textfield;
    public PasswordField pass_login_textfield;
    public TextField email_login_textfield;
    public Button create_account;
    public TextField dci_login_textfield;

    private UserInfoSingleton user_info = UserInfoSingleton.getInstance();


    @FXML
    public void login() {
        actiontarget_login_screen.setText("");
        actiontarget_login_screen.setFill(Color.FIREBRICK);
        if(email_login_textfield.getCharacters() == null || pass_login_textfield.getCharacters() == null ||
                email_login_textfield.getCharacters().toString().replaceAll(" ","").equals("") || pass_login_textfield.getCharacters().toString().replaceAll(" ","").equals("")){
            //actiontarget_login_screen.setText("Even trolls should be able to read common: Fill both fields");
            Notifications.create().title("Invest in INT Score").text("Even trolls should be able to read common: Fill both fields").showWarning();
        } else {
            String email = email_login_textfield.getCharacters().toString();
            String pass = pass_login_textfield.getCharacters().toString();
            try {
                 user_info.setUserProfileInfo( ConnectionManager.getInstance().validateUser(email, generateHash(pass)));
                if (user_info.getDatum(DataModelEnum.EMAIL_ADDRESS)!=null) {
                    setUpGamesWindow();
                } else {
                    //actiontarget_login_screen.setText("Trolls with bad credentials are not welcome here.");
                    Notifications.create().title("Bad Credentials").text("Trolls with bad credentials are not welcome here.").showWarning();
                }
            } catch (Exception ex) {
                ParmaLogger.logERROR(ex.toString() + "-" + ex.getMessage());
            }
        }
    }

    @FXML
    public void createAccount() {
        actiontarget_login_screen.setText("");
        actiontarget_login_screen.setFill(Color.FIREBRICK);
        if(uname_login_textfield.getCharacters() == null || pass_login_textfield.getCharacters() == null || email_login_textfield.getCharacters() == null ||
                uname_login_textfield.getCharacters().toString().replaceAll(" ","").equals("") || pass_login_textfield.getCharacters().toString().replaceAll(" ","").equals("")
                || email_login_textfield.getCharacters().toString().replaceAll(" ","").equals("") ){
            //actiontarget_login_screen.setText("Even trolls should be able to read common: Fill the required fields");
            Notifications.create().title("Invest in INT Score").text("Even trolls should be able to read common: Fill the required fields").showWarning();
        } else {
            String uname = uname_login_textfield.getCharacters().toString();
            String pass = pass_login_textfield.getCharacters().toString();
            String email = email_login_textfield.getCharacters().toString();
            String dci = dci_login_textfield.getCharacters().toString();
            try {
                boolean user_created = ConnectionManager.getInstance().createUser(uname, generateHash(pass),email,dci);
                if (user_created) {
                    user_info.update(DataModelEnum.USER_NAME,uname);
                    user_info.update(DataModelEnum.EMAIL_ADDRESS,email);
                    user_info.update(DataModelEnum.DCI_NUMBER,dci);
                    setUpGamesWindow();
                } else {
                    //actiontarget_login_screen.setText("User creation failed");
                    Notifications.create().title("Critical Fail").text("Rolled a nat 1 on user creation, try a different email").showError();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
                ParmaLogger.logERROR("Create account error: " + ex.toString() + "-" + ex.getMessage());
            }
        }
    }

    private static String generateHash(String password) throws NoSuchAlgorithmException, InvalidKeySpecException {
        int iterations = 1000;
        String salt = MenuPropertyManager.getProperty("localsalt");
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

    private void setUpGamesWindow() throws IOException {
        Stage stage = (Stage) actiontarget_login_screen.getScene().getWindow();
        stage.setScene(new Scene(FXMLLoader.load(getClass().getResource("../res/fxml/maingamewindow.fxml")),1080,720));
    }
}
