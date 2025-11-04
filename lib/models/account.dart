import 'location.dart';

class Account{
  String userEmail;
  String gender;
  String imagePath;
  // List<Location> savedLocations;

  // Contructor
  // Account(this.userEmail, this.gender, this.profileImage, this.savedLocations);
  // Account(this.userEmail, this.gender, this.imagePath);
  Account({required this.userEmail, required this.gender, required this.imagePath});

  static toMap (Account account){
    return{
      "userEmail": account.userEmail,
      "gender": account.gender,
      "imagePath": account.imagePath
    };
  }

  // factory Account.fromMap(Map<String, dynamic> map){
  //   return Account(map["userEmail"], map["gender"], map["imagePath"]);
  // }



    
}