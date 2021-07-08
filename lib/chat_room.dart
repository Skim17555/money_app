import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bubble/bubble.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:money_app/ad_helper.dart';

class ChatRoom extends StatelessWidget{

  //constructor for Chat room to pass in username and userID of person user is chatting with
  const ChatRoom({Key? key, required this.otherUser, required this.otherUserID}): super(key: key);
  final String otherUser, otherUserID;

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        //displays name of user the current user will be chatting with
        title: Text(otherUser),
        centerTitle: true,
      ), 
      //body consists of the ChatScreen class, containing list of messages and textbox
      //passes in user/contact info
      body: ChatScreen(otherUser: otherUser, otherUserID: otherUserID)
    );
  }
}

//chat screen holds widgets that return messages and provide input text field and send message button
class ChatScreen extends StatefulWidget{

  //chat screen constructor requires otherUser's username and their uid
  const ChatScreen({required this.otherUser, required this.otherUserID});
  final String otherUser, otherUserID;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>{

  //firebase instances
  final auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //class variables to store current user id, contact id, convoID and the message in string format
  late String currentUserID, otherUserID, convoID, message;

  //used to clear typed text inside text field widget
  final _messageHolder = TextEditingController();
  

  late RewardedAd _rewardedAd;

  bool _isRewardedAdReady = false;

  //initializes class variables from super class
  @override 
  void initState(){
    super.initState();
    currentUserID = auth.currentUser!.uid;
    convoID = getConvoID(currentUserID, widget.otherUserID);
    otherUserID = widget.otherUserID;

    //loads rewarded ad
    _loadRewardedAd();
  }

  @override
  Widget build (BuildContext context){
    return Container(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
                buildMessage(),
                buildInput()
            ]
          )
        ],
      )
    );
  }

//sends and posts message into firestore database
  void sendMessage(){
    //clears textfield box
    _messageHolder.clear();

    //adds message to database
    firestore.collection('messages').doc(convoID).collection(convoID).add({
        'date_time': DateTime.now(),
        'content': message,
        'id_from': currentUserID,
        'id_to': widget.otherUserID,
        'users': <String>[currentUserID, widget.otherUserID]                 
    }).then((value)=>print("Message sent")).catchError((error)=>print("Failed to send message:$error"));
  }

  String getConvoID(String userID, String otherUserID){
      //returns combination of both users as the convoID
      return userID.hashCode <= otherUserID.hashCode ? userID + '_' + otherUserID : otherUserID + '_' + userID;
  }

  //returns a list of all messages 
  Widget buildMessage(){
    return Flexible(
      child: StreamBuilder<QuerySnapshot>(
          stream: firestore.collection('messages').doc(convoID).collection(convoID).orderBy('date_time', descending: false).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else
            //maps document snapshot content from query snapshot
              return ListView(
                children: snapshot.data!.docs.map((doc) {
                  return buildItem(doc);
                }).toList(),
              );
          },
        ),
    );
  }

  //returns text input box and send message button
  Widget buildInput(){
    return Container(
      child:  Row(
        children: <Widget>[
          //start of textfield widget
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
              child: TextField(
               onChanged: (value){
                  setState((){
                    message = value.trim();
                  });
                },
                controller: _messageHolder,
                decoration: InputDecoration( 
                  filled: true,
                  labelText: 'Write a message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0)
                  )
                ),
              )
            )
          ),
          Container(
            child: ElevatedButton(
              child: Icon(Icons.send, color: Colors.white),
              style: ElevatedButton.styleFrom(shape: CircleBorder(), padding: EdgeInsets.all(10.0), primary: Colors.blue),
              onPressed:(){
                sendMessage();
                //shows rewarded ad when user sends message
                _rewardedAd.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) {  });
              }
            ) 
          )    
        ]
      ) 
    );
  }

  //builds chat bubble with child as text from messages
  Widget buildItem(QueryDocumentSnapshot listMessage) {
    return Row(
      children: <Widget>[
        // Text
        Container(
          padding: EdgeInsets.all(5.0),
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Bubble(
            padding: const BubbleEdges.all(10.0),
            elevation: 0,
            color: listMessage['id_from'] == currentUserID ? Colors.blue: Colors.grey[350],
            child: Text(listMessage['content'], style: listMessage['id_from'] == currentUserID ? TextStyle(color: Colors.white) : TextStyle(color: Colors.black))
          ),       
        )
      ],
      mainAxisAlignment:listMessage['id_from'] == currentUserID ? MainAxisAlignment.end : MainAxisAlignment.start,
    ); 
  }


  //method for loading the rewarded ad
  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          this._rewardedAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                _isRewardedAdReady = false;
              });
              _loadRewardedAd();
            },
          );

          setState(() {
            _isRewardedAdReady = true;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
          setState(() {
            _isRewardedAdReady = false;
          });
        },
      ),
    );
  }
}



