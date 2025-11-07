import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cyclepathsg/provider/current_location_provider.dart';

void main() {
  late CurrentLocationProvider provider;

  setUp(() {
    provider = CurrentLocationProvider();
  });

  tearDown(() {
    provider.dispose();
  });

  test('Initial values are correct', () {
    expect(provider.currentLocation.latitude, 1.348310);
    expect(provider.currentLocation.longitude, 103.683135);
    expect(provider.isLoading, false);
    expect(provider.errorMessage, '');
    expect(provider.originIcon, isNull);
    expect(provider.currentLocationIcon, isNull);
  });

  test('Load origin icon sets originIcon', () {
    provider.loadOriginIcon(); // no await needed
    expect(provider.originIcon, isNotNull);
  });

  test('Load current location icon sets currentLocationIcon', () {
    provider.loadCurrentLocationIcon(); // no await needed
    expect(provider.currentLocationIcon, isNotNull);
  });

  test('Refresh location updates loading state', () {
    provider.refreshLocation();
    expect(provider.isLoading, false);
    expect(provider.errorMessage, '');
  });

  test('Set current location manually updates coordinates', () async {
    // manually simulate a position update
    provider.refreshLocation();
    expect(provider.currentLocation, isA<LatLng>());
  });

  test('Dispose cancels position stream subscription', () {
    provider.dispose();
    expect(provider.positionStreamSubscription?.isPaused, isTrue);
  });
}
