
import 'dart:async';
import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatbot/ThreeDots.dart';
import 'package:chatbot/api_services.dart';
import 'package:chatbot/chatdata/handle.dart';
import 'package:chatbot/screen/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:text_to_speech/text_to_speech.dart';

class Chat extends StatefulWidget {
  final String title;
  final String user_id;
  const Chat({Key? key, required this.title, required this.user_id}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _textEditingController =
      TextEditingController();
  final List<ChatMessage> _messages = [];
  final _handle = Handle();

  bool backButtonPressedCount = false;
  bool checkSetState = true;

  late SpeechToText _speechToText;
  TextToSpeech _textToSpeech = TextToSpeech();
  bool _isListening = false;
  String? _textSpeech;
  bool _checkPop = false;

  void initState() {
    super.initState();
    _speechToText = SpeechToText();
    _textToSpeech.setLanguage('vi-VN');
  }

  // Future<bool> _onWillPop() async {
  //   return (await showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text('Bạn có chắc chắn muốn thoát khỏi ứng dụng không?'),
  //       actions: <Widget>[
  //         ElevatedButton(
  //           onPressed: () => Navigator.of(context).pop(false),
  //           child: Text('Không'),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             exit(0);
  //           },
  //           child: Text('Có'),
  //         ),
  //       ],
  //     ),
  //   )) ?? false;
  // }

  Future<bool> _onWillPop() async {
    if (backButtonPressedCount == true) {
      exit(0);
    } else {
      // Nếu đây là lần đầu tiên người dùng bấm nút quay trở lại,
      // họ sẽ được thông báo rằng họ cần bấm nút quay trở lại lần nữa để thoát ứng dụng.
      backButtonPressedCount = true;

      Fluttertoast.showToast(
        msg: " Chạm lần nữa để thoát ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromRGBO(1, 1, 1, 0.7),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Timer(const Duration(seconds: 2), () => backButtonPressedCount = false);
      return false;
    }
  }

  Future<void> waitData() async {
    List<ChatMessage> _messages2 = await _handle.readData(widget.user_id);
    await Future.delayed(const Duration(seconds: 1), () {
      _messages.addAll(_messages2);
    });
    setState(() {
      checkSetState = false;
    });
  }


  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () {
          _textEditingController.text = _textSpeech!;
          setState(() {
            _checkPop = true;
            _isListening = false;
            _speechToText.stop();
          });
        },
        child: WillPopScope(
          onWillPop: () async {
            _textEditingController.text = _textSpeech!;
            setState(() {
              _checkPop = true;
              _isListening = false;
              _speechToText.stop();
            });
            return true;
          },
          child: AlertDialog(
            title: const Text(
              'Hãy nói gì đó',
              textAlign: TextAlign.center,
            ),
            content: AvatarGlow(
              glowColor: Colors.blue,
              endRadius: 90.0,
              duration: const Duration(milliseconds: 2000),
              repeat: true,
              showTwoGlows: true,
              repeatPauseDuration: const Duration(milliseconds: 100),
              child: Material(     // Replace this child with your own
                elevation: 8.0,
                shape: const CircleBorder(),
                child: CircleAvatar(
                  child: Container(
                    width: 500,
                    height: 500,
                    child: IconButton(
                      icon: const Icon(Icons.mic),
                      color: Theme.of(context).colorScheme.secondary,
                      onPressed: () {
                        Navigator.of(context).pop();
                        _textEditingController.text = _textSpeech!;
                        setState(() {
                          _checkPop = true;
                          _isListening = false;
                          _speechToText.stop();
                        });
                      },
                    ),
                  ),
                  radius: 40.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(checkSetState) {
      waitData();
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
              Expanded (child: Text(
                widget.title,
                style: const TextStyle(color: Colors.black54, fontSize: 18),
                textAlign: TextAlign.center,
              )),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.settings,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Setting()));
              },
            )
          ],
        ),
        body: Stack(
          children: [
            checkSetState
                ? const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
            ),
                )
                : const Center(
              child: null,
            ),
            Column(
              children: [
                Flexible(
                    child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  reverse: true,
                  itemBuilder: (_, int index) => _messages[index],
                  itemCount: _messages.length,
                )),
                if (_messages.isEmpty != true && _messages.first.isUser == true) const ThreeDots(),
                _buildTextComposer()
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: const Color.fromRGBO(242, 248, 248, 1),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 4),
                  child: IconButton(
                    icon: const Icon(Icons.mic_none),
                    onPressed: () async {
                      _showDialog(context);
                      if (!_isListening) {
                        bool available = await _speechToText.initialize(
                          onStatus: (result) {
                            print('onStatus: $result');
                            if (result == 'notListening' && _checkPop == false) {
                              Navigator.of(context).pop();
                              print("poppop");
                              _textEditingController.text = _textSpeech!;
                              setState(() {
                                _isListening = false;
                                _speechToText.stop();
                              });
                            }
                          },
                          onError: (result) => print('onError: $result'),
                        );
                        if (available) {
                          setState(() {
                            _checkPop = false;
                            _isListening = true;
                          });
                          _speechToText.listen(
                              listenMode: ListenMode.confirmation,
                              onResult: (result) => setState(() {
                                _textSpeech = result.recognizedWords;
                              })
                          );
                        }
                      }
                    },
                  ),
                ),
                Flexible(
                    child: TextField(
                      style: const TextStyle(fontSize: 18),
                      controller: _textEditingController,
                  onSubmitted: _handleSubmitted,
                  decoration:
                      const InputDecoration.collapsed(hintText: "Send a message"),
                )),
                Container(
                  margin: const EdgeInsets.only(left: 4),
                  child: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if(_textEditingController.text != "") {
                         _handleSubmitted(_textEditingController.text);
                         _textSpeech = '';
                      }
                    }
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> _handleSubmitted(String text) async {
    _textEditingController.clear();
    ChatMessage chatMessage = ChatMessage(
      text: text,
      isUser: true,
    );
    setState(() {
      _messages.insert(0, chatMessage);
    });

    String msg = await ApiServices.sendMessage(text);
    String msg1 = msg.replaceFirst("\n", "");
    String msg2 = msg1.replaceFirst("\n", "");

    if(msg2 == '') {
      msg2 = _handle.handleUserInput(chatMessage.text);
    }
    // 'This is a reply from the chatbot.
    ChatMessage reply = ChatMessage(
      text: msg2,
      isUser: false,
    );

    setState(() {
      _messages.insert(0, reply);
      _textToSpeech.speak(reply.text);
      _handle.addData(widget.user_id, chatMessage.text, reply.text);
    });
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    if (isUser) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Ngọc Quyết",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      color: Color.fromRGBO(255, 153, 141, 1.0)),
                  constraints: const BoxConstraints(maxWidth: 250),
                  margin: const EdgeInsets.only(top: 5),
                  child: Text(
                    text,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 16),
              child: const CircleAvatar(
                child: Text("Q"),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16, top: 10),
              child: const CircleAvatar(
                backgroundImage: AssetImage("assets/logochatbot.png"),
                backgroundColor: Colors.transparent,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Mimi",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    color: Color.fromRGBO(255, 211, 202, 1.0),
                  ),
                  constraints: const BoxConstraints(maxWidth: 250),
                  margin: const EdgeInsets.only(top: 5),
                  child: Text(text,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 16,
                      )),
                )
              ],
            )
          ],
        ),
      );
    }
  }
}
