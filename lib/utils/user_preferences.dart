import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/account.dart';

class UserPreferences{

  // static Account myUser = Account(
  //   userEmail: 'soup@fish.com',
  //   gender: 'Male',
  //   imagePath: 'https://cdn.britannica.com/34/240534-050-B8C4B11E/Porcupine-fish-Diodon-hystox.jpg'
  // );
  static Account? myUser;

  static getAccountDetails(String email) async {

    try{
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("Accounts")
          .where("userEmail", isEqualTo: email)
          .limit(1)
          .get();

      if(snapshot.docs.isNotEmpty){
        var accData = snapshot.docs.first.data() as Map<String, dynamic>;
        // debugPrint("FISH $accData");

        myUser = Account(
          userEmail: accData['userEmail'] ?? '',
          gender: accData['gender'] ?? '',
          imagePath: accData['profileImage'] ??
              'https://cdn-icons-png.flaticon.com/512/3135/3135715.png', // in case unable to retrieve
        );
      }else {
        debugPrint("No account found for email: $email");
      }
    }catch(err){
      debugPrint("Error fetching account details: $err");
    }

  }
}