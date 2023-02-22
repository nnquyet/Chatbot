import 'package:chatbot/screen/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:chatbot/screen/chat_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../authentication/auth_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final storage = const FlutterSecureStorage();
  var save = true;

  Future<void> readEmailAndPassword() async {
    String? usernameValue = await storage.read(key: 'key_save_email');
    String? passwordValue = await storage.read(key: 'key_save_password');
    emailController.text = usernameValue!;
    passController.text = passwordValue!;
  }

  Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      String? user_id = Auth().firebaseAuth.currentUser?.uid;

      // Chuyển hướng sang màn hình Chat_Screen
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Chat(
              title: 'Chatbot Mimi',
              user_id: user_id ?? '',
            )),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8.0),
                Text(
                  'Không tìm thấy người dùng với địa chỉ email này.',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8.0),
                Text(
                  'Địa chỉ email không hợp lệ.',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8.0),
                Text(
                  'Mật khẩu không đúng.',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void checkLogin() {
    if (emailController.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8.0),
              Text(
                'Vui lòng nhập email.',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    } else if (passController.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8.0),
              Text(
                'Vui lòng nhập mật khẩu.',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (save) {
      readEmailAndPassword();
      save = false;
    }

    final logo = ClipOval(
      child: SizedBox.fromSize(
        size: Size(200, 200),
        child: Image.asset('assets/logochatbot.png'),
      ),
    );

    final email = TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
          hintText: "Email",
          contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32))),
    );

    final password = TextFormField(
      controller: passController,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
          hintText: 'Mật khẩu',
          contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32))),
    );

    final forgotPass = TextButton(
        onPressed: () {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Lấy lại mật khẩu")));
        },
        child: const Text(
          "Quên mật khẩu",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.cyan,
          ),
        ));

    final loginButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(200, 40),
          backgroundColor: Colors.lightBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )),
      child: const Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Text(
          "Đăng nhập",
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
      onPressed: () async {
        try {
          // Code có thể gây ra lỗi liên quan đến nền tảng
          // Ví dụ: kết nối mạng, lỗi xử lý hình ảnh, v.v.
        } on PlatformException catch (e) {
          // Xử lý lỗi
          if (e.code == 'network_error') {
            // Hiển thị thông báo cho người dùng
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Không có kết nối mạng.'),
              ),
            );
          }
        }
        checkLogin();
        await storage.write(key: "key_save_email", value: emailController.text);
        await storage.write(key: "key_save_password", value: passController.text);
        signInWithEmailAndPassword(
            context, emailController.text, passController.text);
      },
    );

    final loginFacebook = Padding(
      padding: const EdgeInsets.only(right: 15, left: 10),
      child: InkWell(
        child: ClipOval(
          child: SizedBox.fromSize(
              size: const Size(40, 40),
              child: Image.asset(
                'assets/facebook.png',
                fit: BoxFit.fill,
              )),
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Tiếp tục với Facebook")));
        },
      ),
    );

    final loginGoogle = InkWell(
      child: ClipOval(
        child: SizedBox.fromSize(
            size: const Size(42, 42),
            child: Image.asset(
              'assets/google.png',
              fit: BoxFit.fill,
            )),
      ),
      onTap: () {
        Auth().signInWithGoogle(context: context);
      },
    );

    final loginGithub = InkWell(
      child: ClipOval(
        child: SizedBox.fromSize(
          size: Size(52, 52),
          child: Image.asset(
            "assets/github.png",
            fit: BoxFit.fill,
          ),
        ),
      ),
      onTap: () {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Tiếp tục với Github")));
      },
    );

    final signUp = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Chưa có tài khoản?",
          style: TextStyle(),
        ),
        TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
            },
            child: Text(
              "Đăng ký",
              style: TextStyle(
                color: Colors.cyan,
              ),
            ))
      ],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                logo,
                const SizedBox(
                  height: 45,
                ),
                email,
                const SizedBox(
                  height: 10,
                ),
                password,
                const SizedBox(
                  height: 15,
                ),
                forgotPass,
                const SizedBox(
                  height: 25,
                ),
                loginButton,
                const SizedBox(
                  height: 40,
                ),
                const Text('Hoặc tiếp tục với'),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [loginFacebook, loginGoogle, loginGithub],
                ),
                const SizedBox(
                  height: 25,
                ),
                signUp
              ],
            ),
          ),
        ),
      ),
    );
  }
}
