import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestore {
  final FirebaseFirestore _bdd = FirebaseFirestore.instance;

  Future<bool> ajoutBdd(
    String collection,
    String uid,
    Map<String, dynamic> donnees,
  ) async {
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
    Filter? condition,
    List<dynamic>? orderBy,
    int limite = 100000,
  }) {
    try {
      Query query = _bdd.collection(collection);

      if (condition != null) {
        query = query.where(condition);
      }

      if (orderBy != null && orderBy.length == 2) {
        query = query.orderBy(orderBy[0], descending: orderBy[1]);
      }

      query = query.limit(limite);

      return query.snapshots();
    } catch (e) {
      print('Erreur lors de la lecture Firestore : $e');
      return const Stream.empty();
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
