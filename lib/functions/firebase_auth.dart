import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthFirebase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Future<void> createUserWithPassword(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Étape 1 : Authentification via Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Si l'utilisateur annule la connexion
      if (googleUser == null) return null;

      // Étape 2 : Récupérer les détails de l'authentification
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Étape 3 : Créer une nouvelle crédentiale pour Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, // Jeton d'accès
        idToken: googleAuth.idToken, // Jeton d'identification
      );

      // Étape 4 : Se connecter à Firebase avec ces crédentials
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      // Succès
      return userCredential;
    } catch (e) {
      // Affiche l'erreur dans la console
      //print('Erreur lors de la connexion Google : $e');
      return null;
    }
  }
}
