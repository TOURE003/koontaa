import 'dart:ffi';

import 'package:app_settings/app_settings.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:math';

Future<Position> getCurrentPosition() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await AppSettings.openAppSettings(type: AppSettingsType.location);
    //print("object");
    return Future.error('desactive');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Permission_refusee');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Permission_refusee_permanent');
  }

  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}

void afficherPosition() async {
  try {
    Position position = await getCurrentPosition();
    print('Latitude : ${position.latitude}, Longitude : ${position.longitude}');
  } catch (e) {
    print('Erreur : $e');
  }
}

Future<String> getVilleUtilisateur(Position position) async {
  try {
    // Géocodage inversé depuis latitude et longitude
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      final ville = placemarks.first.locality; // Exemple : "Abidjan"
      return ville ?? "ville-inconnue";
    } else {
      return "ville-inconnue";
    }
  } catch (e) {
    print("Erreur lors du géocodage inversé : $e");
    return "ville-inconnue";
  }
}

/// Trie les villes en fonction de la distance à une ville de référence

List<dynamic> trierVillesParProximite({
  required List<dynamic> villes,
  required Map<String, dynamic> villeReference,
}) {
  final refLat = _toDouble(villeReference['lat']);
  final refLon = _toDouble(villeReference['lng']);

  // Ajouter une clé "distance" à chaque ville
  final villesAvecDistance = villes.map((ville) {
    final lat = _parseCoord(ville['lat']);
    final lon = _parseCoord(ville['lng']);
    final distance = calculerDistance(refLat, refLon, lat, lon);

    return {...ville, 'lat': lat, 'lng': lon, 'distance': distance};
  }).toList();

  // Tri croissant par distance
  villesAvecDistance.sort(
    (a, b) => (a['distance'] as double).compareTo(b['distance'] as double),
  );

  return villesAvecDistance;
}

/// Convertit une coordonnée de string avec virgule ou autre format en double
double _parseCoord(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    return double.tryParse(value.replaceAll(',', '.')) ?? 0;
  }
  return 0;
}

/// Assure que la coordonnée est un double
double _toDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}

/// Calcule la distance en km avec la formule de Haversine
double calculerDistance(double lat1, double lon1, double lat2, double lon2) {
  const rayonTerre = 6371; // km

  final dLat = _toRadians(lat2 - lat1);
  final dLon = _toRadians(lon2 - lon1);

  final a =
      sin(dLat / 2) * sin(dLat / 2) +
      cos(_toRadians(lat1)) *
          cos(_toRadians(lat2)) *
          sin(dLon / 2) *
          sin(dLon / 2);

  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return rayonTerre * c;
}

double _toRadians(double degres) => degres * pi / 180;
