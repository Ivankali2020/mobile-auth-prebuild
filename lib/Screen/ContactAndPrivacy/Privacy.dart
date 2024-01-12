import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Privacy extends StatefulWidget {
  const Privacy({super.key});

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  final List<Map<String, String>> data = [
    {
      'Privacy and Policy':
          "This privacy policy ('Policy') describes how Gold Mobile ('we,' 'us,' or 'our') collects, uses, and shares information about you when you use our mobile application ('App') or any of our related services (collectively, 'Services')Please read this Policy carefully to understand our policies and practices regarding your information and how we will treat it. If you do not agree with our policies and practices, do not download or use the App. By downloading or using the App, you agree to the collection, use, and sharing of your information as described in this Policy. This Policy may change from time to time. Your continued use of the App after we make changes is deemed to be acceptance of those changes, so please check the Policy periodically for updates."
    },
    {
      'Consent':
          "By using our website, you hereby consent to our Privacy Policy and agree to its terms."
    },
    {
      'Information We Collect ':
          "The personal information that you are asked to provide, and the reasons why you are asked to provide it, will be made clear to you at the point we ask you to provide your personal information.If you contact us directly, we may receive additional information about you such as your name, email address, phone number, the contents of the message and/or attachments you may send us, and any other information you may choose to provide.When you register for an Account, we may ask for your contact information, including items such as name, company name, address, email address, and telephone number."
    },
    {
      'Advertising Partners Privacy Policies':
          "You may consult this list to find the Privacy Policy for each of the advertising partners of Gold Mobile Application.Third-party ad servers or ad networks uses technologies like cookies, JavaScript, or Web Beacons that are used in their respective advertisements and links that appear on Gold Mobile Application, which are sent directly to users' browser. They automatically receive your IP address when this occurs. These technologies are used to measure the effectiveness of their advertising campaigns and/or to personalize the advertising content that you see on websites that you visit.Note that Gold Mobile Application has no access to or control over these cookies that are used by third-party advertisers."
    },
    {
      'Third Party Privacy Policies':
          "Gold Mobile's Privacy Policy does not apply to other advertisers or websites. Thus, we are advising you to consult the respective Privacy Policies of these third-party ad servers for more detailed information. It may include their practices and instructions about how to opt-out of certain options.You can choose to disable cookies through your individual browser options. To know more detailed information about cookie management with specific web browsers, it can be found at the browsers' respective websites."
    },
    {
      'Children\'s Information':
          "Another part of our priority is adding protection for children while using the internet. We encourage parents and guardians to observe, participate in, and/or monitor and guide their online activity.Gold Mobile does not knowingly collect any Personal Identifiable Information from children under the age of 13. If you think that your child provided this kind of information on our website, we strongly encourage you to contact us immediately and we will do our best efforts to promptly remove such information from our records."
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text(
          //   'Terms and Conditions',
          //   style: GoogleFonts.bebasNeue(fontSize: 20, letterSpacing: 3),
          // ),
          ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) {
              return Column(
                children: [
                  i == 0
                      ? Center(
                          child: CachedNetworkImage(
                            colorBlendMode: BlendMode.overlay,
                            imageUrl:
                                'https://cdni.iconscout.com/illustration/premium/thumb/website-privacy-policy-4697846-3901012.png',
                            placeholder: (context, url) => Container(
                                width: 300,
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator()),
                            width: 300,
                          ),
                        )
                      : Container(),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    data[i].keys.first,
                    style:
                        GoogleFonts.bebasNeue(fontSize: 18, letterSpacing: 3),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    data[i].values.first,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              );
            }),
      ),
    );
  }
}