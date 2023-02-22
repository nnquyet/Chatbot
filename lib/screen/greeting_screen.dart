import 'package:chatbot/screen/sign_in_screen.dart';
import 'package:flutter/material.dart';

class Greeting extends StatefulWidget {
  const Greeting({super.key});

  @override
  State<StatefulWidget> createState() => _GreetingState();
}

class _GreetingState extends State<Greeting>{
  bool checkContinue = false;
  int count = 0;
  final List<String> hello = [
    'Chào mừng bạn tới ChatBot, một người bạn tuyệt vời để trò chuyện với bạn',
    'Nếu bạn cần hỗ trợ bất kỳ điều gì, hãy mở ChatBot',
    'ChatBot sẽ luôn luôn hỗ trợ và khiến bạn trở lên vui vẻ'
  ];
  
  @override
  Widget build(BuildContext context) {
    final logo = Padding(
        padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
        child: Image.asset("assets/logochatbot.png"),
    );

    var greetingText = Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: Text(
        hello[count],
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
          wordSpacing: 10,
        ),
      ),
    );

    var continueButton = ElevatedButton(
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(
            fontSize: 20
          ),
          padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          )
        ),
        onPressed: () {
          if(count != 2) {
            setState(() {
              count++;
            });
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Login()));
            count = 0;
          }
        },
        child: count == 2 ? const Text("Bắt đầu") : const Text("Tiếp tục")
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          children: [
            const Spacer(),
            logo,
            const Spacer(),
            greetingText,
            const Spacer(flex: 5,),
            continueButton,
          ],
        ),
      ),
    );
  }
}