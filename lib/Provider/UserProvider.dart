import 'dart:convert';
import 'dart:io';

import '../Modal/User.dart';
import '../Modal/AppInfomation.dart';
import '../Helper/Http.dart';
import '../Provider/AuthManager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProvider with ChangeNotifier {
  User? userData;
  late String? token = '';
  late bool isLoading = false;
  AppInfomation? appInfomation;
  late ThemeMode mode = ThemeMode.light;

  void toggleColor(isLight) {
    if (isLight) {
      mode = ThemeMode.light;
    } else {
      mode = ThemeMode.dark;
    }
    notifyListeners();
  }

  UserProvider(Map? data) {
    if (data != null) {
      userData = data['user'];
      token = data['token'];
      notifyListeners();
    }
  }

  Future<void> fetchAppInfomation() async {
    final data = await Http.getDate('/app/detail');

    if (data['status']) {
      appInfomation = AppInfomation.fromJson(data['data']);
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> Register(Map<String, dynamic> data) async {
    isLoading = true;
    notifyListeners();
    final getUrl = Uri.parse('${Http.coreUrl}/register');
    final Map<String, String> customHeaders = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final user = jsonEncode(data);
    try {
      final data = await http.post(getUrl, headers: customHeaders, body: user);
      print(data.body);

      final json = jsonDecode(data.body);

      if (data.statusCode == 200 && json['status']) {
        isLoading = false;
        return {
          'status': true,
          'message': 'Login Now',
        };
      }

      isLoading = false;
      notifyListeners();
      return {'status': false, 'message': json['message']};
    } catch (err) {
      isLoading = false;
      return {'status': false, 'message': err.toString()};
    }
  }

  Future<Map<String, dynamic>> Login(Map<String, dynamic> data) async {
    final getUrl = Uri.parse('${Http.coreUrl}/login');
    final Map<String, String> customHeaders = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    isLoading = true;
    notifyListeners();

    final user = jsonEncode(data);
    try {
      final data = await http.post(getUrl, headers: customHeaders, body: user);
      final decode = jsonDecode(data.body);
      print(decode);
      if (decode['status']) {
        userData = User.fromJson(decode['data']);
        token = decode['token'];
        isLoading = false;

        //store on local
        AuthManager.setUserAndToken(
            decode['token'], User.fromJson(decode['data']));

        return {
          'status': true,
          'message': 'Successfully Login',
        };
      }

      isLoading = false;
      notifyListeners();
      return {'status': false, 'message': 'SOMETHING WAS WRONG'};
    } catch (err) {
      isLoading = false;
      notifyListeners();
      print(err);
      return {'status': false, 'message': err.toString()};
    }
  }

  Future<Map<String, dynamic>> profileUpdate(Map rawData) async {
    final Map<String, String> customHeaders = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final url = Uri.parse(Http.coreUrl + "/change/profile");
    final data = jsonEncode(rawData);
    final response = await http.post(url, headers: customHeaders, body: data);
    final json = jsonDecode(response.body);
    print(json);
    if (json['status']) {
      userData!.name = rawData['name'];
      // userData!.credentials = rawData['credentials'];
      notifyListeners();
      return {'status': true, 'message': json['message']};
    }

    return {'status': false, 'message': 'FAILED!'};
  }

  Future<Map<String, dynamic>> changeImage(File image) async {
    final Map<String, String> customHeaders = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final url = Uri.parse(Http.coreUrl + "/change/profile");

    final request = http.MultipartRequest('POST', url);

    request.files.add(await http.MultipartFile.fromPath('photo', image.path));

    request.headers.addAll(customHeaders);
    final send = await request.send();
    final response = await send.stream.bytesToString();

    final json = jsonDecode(response);

    if (json['status']) {
      userData!.photo = json['data']['photo'];

      notifyListeners();
      return {'status': true, 'message': json['message']};
    }

    return {'status': false, 'message': 'FAILED!'};
  }

  Future<Map<String, dynamic>> logOut() async {
    final Map<String, String> customHeaders = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    await AuthManager.removeUserAndToken();

    final url = Uri.parse(Http.coreUrl + "/logout");
    final response = await http.post(url, headers: customHeaders);
    final json = jsonDecode(response.body);

    if (json['status']) {
      token = '';
      userData = null;

      notifyListeners();
      return {'status': true, 'message': "Loggout!"};
    }

    return {'status': false, 'message': 'FAILED!'};
  }

  Future<Map<String, dynamic>> deleteAccount() async {
    final Map<String, String> customHeaders = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final url = Uri.parse(Http.coreUrl + "/delete/user");
    final response = await http.get(url, headers: customHeaders);
    final json = jsonDecode(response.body);

    print(json);

    if (json['status']) {
      token = '';
      userData = null;
      await AuthManager.removeUserAndToken();
      notifyListeners();
      return {'status': true, 'message': "DELETED!"};
    }

    return {'status': false, 'message': 'FAILED!'};
  }

  Future<Map<String, dynamic>> changePassword(
      Map<String, dynamic> userData, String token) async {
    final getUrl = Uri.parse('${Http.coreUrl}/change/password');
    final Map<String, String> customHeaders = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    isLoading = true;
    notifyListeners();
    final user = jsonEncode(userData);
    try {
      final data = await http.post(getUrl, headers: customHeaders, body: user);
      final json = jsonDecode(data.body);
      print(userData);
      print(json);
      if (json['status'] && data.statusCode == 200) {
        isLoading = false;
        //store on local
        return {
          'status': true,
          'message': 'Successfully Change',
        };
      }

      isLoading = false;
      notifyListeners();
      return {'status': false, 'message': json['message']};
    } catch (err) {
      isLoading = false;
      notifyListeners();
      return {'status': false, 'message': err.toString()};
    }
  }
}
