import 'package:chatt_app/helper/authenticate.dart';
import 'package:chatt_app/helper/constants.dart';
import 'package:chatt_app/helper/helperfunctions.dart';
import 'package:chatt_app/helper/theme.dart';
import 'package:chatt_app/services/auth.dart';
import 'package:chatt_app/services/database.dart';
import 'package:chatt_app/views/chat.dart';
import 'package:chatt_app/views/search.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream chatRooms;

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    userName: snapshot.data.documents[index].data['chatRoomId']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    chatRoomId:
                        snapshot.data.documents[index].data["chatRoomId"],
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    DatabaseMethods().getUserChats(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo5.png",
          height: 40,
        ),
        elevation: 0.0,
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () {
              AuthService().signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.account_circle)),
          )
        ],
      ),
      body: Container(
        child: chatRoomsList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Search()));
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({this.userName, @required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(
                      chatRoomId: chatRoomId,
                    )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 3, vertical: 8),
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Colors.deepPurple[50],
          // borderRadius: BorderRadius.all(Radius.circular(18.0)),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  // gradient: LinearGradient(
                  //   colors: [const Color(0xFFFFFF00), const Color(0xFF81D4FA)],
                  // ),
                  color: Colors.pink[100],
                  borderRadius: BorderRadius.circular(30)),
              child: Align(
                alignment: Alignment.center,
                child: Text(userName.substring(0, 1),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'OverpassRegular',
                        fontWeight: FontWeight.w500)),
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w500)),
            Spacer(),
            RaisedButton.icon(
              onPressed: () {
                print('Button Clicked.');
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(50.0),
                ),
              ),
              label: Text(
                'Map',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w800),
              ),
              padding: EdgeInsets.only(
                right: 10,
              ),
              icon: Icon(
                Icons.location_on,
                color: Colors.black,
              ),
              textColor: Colors.white,
              splashColor: Colors.black,
              color: Colors.yellow[100],
            ),
          ],
        ),
      ),
    );
  }
}
