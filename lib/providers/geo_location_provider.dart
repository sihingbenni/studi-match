import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:studi_match/exceptions/geo_locator_exception.dart';
import 'package:studi_match/models/coordinates.dart';
import 'package:studi_match/utilities/logger.dart';

class GeoLocationProvider extends ChangeNotifier {
  static Coordinates lastCoordinatesCalled = Coordinates(0, 0);
  static String lastZipCodeCalled = '';

  static String lastZipCodeValidated = '';
  static bool lastZipCodeValidationResult = false;

  bool loading = false;

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    logger.d('checking if location services are enabled');
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error(
          'Die Standortdienste sind deaktiviert. Bitte aktiviere die Standortdienste in den Einstellungen.');
    }

    logger.d('checking if location permissions are granted');
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      logger.w('location permissions are denied. requesting permissions');
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

    logger.d('checking if location permissions are permanently denied');
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Der Zugriff auf den Standort wurde verweigert. Bitte aktiviere die Standortdienste in den Einstellungen.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.lowest,
        timeLimit: const Duration(seconds: 5));
  }

  Future<Object> getZipCode() async {
    try {
      logger.d('GeoApi called');
      loading = true;
      // delay the loading screen to prevent flickering
      Future.delayed(
          const Duration(milliseconds: 100),
          () => {
                if (loading) {notifyListeners()}
              });
      Position position;

      try {
        position = await _determinePosition();
      } on TimeoutException catch (_) {
        loading = false;
        notifyListeners();
        return GeoLocatorException(
            'Es ist ein Fehler aufgetreten, versuche es später erneut!');
      }

      loading = false;
      notifyListeners();
      logger.d('GeoApi finished');
      if (lastCoordinatesCalled.lat == position.latitude &&
          lastCoordinatesCalled.lon == position.longitude) {
        logger.i(
            'GeoApi called again with same coordinates. Returning last: $lastZipCodeCalled');
        return lastZipCodeCalled;
      }

      // get the placemarks from the coordinates
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.first.postalCode != null) {
        logger.i('GeoApi found PLZ: ${placemarks.first.postalCode}');

        // save the call to reduce spam
        lastCoordinatesCalled =
            Coordinates(position.latitude, position.longitude);
        lastZipCodeCalled = placemarks.first.postalCode!;

        return placemarks.first.postalCode!;
      } else {
        return GeoLocatorException(
            'Es konnte keine Postleitzahl ermittelt werden. Versuche es manuell.');
      }
    } catch (e) {
      loading = false;
      notifyListeners();
      return GeoLocatorException(e.toString());
    }
  }

  Future<bool> validatePostalCode(String postalCode) async {
    try {
      if (postalCode == lastZipCodeValidated) {
        logger.i(
            'GeoApi called again with same postal code. Returning last result: $lastZipCodeValidationResult');
        return lastZipCodeValidationResult;
      }

      List<Location> locations =
          await locationFromAddress('$postalCode, Germany');

      lastZipCodeValidated = postalCode;

      // this is the center of Germany. If the location is the same, the postal code is invalid
      if (locations.first.latitude == 51.165690999999995 &&
          locations.first.longitude == 10.451526) {
        logger.w('GeoApi found invalid PLZ: $postalCode');
        lastZipCodeValidationResult = false;
        return false;
      }

      lastZipCodeValidationResult = true;
      return true;
    } catch (e) {
      return false;
    }
  }
}
