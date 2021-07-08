import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:money_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_app/home_page.dart';


class EntryPage extends StatefulWidget{
  @override 
  _EntryPageState createState() => _EntryPageState();

}

class _EntryPageState extends State<EntryPage> {

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
      home:Scaffold(
      appBar: AppBar(title: Text('The Secret Chatting App'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            //log in button, navigate to log in screen
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    signIn();
                  },
                  child: Text('Log In'),
                  style: ElevatedButton.styleFrom(primary: Colors.blue[600], fixedSize: Size(SizeConfig.blockSizeHorizontal * 25.0, SizeConfig.blockSizeVertical * 0.0))
                ),
              ]
            ),
          ]
        )
      )
    )
    );
  }

  //method to sign in through firebase auth
  Future<String?> signIn() async{
    try{
      await auth.signInAnonymously();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> HomePage()));
      return 'Signed In';
    } on FirebaseAuthException catch(e){
        return e.message;
    }
  }
}