import 'package:app_settings/app_settings.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:math';

Future<Position> getCurrentPosition() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    //await AppSettings.openAppSettings(type: AppSettingsType.location);
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
List<String> trierVillesParProximite({
  required Map<String, String> villes,
  required String villeReferenceCoord,
}) {
  // Parse coordonnées de la ville de référence
  final coordsRef = villeReferenceCoord.split('/');
  final refLat = double.tryParse(coordsRef[0]) ?? 0;
  final refLon = double.tryParse(coordsRef[1]) ?? 0;

  // Convertir chaque ville en une paire (nom, distance)
  final distances = villes.entries.map((entry) {
    final coords = entry.value.split('/');
    final lat = double.tryParse(coords[0]) ?? 0;
    final lon = double.tryParse(coords[1]) ?? 0;

    final distance = calculerDistance(refLat, refLon, lat, lon);
    return MapEntry(entry.key, distance);
  }).toList();

  // Trier selon la distance
  distances.sort((a, b) => a.value.compareTo(b.value));

  // Retourner la liste des noms triés
  return distances.map((e) => e.key).toList();
}

/// Calcule la distance entre deux points (en kilomètres) avec la formule de Haversine
double calculerDistance(double lat1, double lon1, double lat2, double lon2) {
  const rayonTerre = 6371; // Rayon moyen de la Terre en km

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
