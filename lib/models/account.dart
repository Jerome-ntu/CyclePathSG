import 'location.dart';

class Account{
  String userEmail;
  String gender;
  String profileImage;
  // List<Location> savedLocations;

  // Contructor
  // Account(this.userEmail, this.gender, this.profileImage, this.savedLocations);
  // Account(this.userEmail, this.gender, this.imagePath);
  Account({required this.userEmail, required this.gender, required this.profileImage});

  static toMap (Account account){
    return{
      "userEmail": account.userEmail,
      "gender": account.gender,
      "profileImage": account.profileImage
    };
  }

  // factory Account.fromMap(Map<String, dynamic> map){
  //   return Account(map["userEmail"], map["gender"], map["imagePath"]);
  // }



    
}