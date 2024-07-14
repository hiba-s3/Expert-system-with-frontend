// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ApiService {
//   final String baseUrl;
//   final String token;

//   ApiService({required this.baseUrl, required this.token});

//   Future<Map<String, dynamic>> createChat(String chatTitle) async {
//     final url = Uri.parse('$baseUrl/api/chat');
//     final headers = {
//       'Authorization': 'Bearer $token',
//       'Content-Type': 'application/json',
//     };
//     final body = json.encode({'chatTitle': chatTitle});

//     final response = await http.post(url, headers: headers, body: body);

//     if (response.statusCode == 200) {
//       print(json.decode(response.body));
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to create chat');
//     }
//   }

//   fetchChats() async {
//     final url = Uri.parse('$baseUrl/api/chat');
//     final headers = {
//       'Authorization': 'Bearer $token',
//     };

//     final response = await http.get(url, headers: headers);

//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       //throw Exception('Failed to fetch chats');
//       createChat('');
//     }
//   }

//   Future<List<dynamic>> fetchChatMessages(int chatId) async {
//     final url = Uri.parse('$baseUrl/api/chat/$chatId');
//     final headers = {
//       'Authorization': 'Bearer $token',
//     };

//     final response = await http.get(url, headers: headers);

//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to fetch chat messages');
//     }
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl;
  final String token;

  ApiService({required this.baseUrl, required this.token});

  Future<Map<String, dynamic>> createChat(String chatTitle) async {
    final url = Uri.parse('$baseUrl/api/chat');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final body = json.encode({'chatTitle': chatTitle});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create chat');
    }
  }

  Future<Map<String, dynamic>> fetchChats() async {
    final url = Uri.parse('$baseUrl/api/chat');
    final headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch chats');
    }
  }

//   Future<List<dynamic>> fetchChatMessages(int chatId) async {
//     final url = Uri.parse('$baseUrl/api/chat/$chatId');
//     final headers = {
//       'Authorization': 'Bearer $token',
//     };

//     final response = await http.get(url, headers: headers);

//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to fetch chat messages');
//     }
//   }
// }
  Future<List<Map<String, dynamic>>> fetchChatMessages(int chatId) async {
    final url = Uri.parse('$baseUrl/api/chat/$chatId');
    final headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((msg) => msg as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to fetch chat messages');
    }
  }
}

class ChatStorage {
  static const String _keyMessages = 'chat_messages';

  static Future<List<Map<String, dynamic>>> loadMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? messagesString = prefs.getString(_keyMessages);
    if (messagesString != null) {
      List<dynamic> messagesList = jsonDecode(messagesString);
      return messagesList.cast<Map<String, dynamic>>();
    } else {
      return [];
    }
  }

  static Future<void> saveMessages(List<Map<String, dynamic>> messages) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String messagesString = jsonEncode(messages);
    prefs.setString(_keyMessages, messagesString);
  }
}
