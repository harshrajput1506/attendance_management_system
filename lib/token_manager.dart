import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  final storage = FlutterSecureStorage();

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<void> setToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  Future<void> deleteToken() async {
    await storage.delete(key: 'token');
  }

  Future<bool> isTokenValid() async {
    final token = await getToken();
    return token != null; // Return true if the token is present
  }
}
