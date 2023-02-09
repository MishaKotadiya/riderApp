import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riderapp/All%20widgets/progessDialog.dart';
import 'package:riderapp/LoginScreen.dart';
import 'package:riderapp/main.dart';
import 'package:riderapp/mainscreen.dart';

class RegisterationScreen extends StatelessWidget {
  static const String idScreen = "register";

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
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
              SizedBox(height: 20.0,),
              Image(
                image: AssetImage("images/logo.png"),
                width: 290.0,
                height: 150.0,
                alignment: Alignment.center,
              ),

              SizedBox(height: 0.0,),
              Text(
                "Signup as a rider",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Name",
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
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone No.",
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
                              "Create Account",
                              style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),
                            ),
                          ),
                        ),

                        onPressed: ()
                        {
                          if(nameTextEditingController.text.length<4){
                            displayToastMessage("Invalid name",context);
                          }
                          else if(!emailTextEditingController.text.contains("@")){
                            displayToastMessage("Invalid email ID", context);
                          }
                          else if(phoneTextEditingController.text.isEmpty){
                            displayToastMessage("wrong Phone Number", context);
                          }
                          else if(passwordTextEditingController.text.length<6){
                            displayToastMessage("password must of 6 words", context);
                          }
                          else {
                            registerNewUser(context);
                          }
                        }
                    ),

                  ],
                ),
              ),
              TextButton(
                onPressed : ()
                {
                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                },
                child: Text(
                  "Already have an Account? Login Here.",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void registerNewUser(BuildContext context) async
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext Context){
          return ProgressDialog(message: "Authenticating, please wait..");
        });

    final User? firebaseUser = (await _firebaseAuth.createUserWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text,
    ).catchError((errMsg){
      Navigator.pop(context);
      displayToastMessage("Error : " + errMsg.toString(), context);
    })).user;

    if(firebaseUser != null)
    {
      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      usersRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage("Registration Done!!", context);
      Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);

    }
    else{
      Navigator.pop(context);
      displayToastMessage("New User has not been created", context);
    }
  }

   displayToastMessage(String s, BuildContext context) {
    Fluttertoast.showToast(msg: s);
  }
}
