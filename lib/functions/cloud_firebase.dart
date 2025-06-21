import 'dart:io'; //
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:koontaa/functions/firebase_auth.dart';
import 'package:koontaa/functions/fonctions.dart';

class CloudFirestore {
  final FirebaseFirestore _bdd = FirebaseFirestore.instance;

  Future<bool> checkConnexionFirestore() async {
    try {
      // On fait une requête très légère, par exemple sur une collection vide ou une ligne de test
      await FirebaseFirestore.instance
          .collection("connectivity_test")
          .limit(1)
          .get(const GetOptions(source: Source.server));

      // Si on arrive ici, la connexion au serveur Firestore est fonctionnelle
      return true;
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        return false; // Serveur inaccessible
      }
      return false; // Autre erreur Firebase
    } on SocketException {
      return false; // Pas de réseau
    } catch (_) {
      return false; // Toute autre erreur
    }
  }

  Future<bool> ajoutBdd(
    String collection,
    Map<String, dynamic> donnees, {
    String uid = "",
  }) async {
    if (uid == "") {
      uid = genererCodeAleatoire();
    }
    try {
      await _bdd.collection(collection).doc(uid).set(donnees);
      return true;
    } catch (e) {
      print('Erreur lors de l’ajout dans Firestore : $e');
      return false;
    }
  }

  Stream<QuerySnapshot> lectureBdd(
    String collection, {

    Filter? filtreCompose, // utiliser Filter.and(...) ou Filter.or(...)
    List<dynamic>? orderBy,
    int limite = 1000000000,
  }) {
    try {
      Query query = _bdd.collection(collection);

      // Si on a un filtre composé
      if (filtreCompose != null) {
        query = query.where(filtreCompose);
      }

      if (orderBy != null && orderBy.length == 2) {
        query = query.orderBy(orderBy[0], descending: orderBy[1]);
      }

      if (limite != 1000000000) {
        query = query.limit(limite);
      }

      return query.snapshots();
    } catch (e) {
      print('Erreur Firestore : $e');
      return const Stream.empty();
    }
  }

  Stream<DocumentSnapshot> lectureBddDocU(String collection, String uid) {
    try {
      return _bdd.collection(collection).doc(uid).snapshots();
    } catch (e) {
      //print("Erreur Firestore : $e");
      return const Stream.empty();
    }
  }

  Future<dynamic> lectureUBdd(
    String collection, {
    Filter? filtreCompose, // Utiliser Filter.and(...) ou Filter.or(...)
    List<dynamic>? orderBy,
    int limite = 1000000000,
    bool offlineOnly = false,
    String idDoc = "", // Ajout optionnel pour mode hors ligne
  }) async {
    Query query = _bdd.collection(collection);

    if (idDoc != "") {
      DocumentSnapshot docSnapshot = await _bdd
          .collection(collection)
          .doc(idDoc)
          .get();
      return docSnapshot.exists ? docSnapshot : null;
    }

    if (filtreCompose != null) {
      query = query.where(filtreCompose);
    }

    if (orderBy != null && orderBy.length == 2) {
      query = query.orderBy(orderBy[0], descending: orderBy[1]);
    }

    if (limite != 1000000000) {
      query = query.limit(limite);
    }

    return await query.get();
  }

  Future<bool> modif(
    String collection,
    String idDoc,
    Map<String, dynamic> donnees,
  ) async {
    try {
      await _bdd.collection(collection).doc(idDoc).update(donnees);
      return true;
    } catch (e) {
      print('Erreur dans $collection/$idDoc : $e');
      return false;
    }
  }

  Future<bool> sup(String collection, String idDoc) async {
    try {
      await _bdd.collection(collection).doc(idDoc).delete();
      return true;
    } catch (e) {
      print('Erreur lors de la suppression : $e');
      return false;
    }
  }
}

Filter cd(String colonne, dynamic valeur, {String comparateur = "=="}) {
  switch (comparateur) {
    case "==":
      return Filter(colonne, isEqualTo: valeur);
    case "!=":
      return Filter(colonne, isNotEqualTo: valeur);
    case "<":
      return Filter(colonne, isLessThan: valeur);
    case "<=":
      return Filter(colonne, isLessThanOrEqualTo: valeur);
    case ">":
      return Filter(colonne, isGreaterThan: valeur);
    case ">=":
      return Filter(colonne, isGreaterThanOrEqualTo: valeur);
    case "in":
      return Filter(colonne, whereIn: valeur); // valeur doit être une liste
    case "not-in":
      return Filter(colonne, whereNotIn: valeur); // valeur doit être une liste
    case "null":
      return Filter(colonne, isNull: valeur); // valeur = true ou false
    default:
      throw ArgumentError("Comparateur inconnu : $comparateur");
  }
}
