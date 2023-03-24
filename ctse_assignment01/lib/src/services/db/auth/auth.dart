import 'package:firebase_auth/firebase_auth.dart';

class Auth{

  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static Stream<User?> get onAuthStateChanged {
    print('auth called');
    return _firebaseAuth.authStateChanges();

  }
}