import 'package:chatbot/chatdata/handle.dart';
import 'package:chatbot/screen/setting_screen.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class Conversation extends StatefulWidget {
  final String user_id;

  const Conversation({super.key, required this.user_id});

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {

  final TextEditingController topicController = TextEditingController();
  final List<ConversationMessage> _conversations = [];
  final date = DateFormat('dd-MM-yyyy  hh:mm:ss a').format(DateTime.now());

  confirmTopicDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nhập chủ đề cuộc trò chuyện'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: topicController,
                autofocus: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0, right: 100),
              child: ElevatedButton(
                onPressed: () {
                  ConversationMessage conversation = ConversationMessage(
                      date,
                      topicController.text
                  );
                  setState(() {
                    _conversations.insert(0, conversation);
                  });
                  topicController.clear();
                  Navigator.of(context).pop();
                },
                child: const Text('Xác nhận'),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget newConversationButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(200, 40),
        backgroundColor: Colors.lightBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        )
      ),
      child: const Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Text(
            "Tạo cuộc trò chuyện mới",
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
      ),
      onPressed: () async {
        confirmTopicDialog(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.black54),
        backgroundColor: const Color.fromRGBO(242, 248, 248, 1),
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage("assets/logochatbot.png"),
              backgroundColor: Colors.transparent,
            ),
            const Expanded (child: Text(
              'Cuộc trò chuyện',
              style: TextStyle(color: Colors.black54, fontSize: 18),
              textAlign: TextAlign.center,
            ))
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Setting()));
              },
              icon: const Icon(
                Icons.settings,
              ))
        ],
      ),
      body: Column(
        children: [
          Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemBuilder: (_, int index) => _conversations[index],
                itemCount: _conversations.length,
          )),
          newConversationButton(context),
          const SizedBox(height: 20,)
        ],
      ),
    );
  }
}

class ConversationMessage extends StatelessWidget {
  final String date;
  final String text;

  const ConversationMessage(this.date, this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        color: Color.fromRGBO(255, 211, 202, 1.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10, top: 10),
            child: ClipOval(
              child: SizedBox.fromSize(
                size: const Size(100, 100),
                child: Image.asset('assets/logochatbot.png'),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontSize: 18
                ),

              ),
              const SizedBox(height: 10,),
              Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2 + 40),
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 18),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}