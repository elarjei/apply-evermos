import 'dart:async';

import 'package:http/http.dart' as http;

import '../constants/constants_secret.dart';

abstract class HelperApi {
  static Future<http.Response> getPexelsApi(String apiUrl) async {
    final url = Uri.parse(apiUrl);
    try {
      return await http.get(url, headers: {
        'Authorization': pexelsApiKey,
      }).timeout(
        const Duration(seconds: 100),
      );
    } on TimeoutException catch (_) {
      rethrow;
    } catch (error) {
      rethrow;
    }
  }
}
