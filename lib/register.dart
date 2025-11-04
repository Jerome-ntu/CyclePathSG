import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclepathsg/screen/LoginUI.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cyclepathsg/common/styles/spacing_styles.dart';
import 'package:cyclepathsg/utils/image_strings.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:cyclepathsg/models/LoginCredentials.dart';
import 'package:cyclepathsg/lib/screen/LoginUI.dart';

import '/utils/sizes.dart';
import 'models/account.dart';

class RegisterPage extends StatelessWidget{
  RegisterPage({super.key});

  var emailController = TextEditingController();
  var passController = TextEditingController();
  var confirmPassController = TextEditingController();
  bool obscureTextPass = true;
  bool obscureTextConfirmPass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: TSpacingStyle.paddingWithAppBarHeight,
            child: Column(
              children: [
                // logo, title and sub-title

                // Spacing above image
                const SizedBox(height: 30),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(
                      height: 200,
                      image: AssetImage(TImages.createAccountLogo),
                    ),
                  ],
                ),

                Form(child: Column(
                  children: [
                    // email
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Iconsax.direct_right),
                          labelText: "E-mail"
                      ),
                    ),

                    const SizedBox(height: TSizes.spaceBtwInputFields),

                    // Password
                    StatefulBuilder(builder: (context, setState){
                      return TextFormField(
                        obscureText: obscureTextPass,
                        controller: passController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Iconsax.password_check),
                          labelText: "Password",
                          // suffixIcon: Icon(Iconsax.eye_slash)
                          suffixIcon: IconButton(
                              icon: Icon(
                                obscureTextPass ? Icons.visibility_off : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscureTextPass = !obscureTextPass;
                                });
                              }),
                        ),
                      );
                    }),

                    // Confirm Password

                    StatefulBuilder(builder: (context, setState){

                      return TextFormField(
                        obscureText: obscureTextConfirmPass,
                        controller: confirmPassController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Iconsax.password_check),
                          labelText: "Confirm Password",
                          // suffixIcon: Icon(Iconsax.eye_slash)
                          suffixIcon: IconButton(
                              icon: Icon(
                                obscureTextConfirmPass ? Icons.visibility_off : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscureTextConfirmPass = !obscureTextConfirmPass;
                                });
                              }),
                        ),
                      );
                    }),

                    const SizedBox(height: 15),

                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(onPressed: () async {

                          String email = emailController.text.trim();
                          String password = passController.text.trim();
                          String confirmPassword = confirmPassController.text.trim();

                          if(password != confirmPassword){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password does not match.")));
                          }else if(email.isEmpty || password.isEmpty || confirmPassword.isEmpty){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter all fields.")));
                          }else{

                            try{
                              await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

                              // Create db entry in firebase
                              registerAccount(Account(userEmail: email, gender: 'NIL', imagePath: 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'), context);

                              // Move to home screen
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));

                            } on FirebaseAuthException catch(err){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${err.message}")));
                            } catch(err){
                              print(err);
                            }


                          }
                        },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green, // button background color
                                foregroundColor: Colors.white, // text & icon color
                                padding: EdgeInsets.symmetric(
                                  vertical: 12.0,
                                  horizontal: 24.0,
                                )
                            ), child: Text("Register")
                        )
                    ),


                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      child: const Text("Already have an account? Click here"),
                    ),

                  ],
                ),),

              ],
            )
        ),
      ),
    );
  }

  registerAccount(Account account, BuildContext context) async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection("Accounts").doc(DateTime.now().toString()).set(
      Account.toMap(account)
    ).then((value) => {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Successfully registered.")))
    });
  }



}
