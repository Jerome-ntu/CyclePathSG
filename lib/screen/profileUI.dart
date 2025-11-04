import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclepathsg/lib/screen/LoginUI.dart';
import 'package:cyclepathsg/models/account.dart';
import 'package:cyclepathsg/screen/editProfileUI.dart';
import 'package:cyclepathsg/utils/user_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'LoginUI.dart';

class ProfilePage extends StatefulWidget {
  String email;

  ProfilePage({super.key, required this.email});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {
  late Future<void> _loadUser;

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
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error loading account info"));
        }

        final user = UserPreferences.myUser!;

        return Column(
          children: [
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(height: 48),
                  ProfileWidget(
                    user: user,
                    onClicked: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(email: user.userEmail),
                        ),
                      );
                      setState(() {
                        _loadUser = UserPreferences.getAccountDetails(widget.email);
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Account Information",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),

                        Center(
                          child: Container(
                            width: 180,
                            height: 2,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Email Card
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 3,
                          shadowColor: Colors.grey.withOpacity(0.2),
                          child: ListTile(
                            leading: const Icon(Icons.email, color: Colors.blueAccent),
                            title: const Text("Email"),
                            subtitle: Text(
                              user.userEmail,
                              style: const TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Gender Card
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 3,
                          shadowColor: Colors.grey.withOpacity(0.2),
                          child: ListTile(
                            leading: const Icon(Icons.person, color: Colors.pinkAccent),
                            title: const Text("Gender"),
                            subtitle: Text(
                              user.gender ?? "Not specified",
                              style: const TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // TODO: Navigate to Saved Locations page
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 40.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 5,
                            ),
                            icon: const Icon(Icons.location_on, size: 26),
                            label: const Text(
                              "Saved Locations",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signOut();

                      // After signing out, navigate to the login screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    } catch (e) {
                      // Show error if something goes wrong
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error signing out: $e")),
                      );
                    }

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  child: const Text("Log Out"),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

}


class ProfileWidget extends StatelessWidget {
  final Account user;
  final bool isEdit;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
    required this.user,
    required this.onClicked,
    this.isEdit = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;
    debugPrint('FISHERasd $user.imagePath');

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glowing circular background
          Container(
            width: 142,
            height: 142,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  primary.withOpacity(0.25),
                  Colors.transparent,
                ],
                radius: 0.85,
              ),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.15),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),

          // Profile image
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: primary.withOpacity(0.7),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),


            child: ClipOval(
              child: Material(
                color: Colors.transparent,
                child: Ink.image(

                  image: NetworkImage(user.imagePath),
                  fit: BoxFit.cover,
                  width: 128,
                  height: 128,
                  child: InkWell(
                      onTap: onClicked,
                  ),
                ),
              ),
            ),
          ),

          // Edit icon
          Positioned(
            bottom: 0,
            right: 6,
            child: _buildEditIcon(primary),
          ),
        ],
      ),
    );
  }

  Widget _buildEditIcon(Color color) => _buildCircle(
    color: Colors.white,
    all: 3,
    child: _buildCircle(
      color: color,
      all: 8,
      child: Icon(
        isEdit ? Icons.add_a_photo : Icons.edit,
        color: Colors.white,
        size: 20,
      ),
    ),
  );

  Widget _buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
