import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/character_status.dart'; // Make sure to import your model

class ReportController extends GetxController {
  final scannedCodes = <String>[].obs;
  final partsMap = <String, List<CharacterStatus>>{}.obs;
  final inputText = ''.obs;
  final loading = false.obs;
  final error = ''.obs;
  static const maxSamples = 5;

  Future<void> handleScan(String code) async {
    code = code.trim();
    if (code.isEmpty) return;
    if (scannedCodes.contains(code)) return;
    if (scannedCodes.length >= maxSamples) {
      error.value = "Maximum $maxSamples codes at once!";
      return;
    }
    loading.value = true;
    error.value = '';
    try {
      final url = Uri.parse('https://s35qhg7z-8000.inc1.devtunnels.ms/grading_part_operation_details/$code');
      final response = await http.get(url).timeout(const Duration(seconds: 7)); // set a timeout

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          scannedCodes.add(code);
          partsMap[code] = data
              .map<CharacterStatus>((e) => CharacterStatus.fromJson(e))
              .toList();
          inputText.value = '';
        } else {
          error.value = "No data found for this Part ID.";
        }
      } else if (response.statusCode == 404) {
        error.value = "Part ID not found on server.";
      } else if (response.statusCode >= 500) {
        error.value = "Server error! Please try again later.";
      } else {
        error.value = "Unexpected error (${response.statusCode}): ${response.reasonPhrase}";
      }
    } on http.ClientException {
      error.value = "Cannot connect to server. Please check your internet or API status.";
    } on TimeoutException {
      error.value = "Request timed out. Please check your internet connection or try again later.";
    } catch (e) {
      error.value = "Something went wrong: ${e.toString()}";
    }
    loading.value = false;
  }

  void removeCode(String code) {
    scannedCodes.remove(code);
    partsMap.remove(code);
  }

  /// Call this to clear all UI state (chips, monitor, stats, summary...)
  void clearAll() {
    scannedCodes.clear();
    partsMap.clear();
    inputText.value = '';
    error.value = '';
  }
}
