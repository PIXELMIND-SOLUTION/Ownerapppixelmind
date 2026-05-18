// // lib/providers/client_provider.dart

// import 'dart:io';
// import 'package:client_support_app/constant/api_constant.dart';
// import 'package:client_support_app/helper/storage_helper.dart';
// import 'package:client_support_app/models/profile_model.dart';
// import 'package:client_support_app/services/auth/profile_service.dart';
// import 'package:flutter/foundation.dart';


// enum ClientStatus { idle, loading, success, error }

// class ClientProvider extends ChangeNotifier {
//   ProfileModel?  _profile;
//   ClientStatus   _status = ClientStatus.idle;
//   String?        _error;

//   ProfileModel?  get profile    => _profile;
//   ClientStatus   get status     => _status;
//   String?        get error      => _error;
//   bool           get isLoading  => _status == ClientStatus.loading;

//   String get profileImageUrl {
//     final path = _profile?.profileImage;
//     if (path == null || path.isEmpty) return '';
//     return ApiConstants.mediaUrl(path);
//   }

//   Future<void> loadFromPrefs() async {
//     _setLoading();
//     try {
//       final client = await PreferenceHelper.getClient();
//       if (client == null) {
//         _setError('No session found');
//         return;
//       }
//       await _fetchProfile(client.id);
//     } catch (e) {
//       _setError(e.toString());
//     }
//   }

//   Future<void> fetchProfile() async {
//     if (_profile == null) return;
//     _setLoading();
//     try {
//       await _fetchProfile(_profile!.id);
//     } catch (e) {
//       _setError(e.toString());
//     }
//   }

//   Future<bool> uploadProfileImage(File imageFile) async {
//     if (_profile == null) return false;
//     _setLoading();
//     try {
//       final imagePath = await ClientService.instance.uploadProfileImage(
//         clientId:  _profile!.id,
//         imageFile: imageFile,
//       );
//       _profile = _profile!.copyWith(profileImage: imagePath);
//       _setSuccess();
//       return true;
//     } catch (e) {
//       _setError(e.toString());
//       return false;
//     }
//   }

//   void clearClient() {
//     _profile = null;
//     _status  = ClientStatus.idle;
//     _error   = null;
//     notifyListeners();
//   }

//   Future<void> _fetchProfile(String clientId) async {
//     _profile = await ClientService.instance.fetchClientProfile(clientId);
//     _setSuccess();
//   }

//   void _setLoading() {
//     _status = ClientStatus.loading;
//     _error  = null;
//     notifyListeners();
//   }

//   void _setSuccess() {
//     _status = ClientStatus.success;
//     notifyListeners();
//   }

//   void _setError(String message) {
//     _status = ClientStatus.error;
//     _error  = message;
//     notifyListeners();
//   }
// }













/////////// Fixed the image loading issue provider //////////////



// ignore_for_file: dangling_library_doc_comments

import 'dart:io';
import 'package:client_support_app/constant/api_constant.dart';
import 'package:client_support_app/helper/storage_helper.dart';
import 'package:client_support_app/models/profile_model.dart';
import 'package:client_support_app/services/auth/profile_service.dart';
import 'package:flutter/foundation.dart';

enum ClientStatus { idle, loading, success, error }

class ClientProvider extends ChangeNotifier {
  ProfileModel?  _profile;
  ClientStatus   _status = ClientStatus.idle;
  String?        _error;
  String?        _tempImageUrl; 
  ProfileModel?  get profile    => _profile;
  ClientStatus   get status     => _status;
  String?        get error      => _error;
  bool           get isLoading  => _status == ClientStatus.loading;

  String get profileImageUrl {
    if (_tempImageUrl != null && _tempImageUrl!.isNotEmpty) {
      return _tempImageUrl!;
    }
    
    final path = _profile?.profileImage;
    if (path == null || path.isEmpty) return '';
    
    return ApiConstants.mediaUrl(path);
  }

  Future<void> loadFromPrefs() async {
    _setLoading();
    try {
      final client = await PreferenceHelper.getClient();
      if (client == null) {
        _setError('No session found');
        return;
      }
      await _fetchProfile(client.id);
      _tempImageUrl = null; 
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> fetchProfile() async {
    if (_profile == null) return;
    _setLoading();
    try {
      await _fetchProfile(_profile!.id);
      _tempImageUrl = null; 
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<bool> uploadProfileImage(File imageFile) async {
    if (_profile == null) return false;
    _setLoading();
    try {
      final imagePath = await ClientService.instance.uploadProfileImage(
        clientId:  _profile!.id,
        imageFile: imageFile,
      );
      
      _tempImageUrl = ApiConstants.mediaUrl(imagePath);
      
      _profile = _profile!.copyWith(profileImage: imagePath);
      
      _setSuccess();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  void clearClient() {
    _profile = null;
    _status  = ClientStatus.idle;
    _error   = null;
    _tempImageUrl = null;
    notifyListeners();
  }

  Future<void> _fetchProfile(String clientId) async {
    _profile = await ClientService.instance.fetchClientProfile(clientId);
    _setSuccess();
  }

  void _setLoading() {
    _status = ClientStatus.loading;
    _error  = null;
    notifyListeners();
  }

  void _setSuccess() {
    _status = ClientStatus.success;
    notifyListeners();
  }

  void _setError(String message) {
    _status = ClientStatus.error;
    _error  = message;
    notifyListeners();
  }
}