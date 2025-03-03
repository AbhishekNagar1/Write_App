import 'package:appwrite/appwrite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_appwrite/shared.dart';

Client client = Client()
    .setEndpoint('https://cloud.appwrite.io/v1')
    .setProject('648af4069926b9146087')
    .setSelfSigned(status: true);

Account account = Account(client);

// Hardcoded developer credentials (for testing only)
const String devEmail = "test@developer.com";
const String devPassword = "Test@123";

// Register User
Future<String> createUser(String name, String email, String password) async {
  try {
    final user = await account.create(
      userId: ID.unique(),
      email: email,
      password: password,
      name: name,
    );
    print("User Has Been Created");
    return "success";
  } on AppwriteException catch (e) {
    return e.message.toString();
  }
}

// Login
Future<bool> loginUser(String email, String password) async {
  try {
    final prefs = await SharedPreferences.getInstance();

    // Check if the credentials match the hardcoded developer login
    if (email == devEmail && password == devPassword) {
      await UserSavedData.saveEmail(email);
      await prefs.setString('session', 'dev_session');
      await prefs.setInt('lastLogin', DateTime.now().millisecondsSinceEpoch);
      print("Logged in as Developer");
      return true;
    }

    // Proceed with normal authentication (Appwrite)
    final user = await account.createEmailSession(
      email: email,
      password: password,
    );

    await prefs.setString('session', user.$id); // Store session ID
    await prefs.setInt('lastLogin', DateTime.now().millisecondsSinceEpoch);

    await UserSavedData.saveEmail(email);
    print("User logged in");
    return true;
  } on AppwriteException catch (e) {
    print("Login failed: ${e.message}");
    return false;
  }
}

// Logout the user
Future<void> logoutUser() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    String? session = prefs.getString('session');

    if (session != 'dev_session') {
      await account.deleteSessions();
    }

    await prefs.remove('session'); // Clear session data
    await prefs.remove('lastLogin');
    print("User Logged Out");
  } on AppwriteException catch (e) {
    print("Logout failed: ${e.message}");
  }
}

// Check if User is Authenticated (Persistent Login)
Future<bool> checkUserAuth() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    String? session = prefs.getString('session');
    int? lastLogin = prefs.getInt('lastLogin');

    if (session == null || lastLogin == null) return false;

    int currentTime = DateTime.now().millisecondsSinceEpoch;
    int oneWeekInMillis = 7 * 24 * 60 * 60 * 1000; // 7 days

    if (currentTime - lastLogin > oneWeekInMillis) {
      await logoutUser(); // Auto logout after 1 week
      return false;
    }

    if (session == 'dev_session') {
      print("Developer session active");
      return true;
    }

    await account.get(); // Verify session with Appwrite
    return true;
  } on AppwriteException catch (e) {
    print("Authentication check failed: ${e.message}");
    return false;
  }
}
