/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
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
}*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthFirebase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Map<String, dynamic>? _facebookUserData;

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Connexion avec e-mail et mot de passe
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ); //throw Exception("Échec de connexion : ${e.toString()}");
  }

  /// Déconnexion de l'utilisateur
  Future<void> logout() async {
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
    await _firebaseAuth.signOut();
    _facebookUserData = null;
  }

  /// Création d'un compte avec e-mail et mot de passe
  Future<void> createUserWithPassword(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      //throw Exception("Échec de création du compte : ${e.toString()}");
    }
  }

  /// Connexion via Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      //throw Exception("Échec de connexion Google : ${e.toString()}");
      return null;
    }
  }

  /// Connexion via Facebook
  Future<UserCredential?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final OAuthCredential facebookCredential =
            FacebookAuthProvider.credential(result.accessToken!.tokenString);

        final userCredential = await _firebaseAuth.signInWithCredential(
          facebookCredential,
        );

        _facebookUserData = await FacebookAuth.instance.getUserData(
          fields: "name,email,picture.width(200)",
        );

        return userCredential;
      } else {
        return null;
        //throw Exception("Échec de connexion Facebook : ${result.message}");
      }
    } catch (e) {
      return null;
      //throw Exception("Erreur Facebook : ${e.toString()}");
    }
  }

  /// Retourne les infos de l'utilisateur connecté : nom, email, photo, téléphone
  Map<String, String?> getUserProfile() {
    final user = currentUser;

    return {
      'name': user?.displayName ?? _facebookUserData?['name'],
      'email': user?.email ?? _facebookUserData?['email'],
      'photo': user?.photoURL ?? _facebookUserData?['picture']?['data']?['url'],
      'phone': user?.phoneNumber,
    };
  }
}
