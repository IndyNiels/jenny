import 'package:chat_gpt_02/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            headerMaxExtent: 300,
            maxWidth: 100,
            providers: [
              EmailAuthProvider(),
              GoogleProvider(
                  clientId:
                      '88461763705-lbste35triekssvnpti04fn4rcfi746j.apps.googleusercontent.com'),
            ],
            headerBuilder: (context, constraints, shrinkOffset) {
              return Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  ClipOval(
                    child: Image.asset(
                      'assets/assistant.png',
                      width: 120,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      textAlign: TextAlign.center,
                      'Welcome to Coach AI',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            },
            footerBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  children: [
                    RichText(
                        text: TextSpan(children: <TextSpan>[
                      const TextSpan(
                          text:
                              'I\'m older than 18 years old and I agree to the ',
                          style: TextStyle(color: Colors.grey)),
                      TextSpan(
                        text: 'Terms and Conditions',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            //Open a pop up with the terms and conditions
                            //Make the dialog scrollable

                            showDialog(
                              barrierColor: Colors.black.withOpacity(0.3),
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  insetPadding: const EdgeInsets.all(20),
                                  surfaceTintColor: Colors.white,
                                  elevation: 10,
                                  title: const Text(
                                    'Disclaimer and Terms of Agreement',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24),
                                  ),
                                  content: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    child: SingleChildScrollView(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                                'By using this application, you agree to the following terms:'),
                                            const SizedBox(height: 16),
                                            _buildListItem(
                                              'Non-Professional Advice',
                                              'You acknowledge that I am not a licensed psychologist, therapist, or healthcare professional. This application is not intended to replace any accredited professionals.',
                                            ),
                                            _buildListItem(
                                              'No Liability',
                                              'I cannot take responsibility for the results of your actions and any harm you suffer as a result of the use or misuse of the information presented by this app.',
                                            ),
                                            _buildListItem(
                                              'Personal Responsibility',
                                              'You agree to use judgment and due diligence before taking any action or plan suggested by the app.',
                                            ),
                                            _buildListItem(
                                              'Safety First',
                                              'Do not use this app if you feel in danger to yourself or others. If you feel unwell, please seek the help of your loved ones or find professional help.',
                                            ),
                                            const SizedBox(height: 16),
                                            const Text(
                                                'By using this application, you accept and agree to abide by these terms and conditions.'),
                                          ]),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                      ),
                      const TextSpan(
                          text: ' and ', style: TextStyle(color: Colors.grey)),
                      TextSpan(
                        text: 'Privacy Policy.',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            //Open a pop up with the privacy policy

                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  insetPadding: const EdgeInsets.all(20),
                                  surfaceTintColor: Colors.white,
                                  title: const Text(
                                    'Privacy Policy',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24),
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 16),
                                        const Text(
                                            'By using this application, you agree to the following terms:'),
                                        const SizedBox(height: 16),
                                        _buildListItem(
                                          'Data Collection',
                                          'This app may collect certain information about its users, such as prompts given to the chat. This data is collected to improve user experience and functionality.',
                                        ),
                                        _buildListItem(
                                          'Anonymized Data',
                                          'If the information is handled for improvement purposes, the data is anonymized and never associated with the user in question.',
                                        ),
                                        _buildListItem(
                                          'Data Usage',
                                          'The information collected is used solely for the purpose of enhancing the app’s performance and delivering personalized content. Your data will not be sold, shared, or disclosed to third parties without your consent, except as required by law.',
                                        ),
                                        _buildListItem(
                                          'Data Security',
                                          'We take reasonable measures to protect your data from unauthorized access, alteration, disclosure, or destruction. However, no method of transmission over the internet or electronic storage is 100% secure.',
                                        ),
                                        _buildListItem(
                                          'User Responsibility',
                                          'You are responsible for maintaining the confidentiality of your account and any activity that occurs under your account.',
                                        ),
                                        _buildListItem(
                                          'Policy Updates',
                                          'This privacy policy may be updated periodically. Continued use of the app signifies your acceptance of any changes.',
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                            'By using this application, you acknowledge that you have read, understood, and agree to the terms of this privacy policy.'),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                      ),
                    ])),
                    // Text(
                    //   'I\'m older than 18 years old and I agree with the Terms and Conditions and and Privacy Policy $action',
                    //   style:  const TextStyle(color: Colors.grey),
                    // ),
                  ],
                ),
              );
            },
          );
        }

        return const ChatScreen();
      },
    );
  }
}

Widget _buildListItem(String title, String description) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text(description),
      ],
    ),
  );
}
