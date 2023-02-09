import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riderapp/All%20widgets/progessDialog.dart';
import 'package:riderapp/main.dart';
import 'package:riderapp/mainscreen.dart';
import 'package:riderapp/registerationScreen.dart';

class LoginScreen extends StatelessWidget {

  static const String idScreen = "login";
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 45.0,),
              Image(
                image: AssetImage("images/logo.png"),
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),

              SizedBox(height: 1.0,),
              Text(
                "Login as a rider",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 20.0,),
                    OutlinedButton(
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),
                          ),
                        ),
                      ),

                      onPressed: ()
                      {
                        if(!emailTextEditingController.text.contains("@")){
                          displayToastMessage("Invalid email ID", context);
                        }
                        else if(passwordTextEditingController.text.isEmpty){
                          displayToastMessage("Enter the password", context);
                        }
                        else {
                          loginAndAuthenticateUser(context);
                        }
                      }
                    ),

                  ],
                ),
              ),
              TextButton(
                  onPressed : ()
                  {
                    Navigator.pushNamedAndRemoveUntil(context, RegisterationScreen.idScreen, (route) => false);
                  },
                  child: Text(
                  "Do not have an Account? Register Here.",
                ),
              ),
            ],
          ),
        ),
      ),
    );
    }

    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    void loginAndAuthenticateUser(BuildContext context) async {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context)
          {
             return ProgressDialog(message: "Authenticating, please wait..");
          }
          );
      final User? firebaseUser = (await _firebaseAuth
          .signInWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text,
      ).catchError((errMsg) {
        Navigator.pop(context);
        displayToastMessage("Error : " + errMsg.toString(), context);
      })).user;

      if(firebaseUser != null) {
        usersRef.child(firebaseUser.uid).once().then((event){
          final snap = event.snapshot;
          if(snap.value != null){
            Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
            displayToastMessage("Logged-in successfully", context);
          }
          else
            {
              Navigator.pop(context);
              _firebaseAuth.signOut();
              displayToastMessage("No record exists for this user. Please create new account", context);
            }
        });

      }
      else{
        Navigator.pop(context);
        displayToastMessage("Error Occured, can not be Signed-in.", context);
      }

    }

    displayToastMessage(String s, BuildContext context) {
      Fluttertoast.showToast(msg: s);
    }

}
