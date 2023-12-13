
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:studi_match/exceptions/geo_locator_exception.dart';
import 'package:studi_match/utilities/logger.dart';

class GeoLocationProvider {
  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Die Standortdienste sind deaktiviert. Bitte aktiviere die Standortdienste in den Einstellungen.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Der Zugriff auf den Standort wurde verweigert.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Der Zugriff auf den Standort wurde verweigert. Bitte aktiviere die Standortdienste in den Einstellungen.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<Object> getZipCode() async {
    try {
      final position = await _determinePosition();

      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.first.postalCode != null) {
        logger.i('GeoApi found PLZ: ${placemarks.first.postalCode}');
        return placemarks.first.postalCode!;
      } else {
        return GeoLocatorException('Es konnte keine Postleitzahl ermittelt werden. Versuche es manuell.');
      }
    } catch (e) {
      return GeoLocatorException(e.toString());
    }
  }
}