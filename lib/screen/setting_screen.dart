
import 'package:chatbot/authentication/auth_page.dart';
import 'package:chatbot/screen/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<StatefulWidget> createState() {
    return _settingState();
  }
}

class _settingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    const storage = FlutterSecureStorage();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black54),
        backgroundColor: const Color.fromRGBO(242, 248, 248, 1),
        title: const Text('Cài đặt', style: TextStyle(color: Colors.black54, fontSize: 18),),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_horiz,
            ),
            onPressed: () {

            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    ClipOval(
                      child: SizedBox.fromSize(
                        size: const Size(200, 200),
                        child: Image.asset('assets/avthotay.png', fit: BoxFit.fitWidth,),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: const Icon(IconData(0xe0fa, fontFamily: 'MaterialIcons'), color: Colors.blueAccent,),
                    )
                  ]
              ),
              const SizedBox(height: 10,),
              const Text('Nguyễn Ngọc Quyết', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 10,),
              const Text('quyetprovjpno.1@gmail.com', style: TextStyle(fontSize: 15)),
              const SizedBox(height: 20,),
              const Divider(color: Colors.grey,),
              Expanded(
                child: ListView(
                  children: [
                    Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                          child: Icon(Icons.people_outline),
                        ),
                        Expanded(child: Text('Thông tin tài khoản')),
                        Icon(Icons.expand_circle_down_outlined)
                      ],
                    ),
                    Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                          child: Icon(Icons.lock_clock_outlined),
                        ),
                        Expanded(child: Text('Bảo mật')),
                        Icon(Icons.expand_circle_down_outlined)
                      ],
                    ),
                    Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                          child: Icon(Icons.remove_red_eye_rounded),
                        ),
                        Expanded(child: Text('Chế độ tối')),
                        Icon(Icons.expand_circle_down_outlined)
                      ],
                    ),
                    Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                          child: Icon(Icons.more_vert_outlined),
                        ),
                        Expanded(child: Text('Ngôn ngữ')),
                        Icon(Icons.expand_circle_down_outlined)
                      ],
                    ),
                    Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                          child: Icon(Icons.list_alt_rounded),
                        ),
                        Expanded(child: Text('Thống kê')),
                        Icon(Icons.expand_circle_down_outlined)
                      ],
                    ),
                    Row(
                      children: const [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                          child: Icon(Icons.warning_rounded),
                        ),
                        Expanded(child: Text('Trung tâm trợ giúp')),
                        Icon(Icons.expand_circle_down_outlined)
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Auth().signOut(context: context);
                  await storage.write(key: 'key_save_email', value: '');
                  await storage.write(key: 'key_save_password', value: '');
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                      child: Icon(Icons.logout_outlined),
                    ),
                    Text('Đăng xuất', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}