import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:koontaa/functions/cloud_firebase.dart';

String? _verificationId;
bool autorisationChangePage = true;

class AuthFirebase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Map<String, dynamic>? _facebookUserData;

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Connexion avec e-mail et mot de passe
  Future<void> loginWithEmailAndPassword(
    String email,
    String password, {
    bool decon = true,
  }) async {
    autorisationChangePage = decon;
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ); //throw Exception("Échec de connexion : ${e.toString()}");
  }

  /// Déconnexion de l'utilisateur
  Future<void> logout({bool decon = true}) async {
    autorisationChangePage = decon;
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
    await _firebaseAuth.signOut();
    _facebookUserData = null;
  }

  /// Création d'un compte avec e-mail et mot de passe
  Future<void> createUserWithPassword(
    String email,
    String password,
    Function fonctionSucces,
    Function fonctionErr, {
    bool decon = true,
  }) async {
    try {
      autorisationChangePage = decon;
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user!.sendEmailVerification();
      //await logout();

      fonctionSucces();
    } catch (e) {
      try {
        fonctionErr(e);
      } catch (e) {}
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

  Future<void> envoyerCodeSMS(
    String numeroTelephone,
    Function fonctionSucces,
    Function fonctionEchec,
  ) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: numeroTelephone, // exemple : +2250102030405
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {
        // Connexion automatique possible sur Android (mais ici on ne l’utilise pas)
      },
      verificationFailed: (FirebaseAuthException e) {
        fonctionEchec(e);
        //print("Erreur lors de l’envoi du SMS : ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        //print("Code envoyé !");
        _verificationId = verificationId; // On le garde pour la suite
        fonctionSucces();
        //print("llkjlkjk 5465465465");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId; // Au cas où l'utilisateur est lent
      },
    );
  }

  /// Stockage temporaire du code pour l'étape de vérification OTP
  static String? verificationIdGlobal;

  Future<void> verifierCodeOTP(
    String codeOTP,
    Function fonctionSucces,
    Function fonctionErr,
  ) async {
    if (_verificationId == null) {
      //print("Erreur : aucun ID de vérification trouvé.");
      fonctionErr();
      return;
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: codeOTP,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      fonctionSucces();
      //this.logout();
      //print("Connexion réussie !");
    } on FirebaseAuthException catch (e) {
      fonctionErr(e.code);
    }
  }
}
