import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/data/firestore.dart';

abstract class AuthenticationDatasource {
  Future<void> register(String email, String password, String passwordConfirm);
  Future<void> login(String email, String password);
}

class AuthenticationRemote extends AuthenticationDatasource {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<void> login(String email, String password) async {
    try {
      print("🔐 Attempting login for $email...");
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      print("✅ Login successful.");
    } catch (e, stack) {
      print("❌ Login error: $e");
      print("🔍 Stack Trace: $stack");
      rethrow;
    }
  }

  @override
  Future<void> register(String email, String password, String passwordConfirm) async {
    if (password.trim() != passwordConfirm.trim()) {
      throw Exception("Passwords do not match.");
    }

    try {
      print("📝 Attempting registration for $email...");
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final uid = userCredential.user?.uid;

      if (uid == null) {
        throw Exception("User UID is null after registration.");
      }

      print("✅ Firebase Auth user created: $uid");
      await FirestoreDatasource().createUser(
        email: email,
        uid: uid,
      );
    } catch (e, stack) {
      print("❌ Unexpected registration error: $e");
      print("🔍 Stack Trace: $stack");
      rethrow;
    }
  }
}
