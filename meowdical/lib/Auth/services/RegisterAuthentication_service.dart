import 'package:firebase_auth/firebase_auth.dart';

class RegisterAuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> register(
      {required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print('Error during registration: ${e.message}, Code: ${e.code}');
      throw e;
    } catch (e) {
      print('Unexpected error during registration: $e');
      throw e;
    }
  }
}
