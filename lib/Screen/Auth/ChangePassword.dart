import 'dart:io';

import '../../Provider/AuthManager.dart';
import '../../Provider/UserProvider.dart';
import '../../Widgets/SnackBarWidget.dart';
import '../../main.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  late String oldPassword = '';
  late String password = '';
  ChangePassword(
      {super.key, required this.oldPassword, required this.password});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _obscureText = true;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController userConfirmPassword = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    oldPassword.text = widget.oldPassword;
    newPassword.text = widget.password;
  }

  Future<void> submit(BuildContext context) async {
    if (!_key.currentState!.validate()) {
      return;
    }
    final Map<String, dynamic> data = {
      'old_password': oldPassword.text,
      'password': newPassword.text,
      'password_confirmation': userConfirmPassword.text,
    };

    final token = await AuthManager.getToken();

    final response = await Provider.of<UserProvider>(context, listen: false)
        .changePassword(data,token!);

    // /what is i don't know for suggestion only
    if (!context.mounted) return;
    if (response['status'] == true) {
      snackBarWidget(context, response['message']);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) =>  Main(title: 'Gold Mobile',),
          ),
          (route) => false);
           snackBarWidget(context, 'Successfully Changed!');
    } else {
      snackBarWidget(context, 'SOMETHING WAS WRONG!');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    oldPassword.dispose();
    newPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Center(
              child: CachedNetworkImage(
                colorBlendMode: BlendMode.overlay,
                imageUrl:
                    'https://cdn3d.iconscout.com/3d/premium/thumb/access-key-5353060-4468792.png',
                placeholder: (context, url) => Container(
                    width: 200,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator()),
                width: 200,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _key,
              child: Column(
                children: [
                  TextFormField(
                    controller: oldPassword,
                    scrollPadding: const EdgeInsets.all(10),
                    decoration: InputDecoration(
                      contentPadding:const EdgeInsets.all(14),
                      labelText: 'Old Password',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                    ),
                    validator: (value) {
                      if (value == '') {
                        return 'Required';
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: _obscureText,
                    controller: newPassword,
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
                      contentPadding:const EdgeInsets.all(14),
                      labelText: 'New Password',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer),
                          borderRadius:const BorderRadius.all(Radius.circular(8))),
                    ),
                    validator: (value) {
                      if (value == '') {
                        return 'လျှို့၀ှက်နံပတ် လိုအပ်ပါသည်';
                      }

                      if(value!.length <= 5){
                        return 'လျှို့၀ှက်နံပတ် အနည်းဆုံး ၆ လုံးရှိရပါမည်';
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
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
                      contentPadding:const EdgeInsets.all(14),
                      labelText: 'New Password',
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                    ),
                    validator: (value) {
                      if (value == '') {
                        return 'လျှို့၀ှက်နံပတ် ထည့်ပေးပါ';
                      }

                      if (value == '' || value != newPassword.text) {
                        return 'လျှို့၀ှက်နံပတ် တူညီရပါမည်';
                      }

                      if(value!.length <= 5){
                        return 'လျှို့၀ှက်နံပတ် အနည်းဆုံး ၆ လုံးရှိရပါမည်';
                      }

                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SubmitButton(context),
                ],
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
                  ? CircularProgressIndicator()
                  : const Text(
                      'အတည်ပြုမည်',
                      style: TextStyle(fontSize: 15),
                    );
            }),
          ),
        ),
      ),
    );
  }
}