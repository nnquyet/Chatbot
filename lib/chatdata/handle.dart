import 'package:intl/intl.dart';

import 'package:chatbot/screen/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Handle {
  int countWrite = 1;
  int countRead = 1;
  List<int> _list = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  Future<void> addData(String user_id, String section, String user_chat, String bot_chat) async {
    DocumentReference datas = FirebaseFirestore.instance.collection(user_id).doc(section);
    final dataSnapshot = await datas.get();
    final data = dataSnapshot.data();
    countWrite = dataSnapshot.exists? (data as Map)['count'] + 1 : 1;
    if (countWrite == 11) countWrite = 1;

    if (dataSnapshot.exists) {
      await datas.update({
        '${countWrite}user': user_chat,
        '${countWrite}bot': bot_chat,
        'count': countWrite,
      });
    } else {
      await datas.set({
        '${countWrite}user': user_chat,
        '${countWrite}bot': bot_chat,
        'count': countWrite,
      });
    }
  }

  Future<List<ChatMessage>> readData(String user_id, String section) async {
    DocumentReference datas = FirebaseFirestore.instance.collection(user_id).doc(section);

    List<ChatMessage> chatMessageReturn = [];

    final snapshot = await datas.get();
    if (snapshot.exists) {
      final data = snapshot.data();
      countRead = (data as Map)['count'] + 1;
      if (countRead == 11) countRead = 1;
      while (_list.isNotEmpty) {
        // print('user: ${(data as Map)['${countRead}user']}');
        // print('bot: ${(data as Map)['${countRead}bot']}');

        ChatMessage chatMessage = ChatMessage(
          text: (data as Map)['${countRead}user'],
          isUser: true,
        );
        
        ChatMessage chatMessageBot = ChatMessage(
          text: (data as Map)['${countRead}bot'],
          isUser: false,
        );
        
        if(chatMessage.text != null) {
          chatMessageReturn.insert(0, chatMessage);
          chatMessageReturn.insert(0, chatMessageBot);
        }

        countRead++;
        if (countRead == 11) countRead = 1;
        _list.remove(countRead);
        // print(_list);
      }
    }

    return chatMessageReturn;
  }

  String handleUserInput(String user_input) {
    if (user_input.toLowerCase().contains("xin chào")) {
      return("Xin chào! Tôi là chatbot, bạn cần tôi giúp gì?");
    } else if (user_input.toLowerCase().contains("tạm biệt")) {
      return("Tạm biệt! Hãy quay lại nếu bạn cần sự trợ giúp của tôi.");
    } else if (user_input.toLowerCase().contains("cảm ơn")) {
      return("Không có gì! Hãy nói với tôi nếu bạn cần sự trợ giúp.");
    } else if (user_input.toLowerCase().contains("hôm nay là ngày mấy")) {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('dd/MM/yyyy').format(now);
      return("Hôm nay là ngày $formattedDate.");
    } else if (user_input.toLowerCase().contains("tính tổng")) {
      List<String> words = user_input.split(' ');
      if (words.length <= 3) {
        return("Vui lòng nhập đúng cú pháp. Ví dụ: 'Tính tổng 2 và 3'.");
      } else {
        try {
          int num1 = int.parse(words[2]);
          int num2 = int.parse(words[4]);
          int sum = num1 + num2;
          return("Tổng của $num1 và $num2 là $sum.");
        } catch (FormatException) {
          return("Vui lòng nhập đúng cú pháp. Ví dụ: 'Tính tổng 2 và 3'.");
        }
      }
    } else if (user_input.toLowerCase().contains("tính hiệu")) {
      List<String> words = user_input.split(' ');
      if (words.length <= 3) {
        return("Vui lòng nhập đúng cú pháp. Ví dụ: 'Tính hiệu 5 trừ đi 3'.");
      } else {
        try {
          int num1 = int.parse(words[2]);
          int num2 = int.parse(words[4]);
          int diff = num1 - num2;
          return("Hiệu của $num1 trừ đi $num2 là $diff.");
        } catch (FormatException) {
          return("Vui lòng nhập đúng cú pháp. Ví dụ: 'Tính hiệu 5 trừ đi 3'.");
        }
      }
    } else if (user_input.toLowerCase().contains("tính tích")) {
      List<String> words = user_input.split(' ');
      if (words.length <= 3) {
        return ("Vui lòng nhập đúng cú pháp. Ví dụ: 'Tính tích 2 và 3'.");
      } else {
        try {
          int num1 = int.parse(words[2]);
          int num2 = int.parse(words[4]);
          int product = num1 * num2;
          return ("Tích của $num1 và $num2 là $product.");
        } catch (FormatException) {
          return("Vui lòng nhập đúng cú pháp. Ví dụ: 'Tính tích 5 nhân 3'.");
        }
      }
    } else if (user_input.toLowerCase().contains("đổi mật khẩu")) {
      return("Để đổi mật khẩu, vui lòng truy cập trang đổi mật khẩu trên ứng dụng của chúng tôi.");
    } else if (user_input.toLowerCase().contains("cập nhật thông tin")) {
      return("Để cập nhật thông tin, vui lòng truy cập trang cập nhật thông tin trên ứng dụng của chúng tôi.");
    } else if (user_input.toLowerCase().contains("tìm kiếm")) {
      List<String> words = user_input.split(' ');
      if (words.length <= 2) {
        return("Vui lòng nhập từ khóa tìm kiếm. Ví dụ: 'Tìm kiếm sản phẩm A'.");
      } else {
        String keyword = user_input.substring(18).trim();
        return("Đang tìm kiếm với từ khóa: $keyword");
      }
    } else if (user_input.toLowerCase().contains("đặt hàng")) {
      List<String> words = user_input.split(' ');
      if (words.length <= 2) {
        return("Vui lòng nhập thông tin đặt hàng. Ví dụ: 'Đặt hàng sản phẩm A số lượng 2'.");
      } else {
        try {
          String product = words[2];
          int quantity = int.parse(words[4]);
          return("Đã đặt hàng $quantity $product.");
        } catch (FormatException) {
          return("Vui lòng nhập đúng cú pháp. Ví dụ: 'Đặt hàng sản phẩm A số lượng 2'.");
        }
      }
    } else if (user_input.toLowerCase().contains("hướng dẫn sử dụng")) {
      return("Vui lòng truy cập trang hướng dẫn sử dụng trên ứng dụng của chúng tôi để biết thêm chi tiết.");
    } else if (user_input.toLowerCase().contains("đánh giá sản phẩm")) {
      List<String> words = user_input.split(' ');
      if (words.length <= 2) {
        return("Vui lòng nhập tên sản phẩm để đánh giá. Ví dụ: 'Đánh giá sản phẩm A'.");
      } else {
        String product = user_input.substring(17).trim();
        return("Vui lòng truy cập trang đánh giá sản phẩm $product trên ứng dụng của chúng tôi.");
      }
    } else if (user_input.toLowerCase().contains("thông tin sản phẩm")) {
      List<String> words = user_input.split(' ');
      if (words.length <= 2) {
        return("Vui lòng nhập tên sản phẩm để xem thông tin chi tiết. Ví dụ: 'Thông tin sản phẩm A'.");
      } else {
        String product = user_input.substring(19).trim();
        return("Đang tìm kiếm thông tin sản phẩm $product.");
      }
    }
    else {
      return("Xin lỗi, tôi không hiểu câu hỏi của bạn. Hãy thử lại với câu hỏi khác.");
    }
  }
}