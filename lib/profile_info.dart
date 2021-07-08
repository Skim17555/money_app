import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ProfileInfo extends StatefulWidget{
  //constructor takes in interstitial ad information
  const ProfileInfo({required this.interstitialAd, required this.isInterstitialAdReady});

  //class variables for interstitial ad 
  final InterstitialAd? interstitialAd;
  final bool? isInterstitialAdReady;

@override 
_ProfileInfoState createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo>{

  //firebase instances
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //for storing user's desired first/last name and username
  late String first_name, last_name, username;

  //class variables for interstitial ad
  late InterstitialAd? _interstitialAd;
  late bool? _isInterstitialAdReady;

  //initializes class variables from super class ProfileInfo
  @override 
  void initState(){
    super.initState();
    _interstitialAd = widget.interstitialAd;
    _isInterstitialAdReady = widget.isInterstitialAdReady;

    //if the ad is loaded, show the ad
    if (_isInterstitialAdReady !=null) {
      _interstitialAd?.show();
    } 
  }


  @override 
  Widget build (BuildContext context){
    return Scaffold(
        appBar: AppBar(
          //provides default string value if display name is null
          title: Text(auth.currentUser?.displayName.toString() ?? "null"),
          centerTitle: true
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 16, top: 25, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget> [
                Text("Edit Profile", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
                SizedBox(height: 15),
                //center widget profile picture 
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage('https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png')
                  )
                ),
                SizedBox(height: 15),
                //first name
                TextField(
                  onChanged: (value){
                    first_name = value.trim();
                  },
                  decoration: InputDecoration(
                    labelText: 'First Name',
                  )
                ),
                //last name
                TextField(
                  onChanged: (value){
                    last_name = value.trim();
                  },
                  decoration: InputDecoration(
                    labelText: 'Last Name'
                  )
                ),
                //user name
                TextField(
                  onChanged: (value){
                    username = value.trim();
                  },
                  decoration: InputDecoration(
                    labelText: 'User Name',
                    hintText: auth.currentUser?.displayName
                  )
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: (){
                    saveChanges(first_name, last_name, username);
                  },
                  child: Text("Save", style: TextStyle(fontSize: 15, color: Colors.white))
                )
              ]
            ),
          ),               
        ),       
      );  
  }
  Future<String?> saveChanges(String first_name, String last_name, String username) async{
    
    //updates current user's display name
    auth.currentUser?.updateDisplayName(username).then((_){
      print("Succesfully changed display name");
    }).catchError((error){
      print("Cannot be changed");
    });

    //adds user info to collection 'users' 
      CollectionReference users = firestore.collection('users');
      users.doc(auth.currentUser?.uid).set({
        'first_name': first_name,
        'last_name': last_name,
        'username': username,
        'user_id': auth.currentUser!.uid
      }).then((value)=>print("Changes made successfully")).catchError((error)=>print("Failed to make changes:$error"));
  }
}