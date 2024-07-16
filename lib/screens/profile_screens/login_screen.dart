import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunmi_pothys_parking_app/screens/entry_screens/entry_screen.dart';
import 'package:sunmi_pothys_parking_app/screens/home_screens/home_main_screen.dart';

import '../../utils/common_values.dart';
import '../../utils/constants.dart';
import '../../utils/notification_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _passwordVisible = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _loginButtonFocusNode = FocusNode();

  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _loginButtonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text(
        //     '[ App Login ]',
        //     style: TextStyle(backgroundColor: Colors.green, color: Colors.white),
        //   ),
        //   centerTitle: true,
        // ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              // App Logo
              Text(
              'App Login',
              style: appBarTextStyle(),
            ),
            const SizedBox(height: 50),
            Image.asset(
              'assets/app-logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            // App Name
            const Text(
              kAppName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Username Field
            TextField(
              controller: _usernameController,
              focusNode: _usernameFocusNode,
              autofocus: true,
              enabled: !_isLoading,
              decoration: _loginFieldsDesign(
                  labelText: 'Username', hintText: 'Enter your username'),
              onSubmitted: (value) {
                _usernameFocusNode.unfocus();
                FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
            ),
            const SizedBox(height: 20),
            TextField(
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                obscureText: !_passwordVisible,
                enabled: !_isLoading,
                decoration: _loginFieldsDesign(labelText: 'Password',
                    hintText: 'Enter your password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible ? Icons.visibility : Icons
                            .visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    )),
                onSubmitted: (value)
            {
            _passwordFocusNode.unfocus();
            FocusScope.of(context).requestFocus(_loginButtonFocusNode);
            },
          ),
          const SizedBox(height: 30),
          // Show loader or button based on loading state
          // Login Button
          _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
            style: ButtonStyle(
              elevation: WidgetStateProperty.all<double?>(5),
              padding: WidgetStateProperty.all<EdgeInsetsGeometry?>(const EdgeInsets.symmetric(horizontal: 80,vertical: 10)),
              shape: WidgetStateProperty.all<OutlinedBorder?>(const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))
              ))
            ),
            onPressed: () async {
              if (_usernameController.value.text.isNotEmpty &&
                  _passwordController.value.text.isNotEmpty) {
                if(_usernameController.value.text==kUserName&&_passwordController.value.text==kPassword)
                  {
                    setState(() => _isLoading = true);
                    await _saveUserData('1');
                    if (context.mounted) {
                      // setState(()=>_isLoading=false);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const HomeMainScreen()));
                    }
                  }else{
                  showSnackBar(context: context, message: 'Invalid Username and password');
                }
              } else {
                showSnackBar(context: context,
                    message: 'Username and Password fields should not be Empty');
              }
            },
            child: const Text('Login',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
          ),
          const SizedBox(height: 20),
          Text(
            'Counter No : $deviceSerialNo',
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 20),
          // App Version
          const Text(
            'App Version : $appVersion',
            style: TextStyle(fontSize: 12),
          ),
          ],
        ),
      ),
    )));
  }

  InputDecoration _loginFieldsDesign(
      {required String labelText, required String hintText, Widget? suffixIcon}) {
    return InputDecoration(
      border: const OutlineInputBorder(),
      contentPadding: const EdgeInsets.symmetric(
          horizontal: 20, vertical: 16.0),
      labelText: labelText,
      hintText: hintText,
      suffixIcon: suffixIcon,
    );
  }

  _saveUserData(String userLoginUserName) async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(loginUserNameString, userLoginUserName);
    loginUserName = userLoginUserName;
  }
}
