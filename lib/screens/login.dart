import 'package:flutter/material.dart';
import 'package:ourapp/provider/internet.dart';
import 'package:ourapp/provider/signIn.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:ourapp/screens/homepage.dart';
import 'package:ourapp/utils/snack.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../utils/nextScreen.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  PageController _pageController = PageController();

  final RoundedLoadingButtonController googleController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/images/newwelcome.jpg", // Replace with your image path
          fit: BoxFit.cover,
          width: 400,
          height: 780,
        ),
        Positioned(
          bottom: 30, // Adjust the position as per your requirement
          right: 40,
          child: RoundedLoadingButton(
            onPressed: () {
              handleGoogleSignIn();
            },
            controller: googleController,
            successColor: Colors.blue,
            width: MediaQuery.of(context).size.width * 0.80,
            elevation: 0,
            borderRadius: 25,
            child: Wrap(
              children: [
                Icon(
                  FontAwesomeIcons.google,
                  size: 20,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 15,
                ),
                Text("Sign in with Google",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold))
              ],
            ),
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future handleGoogleSignIn() async {
    final sp = context.read<signIn>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();
    if (ip.hasInternet == false) {
      openSnackBar(context, "Check your Internet Connection", Colors.red);
      googleController.reset();
    } else {
      await sp.signInWithGoogle().then((value) {
        if (sp.hasError == true) {
          openSnackBar(context, sp.errorCode.toString(), Colors.red);
          googleController.reset();
        } else {
          sp.checkUserExists().then((value) async {
            if (value == true) {
              await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        googleController.success();
                        handleAfterSignIn();
                      })));
              //user exists
            } else {
              sp.saveDataToFirestore().then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        googleController.success();
                        handleAfterSignIn();
                      })));
            }
          });
        }
      });
    }
  }

  //handle after sign
  handleAfterSignIn() {
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      nextScreenReplace(context, HomePage());
    });
  }
}
