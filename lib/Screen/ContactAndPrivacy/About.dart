import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../Provider/UserProvider.dart';
import '../../Widgets/SnackBarWidget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<UserProvider>(context, listen: false).fetchAppInfomation();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'lib/assets/play_store_512.png',
                width: 200,
                height: 200,
              ),
            ),
          ),
          SocialMedia(),
          const SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.center,
            child: const Text('Version 1.0.0'),
          )
        ],
      ),
    );
  }
}

class SocialMedia extends StatelessWidget {
  const SocialMedia({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, value, chid) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 15),
              child: Text(
                'Social Platform',
                style: TextStyle(fontSize: 15),
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(8),
              overlayColor: MaterialStateProperty.all(Colors.lightBlueAccent),
              splashColor: Colors.blueAccent,
              onTap: () async {
                if (value.appInfomation != null) {
                  if (value.appInfomation!.pageId == null) {
                    return;
                  }
                  final url = Uri.parse(value.appInfomation!.pageId!);

                  if (!await launchUrl(url,
                      mode: LaunchMode.externalApplication)) {
                    print('Can not launch');
                  }
                  ;
                }
              },
              child: Container(
                  width: double.infinity,
                  padding:const EdgeInsets.symmetric(horizontal: 20),
                  height: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    // color: ,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.facebook_outlined,
                        color: Colors.grey,
                      ),
                      Text(
                        'Facebook Page'.toUpperCase(),
                      ),
                    ],
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              borderRadius: BorderRadius.circular(8),
              overlayColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.surfaceVariant),
              splashColor: Theme.of(context).colorScheme.secondaryContainer,
              onTap: () async {
                if (value.appInfomation != null) {
                  if (value.appInfomation!.messagerId == null) {
                    return;
                  }
                  final url = Uri.parse(value.appInfomation!.messagerId!);
                  print(value.appInfomation!.messagerId!);

                  print('url');
                  if (!await launchUrl(url,
                      mode: LaunchMode.externalApplication)) {
                    print('Can not launch');
                  }
                  ;
                }
              },
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
                    const Icon(
                      Icons.messenger_outlined,
                      color: Colors.grey,
                    ),
                    Text(
                      'Messenger'.toUpperCase(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              borderRadius: BorderRadius.circular(8),
              overlayColor: MaterialStateProperty.all(Colors.lightBlueAccent),
              splashColor: Colors.lightBlue,
              onTap: () async {
                if (value.appInfomation != null) {
                  if (value.appInfomation!.phone == null) {
                    return;
                  }
                  final url = Uri.parse(
                      'viber://chat?number=' + value.appInfomation!.phone!);
                  if (!await launchUrl(url,
                      mode: LaunchMode.externalApplication)) {
                    print('Can not launch');
                  }
                }
              },
              child: Container(
                width: double.infinity,
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  // color: ,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.wechat_outlined,
                      color: Colors.grey,
                    ),
                    Text(
                      'Viber'.toUpperCase(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              borderRadius: BorderRadius.circular(8),
              overlayColor: MaterialStateProperty.all(Colors.lightBlueAccent),
              splashColor: Colors.lightBlue,
              onTap: () async {
                if (value.appInfomation != null) {
                  if (value.appInfomation!.phone == null) {
                    return;
                  }

                  snackBarWidget(context, value.appInfomation!.phone!);
                }
              },
              child: Container(
                width: double.infinity,
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  // color: ,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.phone,
                      color: Colors.grey,
                    ),
                    Text(
                      value.appInfomation != null ? value.appInfomation!.phone != null ?  value.appInfomation!.phone.toString() : ''  : '' ,
                    ),
                  ],
                ),
              ),
            ),
           const SizedBox(
              height: 10,
            ),
            InkWell(
              borderRadius: BorderRadius.circular(8),
              overlayColor: MaterialStateProperty.all(Colors.lightBlueAccent),
              splashColor: Colors.lightBlue,
              onTap: () async {
                if (value.appInfomation != null) {
                  if (value.appInfomation!.address == null) {
                    return;
                  }

                  snackBarWidget(context, value.appInfomation!.address!);
                }
              },
              child: Container(
                width: double.infinity,
                height: 100,
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  // color: ,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Icon(
                      Icons.place,
                      color: Colors.grey,
                    ),
                   Text(
                        value.appInfomation != null ? value.appInfomation!.address != null ?  value.appInfomation!.address.toString() : ''  : '' ,
                        maxLines: 3,
                        textAlign: TextAlign.center,
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}