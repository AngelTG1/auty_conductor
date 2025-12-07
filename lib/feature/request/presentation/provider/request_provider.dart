import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auty_conductor/core/ws/ws_service.dart';

class RequestProvider extends ChangeNotifier {
  bool isLoading = false;
  String? error;

  Future<void> create(
    BuildContext context, {
    required String driverUuid,
    required String mechanicUuid,
    required String description,
    required String address,
    required double lat,
    required double lng,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final ws = Provider.of<WsService>(context, listen: false);

      ws.sendCreateRequest({
        "driverUuid": driverUuid,
        "mechanicUuid": mechanicUuid,
        "description": description,
        "address": address,
        "lat": lat,
        "lng": lng,
      });
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
