// class ApiConstants {
//   ApiConstants._();

//   static const String baseUrl = 'http://31.97.228.17:5104/api';

//   static const String clientLogin = '$baseUrl/client/login';

//   static String clientProfile(String clientId) =>
//       '$baseUrl/admin/client/$clientId';

//   static String uploadProfileImage(String clientId) =>
//       '$baseUrl/client/$clientId/profile-image';

//   static String mediaUrl(String path) => 'http://31.97.228.17:5104/$path';
// }

class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://31.97.228.17:5104/api';
  static const String mediaBaseUrl = 'http://31.97.228.17:5104';

  static const String clientLogin = '$baseUrl/client/login';

  static String clientProfile(String clientId) =>
      '$baseUrl/admin/client/$clientId';

  static String uploadProfileImage(String clientId) =>
      '$baseUrl/client/$clientId/profile-image';

  static String mediaUrl(String path) {
    if (path.isEmpty) return '';

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return '$mediaBaseUrl/$cleanPath';
  }
}
