import 'package:yodiyar/main.dart';

import '../../Provider/UserProvider.dart';
import '../../Screen/Auth/Login.dart';
import '../../Screen/Auth/Verify.dart';
import '../../Screen/Home.dart';
import '../../Widgets/SnackBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _obscureText = true;

  GlobalKey<FormState> _key = GlobalKey<FormState>();

  TextEditingController userName = TextEditingController();

  TextEditingController userPhone = TextEditingController();

  TextEditingController userPassword = TextEditingController();

  TextEditingController userConfirmPassword = TextEditingController();

  Future<void> submit() async {
    if (!_key.currentState!.validate()) {
      return;
    }
    // String? FcmToken = await FirebaseMessaging.instance.getToken();
    final data = {
      'name': userName.text,
      'phone': userPhone.text,
      'password': userPassword.text,
      'password_confirmation': userConfirmPassword.text,
      'fcm_token_key': 'FcmToken',
    };

    final response =
        await Provider.of<UserProvider>(context, listen: false).Register(data);

    if (response['status']) {
      snackBarWidget(context, response['message']);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Login(
                name: userPhone.text,
                password: userPassword.text,
              )));
    } else {
      print(response['message']);
      snackBarWidget(context, response['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    var boxDecoration = BoxDecoration(
        // color: Theme.of(context).colorScheme.surface,
        // borderRadius: BorderRadius.circular(8),
        // boxShadow: [
        //   BoxShadow(
        //     color: Theme.of(context).colorScheme.primary,
        //     offset: const Offset(4, 4),
        //     blurRadius: 0,
        //     spreadRadius: 0,
        //   )
        // ],
        );
    return Scaffold(
      body: Container(
        margin:const EdgeInsets.all(18),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Main(title: 'Lottery',),
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
            const SizedBox(
              height: 30,
            ),
            Form(
              key: _key,
              child: Column(
                children: [
                  Container(
                    decoration: boxDecoration,
                    child: TextFormField(
                      controller: userName,
                      scrollPadding: const EdgeInsets.all(10),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(14),
                        labelText: 'Name',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                      validator: (value) {
                        if (value == '') {
                          return 'Fill the name';
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: boxDecoration,
                    child: TextFormField(
                      controller: userPhone,
                      scrollPadding: const EdgeInsets.all(10),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(14),
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                      validator: (value) {
                        if (value == '') {
                          return 'Fill the phone';
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: boxDecoration,
                    child: TextFormField(
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
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                      validator: (value) {
                        if (value == '' || value!.length < 8) {
                          return 'Fill the password';
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: boxDecoration,
                    child: TextFormField(
                      obscureText: _obscureText,
                      controller: userConfirmPassword,
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
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                      ),
                      validator: (value) {
                        if (value == '' || value != userPassword.text) {
                          return 'Fill the same password';
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SubmitButton(context)
                ],
              ),
            ),
            GestureDetector(
              onTap: () => {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => Login(
                        name: '',
                        password: '',
                      ),
                    ),
                    (route) => false)
              },
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                width: double.infinity,
                alignment: Alignment.bottomRight,
                child: const Text(
                  'Already have an account ? Login',
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
          onTap: submit,
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            child: Consumer<UserProvider>(builder: (context, value, child) {
              return value.isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 18),
                    );
            }),
          ),
        ),
      ),
    );
  }
}
