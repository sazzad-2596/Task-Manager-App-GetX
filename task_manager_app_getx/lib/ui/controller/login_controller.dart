import 'package:get/get.dart';

import '../../data/models/user_model.dart';
import '../../data/network_caller/network_caller.dart';
import '../../data/network_caller/network_response.dart';
import '../../data/utility/urls.dart';
import 'auth_controller.dart';

class LoginController extends GetxController{
  bool _loginInProgress = false;
  String _failedMsg = " ";

  bool get loginInProgress => _loginInProgress;
  String get failureMsg => _failedMsg;

  Future<bool> login(String email, String password) async {
    _loginInProgress = true;
    update();

    final NetworkResponse response = await NetworkCaller.postRequest(
      Urls.login,
      body: {
        "email": email,
        "password": password,
      },
      isLogin: true,
    );

    _loginInProgress = false;
    update();

    if (response.isSuccess) {
      await Get.find<Auth>().saveUserInformation(
        response.jsonResponse["token"],
        UserModel.fromJson(response.jsonResponse['data']),
      );
      return true;

    } else {
      if (response.statusCode == 401) {
        _failedMsg =  "Email or Password is incorrect.";
      } else {
        _failedMsg = "Login failed! Plz try again.";
        }
      }
    return false;
    }
}