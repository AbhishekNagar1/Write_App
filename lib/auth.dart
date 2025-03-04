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


Future<bool> loginUser(String email, String password) async {
  try {
    final prefs = await SharedPreferences.getInstance();

    // 🔴 Destroy all active sessions before logging in
    try {
      await account.deleteSessions();
      print("All previous sessions deleted successfully.");
    } catch (e) {
      print("No active session found or session deletion failed: $e");
    }

    // 🔵 Developer Hardcoded Login (Test Mode)
    if (email == devEmail && password == devPassword) {
      await UserSavedData.saveEmail(email);
      await prefs.setString('session', 'dev_session');
      await prefs.setInt('lastLogin', DateTime.now().millisecondsSinceEpoch);
      print("Logged in as Developer");
      return true;
    }

    // 🔵 CREATE NEW LOGIN SESSION
    final user = await account.createEmailSession(
      email: email,
      password: password,
    );

    await prefs.setString('session', user.$id);
    await prefs.setInt('lastLogin', DateTime.now().millisecondsSinceEpoch);
    await UserSavedData.saveEmail(email);

    print("User logged in successfully.");
    return true;
  } on AppwriteException catch (e) {
    print("Login failed: ${e.message}");
    return false;
  }
}




// Logout the User
Future<void> logoutUser() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    String? session = prefs.getString('session');

    if (session != null && session != 'dev_session') {
      await account.deleteSessions();
    }

    await prefs.clear(); // Clear all stored session data
    print("User Logged Out Successfully");
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

    // Auto logout after 1 week of inactivity
    if (currentTime - lastLogin > oneWeekInMillis) {
      await logoutUser();
      return false;
    }

    if (session == 'dev_session') {
      print("Developer session active");
      return true;
    }

    // Verify session with Appwrite
    await account.get();
    return true;
  } on AppwriteException catch (e) {
    print("Authentication check failed: ${e.message}");
    return false;
  }
}
