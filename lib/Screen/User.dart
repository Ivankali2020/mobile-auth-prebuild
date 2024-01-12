import 'dart:io';

import '../Provider/UserProvider.dart';
import '../Screen/Auth/ChangePassword.dart';
import '../Screen/Auth/Login.dart';
import '../Screen/ContactAndPrivacy/About.dart';
import '../Screen/ContactAndPrivacy/Privacy.dart';
import '../Widgets/SnackBarWidget.dart';
import '../main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class User extends StatefulWidget {
  User({Key? key}) : super(key: key);

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController userPhone = TextEditingController();
  TextEditingController userName = TextEditingController();

  Future<void> submit(context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final Map<String, dynamic> data = {
      'name': userName.text,
      // 'credentials': userPhone.text,
    };

    final response = await Provider.of<UserProvider>(context, listen: false)
        .profileUpdate(data);

    ///what is i don't know for suggestion only
    if (response['status'] == true) {
      snackBarWidget(context, response['message']);
      Navigator.of(context).pop();
    } else {
      snackBarWidget(context, 'SOMETHING WAS WRONG!');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // getTokenAndUser();

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    Future<void> _logout() async {
      final Map<String, dynamic> response =
          await Provider.of<UserProvider>(context, listen: false).logOut();

      if (response['status']) {
        snackBarWidget(context, response['message']);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Main(title: 'title')));
      } else {
        snackBarWidget(context, response['message']);
      }
    }

    Future<void> _changeImage(context) async {
      final picker = ImagePicker();
      final data = await picker.pickImage(source: ImageSource.gallery);

      if (data!.path != null) {
        final response = Provider.of<UserProvider>(context, listen: false)
            .changeImage(File(data.path));
      }
    }

    Future<void> _showModalBox(BuildContext context) async {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text('Name Update'),
            content: Form(
              key: _formKey,
              child: Container(
                height: 150,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: userName,
                        scrollPadding: const EdgeInsets.all(10),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(14),
                          labelText: 'User Name',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                        ),
                        validator: (value) {
                          if (value == '') {
                            return 'Required';
                          }
                        },
                      ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // TextFormField(
                      //   controller: userPhone,
                      //   scrollPadding: EdgeInsets.all(10),
                      //   decoration: const InputDecoration(
                      //     contentPadding: EdgeInsets.all(14),
                      //     labelText: 'Phone',
                      //     border: OutlineInputBorder(
                      //         borderSide: BorderSide(color: Colors.grey),
                      //         borderRadius:
                      //             BorderRadius.all(Radius.circular(8))),
                      //   ),
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        overlayColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.surfaceVariant),
                        splashColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                        onTap: () => submit(context),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8)),
                          child: const Text(
                            'Save',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          );
        },
      );
    }

    Future<void> deleteAccount(context) async {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text('Account Deleting'),
            icon: const Icon(Icons.dangerous_outlined, size: 30),
            content: const Text('Your Account Will Be Permanent Delete!'),
            actions: [
              TextButton(
                  onPressed: () async {
                    final response =
                        await Provider.of<UserProvider>(context, listen: false)
                            .deleteAccount();

                    if (response['status']) {
                      snackBarWidget(context, response['message']);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => Main(
                                title: 'Gold Mobile',
                              )));
                    } else {
                      snackBarWidget(context, response['message']);
                    }
                  },
                  child: const Text('Delete'))
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Profile',
          style: GoogleFonts.bebasNeue(fontSize: 20, letterSpacing: 3),
        ),
        actions: [
          Consumer<UserProvider>(
            builder: (context, value, child) {
              return value.mode == ThemeMode.dark
                  ? IconButton(
                      onPressed: () {
                        value.toggleColor(true);
                      },
                      icon: Icon(Icons.light_mode))
                  : IconButton(
                      onPressed: () {
                        value.toggleColor(false);
                      },
                      icon: Icon(Icons.dark_mode));
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Consumer<UserProvider>(
                            builder: (context, value, child) {
                              return CachedNetworkImage(
                                imageUrl: value.userData != null
                                    ? value.userData!.photo
                                    : 'https://cdn3d.iconscout.com/3d/premium/thumb/person-6877458-5638294.png',
                                placeholder: (context, i) =>
                                    const CircularProgressIndicator(),
                              );
                            },
                          ),
                        ),
                      ),
                      userProvider.token == ''
                          ? Container()
                          : Positioned(
                              top: -10,
                              right: -10,
                              child: IconButton(
                                onPressed: () => _changeImage(context),
                                icon: const Icon(Icons.edit),
                              ),
                            ),
                    ],
                  ),
                  Consumer<UserProvider>(
                    builder: (context, value, child) {
                      return value.userData == null
                          ? InkWell(
                              borderRadius: BorderRadius.circular(8),
                              overlayColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.surfaceVariant),
                              splashColor: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => Login(
                                      name: '',
                                      password: '',
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 150,
                                height: 35,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  // color: ,
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Login'.toUpperCase(),
                                ),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  value.userData!.name,
                                  style: GoogleFonts.bebasNeue(
                                      fontSize: 25, letterSpacing: 3),
                                ),
                                Text(
                                  value.userData!.phone,
                                  style: GoogleFonts.bebasNeue(
                                      fontSize: 15, letterSpacing: 3),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  overlayColor: MaterialStateProperty.all(
                                      Theme.of(context)
                                          .colorScheme
                                          .errorContainer),
                                  splashColor: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  onTap: () async {
                                    _showModalBox(context);
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 35,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      // color: ,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'EDIT '.toUpperCase(),
                                    ),
                                  ),
                                )
                              ],
                            );
                    },
                  )
                ],
              ),
              userProvider.token == ''
                  ? Container()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         const SizedBox(
                          height: 40,
                        ),

                        ActionButton(
                          function: () {
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => const Order()));
                          },
                          text: 'Order History',
                          icon: Icons.history,
                          color:
                              Theme.of(context).colorScheme.tertiaryContainer,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 15),
                          child: Text(
                            'Security',
                            style: GoogleFonts.bebasNeue(
                                fontSize: 15, letterSpacing: 2),
                          ),
                        ),
                        ActionButton(
                          function: () {
                            _logout();
                          },
                          text: 'Logout',
                          icon: Icons.logout_outlined,
                          color:
                              Theme.of(context).colorScheme.errorContainer,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ActionButton(
                          function: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChangePassword(
                                    oldPassword: '', password: ''),
                              ),
                            );
                          },
                          text: 'Change Password',
                          icon: Icons.key,
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ActionButton(
                          function: () => deleteAccount(context),
                          text: 'Delete Account',
                          icon: Icons.policy,
                          color: Theme.of(context).colorScheme.errorContainer,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: Text(
                  'Privacy and Policy',
                  style: GoogleFonts.bebasNeue(fontSize: 15, letterSpacing: 2),
                ),
              ),
              ActionButton(
                function: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Privacy(),
                    ),
                  );
                },
                text: 'Terms and Conditions',
                icon: Icons.privacy_tip,
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 15),
                child: Text(
                  'About',
                  style: GoogleFonts.bebasNeue(fontSize: 15, letterSpacing: 2),
                ),
              ),
              ActionButton(
                function: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => About(),
                    ),
                  );
                },
                text: 'About Application',
                icon: Icons.info_outline,
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  ActionButton({
    super.key,
    required this.function,
    required this.text,
    required this.icon,
    required this.color,
  });

  Function function;
  String text;
  IconData icon;
  Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(color),
      borderRadius: BorderRadius.circular(8),
      focusColor: color,
      splashColor: color,
      onTap: () => function(),
      child: Container(
        width: double.infinity,
        height: 45,
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          // color: ,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              color: Colors.grey,
            ),
            Text(
              text.toUpperCase(),
            ),
          ],
        ),
      ),
    );
  }
}
