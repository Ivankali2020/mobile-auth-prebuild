import 'dart:io';

import '../../Provider/UserProvider.dart';
import '../../Screen/Auth/Register.dart';
import '../../Widgets/SnackBarWidget.dart';
import '../../main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  late String name = '';
  late String password = '';
  Login({super.key, required this.name, required this.password});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  TextEditingController userPhone = TextEditingController();
  TextEditingController userPassword = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userPhone.text = widget.name;
    userPassword.text = widget.password;
  }

  Future<void> submit(BuildContext context) async {
    if (!_key.currentState!.validate()) {
      return;
    }
    // String? FcmToken = await FirebaseMessaging.instance.getToken();
    final Map<String, dynamic> data = {
      'phone': userPhone.text,
      'password': userPassword.text,
      'fcm_token_key': 'FcmToken',
    };

    final response =
        await Provider.of<UserProvider>(context, listen: false).Login(data);

    print(response);

    ///what is i don't know for suggestion only
    if (!context.mounted) return;
    if (response['status'] == true) {
      snackBarWidget(context, response['message']);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const Main(
              title: 'WELCOME',
            ),
          ),
          (route) => false);
    } else {
      snackBarWidget(context, 'SOMETHING WAS WRONG!');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userPhone.dispose();
    userPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 18.0),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const Main(
                            title: 'Lottery',
                          ),
                        ),
                      );
                    },
                    child: Image.asset(
                      'lib/assets/play_store_512.png',
                      width: 300,
                      height: 300,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Form(
              key: _key,
              child: Column(
                children: [
                  TextFormField(
                    controller: userPhone,
                    scrollPadding: const EdgeInsets.all(10),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(14),
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                    ),
                    validator: (value) {
                      if (value == '') {
                        return 'Required phone number';
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: _obscureText,
                    controller: userPassword,
                    scrollPadding: const EdgeInsets.all(10),
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(14),
                      labelText: 'Password',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                    ),
                    validator: (value) {
                      if (value == '') {
                        return 'Required Phone';
                      }
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  SubmitButton(context),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Register()),
                  (route) => false,
                )
              },
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                width: double.infinity,
                alignment: Alignment.bottomRight,
                child: const Text(
                  'Don\'t have an account ? Sign Up',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container SubmitButton(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary,
            offset: Offset(5, 5),
            blurRadius: 0,
            spreadRadius: 0,
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          overlayColor: MaterialStateProperty.all(
              Theme.of(context).colorScheme.surfaceVariant),
          splashColor: Theme.of(context).colorScheme.secondaryContainer,
          onTap: () => submit(context),
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            child: Consumer<UserProvider>(builder: (context, value, child) {
              return value.isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
                      'Sign In',
                      style: TextStyle(fontSize: 18),
                    );
            }),
          ),
        ),
      ),
    );
  }
}
