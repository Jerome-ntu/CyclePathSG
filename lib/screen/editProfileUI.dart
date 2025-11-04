import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclepathsg/screen/profileUI.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/user_preferences.dart';
import '../utils/textfield_widget.dart';

class EditProfilePage extends StatefulWidget {
  String email;

  EditProfilePage({super.key, required this.email});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();

}

class _EditProfilePageState extends State<EditProfilePage>{
  late Future<void> _loadUser;

  // Textfield values through TextFieldWidget
  String updatedEmail = '';
  String updatedGender = '';
  String updatedImagePath = '';

  // State variables
  bool changePassword = false; // tracks whether user wants to change password
  String newPassword = '';     // stores the new password

  @override
  void initState() {
    super.initState();
    _loadUser = UserPreferences.getAccountDetails(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: _loadUser,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading indicator while fetching
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading account info"));
          }

          // Load user data after
          final user = UserPreferences.myUser!;

          // Store textfield data
          updatedEmail = updatedEmail.isEmpty ? user.userEmail : updatedEmail;
          updatedGender = updatedGender.isEmpty ? user.gender : updatedGender;
          updatedImagePath = updatedImagePath.isEmpty ? user.profileImage : updatedImagePath;

          return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
                  onPressed: ()  => Navigator.pop(context)
                ),

                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text(
                  "Edit Profile",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
              ),

            body:ListView(
              padding: EdgeInsets.symmetric(horizontal: 32),
              physics: BouncingScrollPhysics(),
              children: [

                const SizedBox(height: 24),

                ProfileWidget(
                  user: user,
                  isEdit: true,
                  onClicked: () async{},

                ),

                const SizedBox(height: 24),

                TextFieldWidget(
                  label: "Email",
                  text: user.userEmail,
                  isEditable: false,
                  onChanged: (value) => updatedEmail = value,
                ),

                // const SizedBox(height: 24),

                // TextFieldWidget(
                //   label: "Gender",
                //   text: user.gender,
                //   onChanged: (value) => updatedGender = value,
                // ),

                const SizedBox(height: 24),

                Text(
                  "Gender",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget> [
                    Expanded(
                        child: RadioListTile<String>(
                            title: const Text("Male"),
                            value: "Male",
                            groupValue: updatedGender,
                          onChanged: (String? value){
                            setState(() {
                              updatedGender = value!;
                              debugPrint("GEND_UP $updatedGender");
                            });
                          },
                        )
                    ),
                    Expanded(
                        child: RadioListTile<String>(
                          title: const Text("Female"),
                          value: "Female",
                          groupValue: updatedGender,
                          onChanged: (String? value){
                            setState(() {
                              updatedGender = value!;
                              debugPrint("GEND_UP $updatedGender");
                            });
                          },
                        )
                    )
                  ],
                ),

                const SizedBox(height: 24),

                TextFieldWidget(
                  label: "Image Path",
                  text: user.profileImage,
                  onChanged: (value) => updatedImagePath = value,
                ),

                // Switch to enable password change
                SwitchListTile(
                  title: const Text("Change Password?"),
                  value: changePassword,
                  activeColor: Colors.green,
                  onChanged: (bool value) {
                    setState(() {
                      changePassword = value;
                      if (!changePassword) newPassword = ''; // clear password if switch off
                    });
                  },
                ),


                if (changePassword)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: TextFieldWidget(
                      label: "New Password",
                      text: newPassword,
                      isPassword: true,
                      onChanged: (value) => newPassword = value,
                    ),
                  ),

                const SizedBox(height: 24),

                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(onPressed: () async {
                      debugPrint("SOUPER $updatedEmail, $updatedGender, $updatedImagePath");

                      if(changePassword && newPassword.isNotEmpty){
                        User? firebaseUser = FirebaseAuth.instance.currentUser;

                        if (firebaseUser != null) {
                          await firebaseUser.updatePassword(newPassword);
                          debugPrint("Password updated successfully.");
                        }
                      }

                      await findAndUpdateDocument(
                        'Accounts',
                        'userEmail',
                        user.userEmail,
                        {'gender': updatedGender, 'profileImage': updatedImagePath
                        });
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ProfilePage(email: user.userEmail)));
                      Navigator.pop(context);

                    },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green, // button background color
                            foregroundColor: Colors.white, // text & icon color
                            padding: EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 24.0,
                            )
                        ),
                        child: Text("Save")
                    )
                ),

              ],
            )
          );
        }
    );
  }
}

Future<void> findAndUpdateDocument(String collectionName, String fieldName, dynamic fieldValue, Map<String, dynamic> newData) async {
  try {
    CollectionReference collectionRef = FirebaseFirestore.instance.collection(collectionName);

    QuerySnapshot querySnapshot = await collectionRef.where(fieldName, isEqualTo: fieldValue).get();

    if (querySnapshot.docs.isNotEmpty) {
      // Iterate through the documents found (if multiple match the query)
      for (DocumentSnapshot document in querySnapshot.docs) {
        // Get the document reference
        DocumentReference docRef = document.reference;

        // Update the document
        await docRef.update(newData);
        print('Document with ID ${document.id} updated successfully.');
      }
    } else {
      print('No document found matching the criteria.');
    }
  } catch (e) {
    print('Error finding and updating document: $e');
  }
}



