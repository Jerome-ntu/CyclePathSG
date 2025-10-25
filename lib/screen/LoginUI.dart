import 'package:flutter/material.dart';
import 'package:cyclepathsg/common/styles/spacing_styles.dart';
import 'package:cyclepathsg/utils/image_strings.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:cyclepathsg/models/LoginCredentials.dart';

import '/utils/sizes.dart';

class LoginUI extends StatelessWidget {
  const LoginUI({super.key});


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

              Form(child: Column(
                children: [
                  // email
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Iconsax.direct_right),
                      labelText: "E-mail"
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields),

                  // Password
                  TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Iconsax.password_check),
                        labelText: "Password",
                        suffixIcon: Icon(Iconsax.eye_slash)
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwInputFields / 2),

                  // Forget password
                  TextButton(onPressed: () {}, child: const Text("Forget Password")),

                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(onPressed: () {}, child: Text("Sign In"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green, // button background color
                              foregroundColor: Colors.white, // text & icon color
                              padding: EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 24.0,
                              )
                          )
                      )
                  ),

                  SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(onPressed: () {}, child: Text("Create Account"))
                  ),
                  const SizedBox(height: 15),
                ],
              ),),
              // Divider
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: Divider(color: Colors.grey, thickness: 0.5, indent: 60, endIndent: 5)),
                  Text("or sign in with...", style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.grey, // set your desired color
                  )),
                  Flexible(child: Divider(color: Colors.grey, thickness: 0.5, indent: 5, endIndent: 60)),
                ],
              ),
              const SizedBox(height: 15),

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(100)),
                    child: IconButton(
                        onPressed: () {},
                        icon: const Image(
                          width: TSizes.iconMd,
                          height:  TSizes.iconMd,
                          image: AssetImage(TImages.google)
                        )),
                  ),

                  const SizedBox(width: TSizes.spaceBtwItems),
                  Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(100)),
                    child: IconButton(
                        onPressed: () {},
                        icon: const Image(
                            width: TSizes.iconMd,
                            height:  TSizes.iconMd,
                            image: AssetImage(TImages.facebook)
                        )),
                  )
                ],
              )
            ],
          )
        ),
      ),
    );
  }
}
