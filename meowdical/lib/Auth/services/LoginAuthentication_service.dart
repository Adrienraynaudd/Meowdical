import 'package:firebase_auth/firebase_auth.dart';

class LoginAuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print('Error during login: ${e.message}, Code: ${e.code}');
      throw e;
    } catch (e) {
      print('Unexpected error during login: $e');
      throw e;
    }
  }
}
