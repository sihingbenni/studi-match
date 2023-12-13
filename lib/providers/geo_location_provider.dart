
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:studi_match/exceptions/geo_locator_exception.dart';
import 'package:studi_match/models/coordinates.dart';
import 'package:studi_match/utilities/logger.dart';

class GeoLocationProvider {

  static Coordinates lastCoordinatesCalled = Coordinates(0, 0);
  static String lastZipCodeCalled = '';

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

      if (lastCoordinatesCalled.lat == position.latitude && lastCoordinatesCalled.lon == position.longitude) {
        logger.i('GeoApi called again with same coordinates. Returning last: $lastZipCodeCalled');
        return lastZipCodeCalled;
      }


      // get the placemarks from the coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.first.postalCode != null) {
        logger.i('GeoApi found PLZ: ${placemarks.first.postalCode}');

        // save the call to reduce spam
        lastCoordinatesCalled = Coordinates(position.latitude, position.longitude);
        lastZipCodeCalled = placemarks.first.postalCode!;

        return placemarks.first.postalCode!;
      } else {
        return GeoLocatorException('Es konnte keine Postleitzahl ermittelt werden. Versuche es manuell.');
      }
    } catch (e) {
      return GeoLocatorException(e.toString());
    }
  }

  Future<bool> validatePostalCode(String postalCode) async {
    try {
      List<Location> locations = await locationFromAddress('$postalCode, Germany');
      logger.f('GeoApi found locations: $locations');

      // this is the center of Germany. If the location is the same, the postal code is invalid
      if (locations.first.latitude == 51.165690999999995 && locations.first.longitude == 10.451526) {
        return false;
      }

      if (locations.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}