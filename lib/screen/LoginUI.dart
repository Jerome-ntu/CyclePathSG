import 'package:cyclepathsg/register.dart';
import 'package:cyclepathsg/screen/app_main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cyclepathsg/common/styles/spacing_styles.dart';
import 'package:cyclepathsg/utils/image_strings.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:cyclepathsg/models/LoginCredentials.dart';

import '/utils/sizes.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  var emailController = TextEditingController();
  var passController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              // logo, title and sub-title
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    height: 350,
                    image: AssetImage(TImages.lightAppLogo),
                  ),
                ],
              ),

              Form(
                child: Column(
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
                      obscureText: _obscureText,
                      controller: passController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Iconsax.password_check),
                        labelText: "Password",
                        // suffixIcon: Icon(Iconsax.eye_slash)
                        suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            }),
                      ),
                    );
                  }),

                  const SizedBox(height: TSizes.spaceBtwInputFields / 2),

                  // Forget password
                  // TextButton(onPressed: () {}, child: const Text("Forget Password")),

                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(onPressed: () async {
                        String email = emailController.text.trim();
                        String password = passController.text.trim();

                        if(email.isEmpty || password.isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter all fields.")));
                        }else{
                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Register")));

                          try{
                            await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

                            // Shift to Main Screen, pass over email.text so Account Screen can access db to display parameters
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AppMainScreen(email: email)));

                          } on FirebaseAuthException catch(err){
                            if(err.code == 'user-not-found'){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Account not found.")));
                            }else if(err.code == "wrong-password"){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Incorrect password.")));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${err.message}")));
                            }

                          } catch(err) {
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
                          ), child: Text("Sign In")
                      )
                  ),

                  SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterPage()),
                        );
                      }, child: Text("Create Account"))
                  ),

                  const SizedBox(height: 15),
                ]),
              ),
            ],
          )
        ),
      ),
    );
  }
}
