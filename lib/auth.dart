import 'package:appwrite/appwrite.dart';
import 'package:todo_app_appwrite/shared.dart';

Client client = Client()
    .setEndpoint('https://cloud.appwrite.io/v1')
    .setProject('648af4069926b9146087')
    .setSelfSigned(status: true); // For self signed certificates, only use for development

// Register User
  Account account = Account(client);

  Future<String> createUser(String name, String email, String password) async {
    try{
  final user = await account.create(
    userId: ID.unique(),
      email: email,
    password: password,
    name: name);
    print("User Has Been Created");
    return "success";
  } on AppwriteException catch(e){
      return e.message.toString();
    }
}

//Login
Future loginUser(String email, String password) async {
    try {
      final user = await account.createEmailSession(
          email: email, password: password);
      await UserSavedData.saveEmail(email);
      return true;
      print("User logged in");
    } catch(e){
      print(e);
      return false;
    }
}

//Logout the user
Future logoutUser() async {
    await account.deleteSession(sessionId: 'current');
    print("User Logged Out");
}

//Check User is authenticated or Not

Future checkUserAuth() async {
    try {
      //check if session exist or not
      await account.getSession(sessionId: 'current');
      //if exist return true
      return true;
    } catch(e) {
        print(e);
      return false;
    }
}