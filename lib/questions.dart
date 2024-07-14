// import 'dart:convert';
// import 'package:KBS_app/services.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class QuestionnairePage extends StatefulWidget {
//   final String token;

//   QuestionnairePage({required this.token});

//   @override
//   _QuestionnairePageState createState() => _QuestionnairePageState();
// }

// class _QuestionnairePageState extends State<QuestionnairePage> {
//   late IO.Socket socket;
//   String? question;
//   List<String> answers = [];
//   String? userResponse;
//   bool isLoading = true;
//   int? chatId;

//   late ApiService apiService;

//   @override
//   void initState() {
//     super.initState();
//     apiService =
//         ApiService(baseUrl: 'http://192.168.43.248:8080', token: widget.token);
//     createAndFetchChat();
//   }

//   void createAndFetchChat() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       chatId = prefs.getInt("chat_id");

//       if (chatId == null) {
//         final chat = await apiService.createChat('test');
//         chatId = chat['id'];
//         saveChatId(chatId!);
//       } else {
//         // Fetch chat messages
//         final messages = await apiService.fetchChatMessages(chatId!);
//         if (messages.isNotEmpty) {
//           setState(() {
//             question = messages[0]['content'];
//             isLoading = false;
//           });
//         }
//       }
//       print(chatId);
//       connectSocketIO();
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   Future<void> saveChatId(int chatId) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('chat_id', chatId);
//   }

//   void connectSocketIO() {
//     if (chatId == null) return;

//     try {
//       socket = IO.io('http://192.168.43.248:5000', <String, dynamic>{
//         'transports': ['websocket'],
//       });

//       socket.on('connect', (_) {
//         print('Connected to the server');
//         socket.emit(
//             'message',
//             jsonEncode(
//                 {'answer': 'user ,,,,,,!', 'type': 'a', 'chat_id': chatId}));
//       });

//       socket.on('message', (data) {
//         print(data);
//         // final decodedData = json.decode(data);
//         setState(() {
//           question = data['answer'] != null ? data['answer'] : "";
//           answers = data["valid"] != null
//               ? List<String>.from(data['valid'])
//               : <String>[];
//         });
//       });

//       socket.on('connect_error', (error) {
//         print('Connection error: $error');
//       });

//       socket.on('disconnect', (_) {
//         print('Disconnected from server');
//       });
//     } catch (e) {
//       print('Error connecting to Socket.IO: $e');
//     }
//     isLoading = false;
//     setState(() {});
//   }

//   void sendAnswer(String answer) {
//     if (chatId == null) return;

//     socket.emit('message',
//         jsonEncode({'answer': answer, 'type': 'a', 'chat_id': chatId}));

//     setState(() {
//       userResponse = answer;
//       isLoading = false;
//     });
//   }

//   @override
//   void dispose() {
//     socket.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color.fromARGB(255, 106, 101, 210),
//         title: Text('Questions'),
//         leading: Container(
//           margin: EdgeInsets.all(8),
//           padding: EdgeInsets.all(1),
//           child: Image.asset(
//             "pic/942802.png",
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (isLoading)
//               Center(child: CircularProgressIndicator())
//             else if (question != null)
//               Container(
//                 padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   question!,
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Roboto',
//                   ),
//                 ),
//               ),
//             SizedBox(height: 20),
//             if (userResponse != null)
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: Container(
//                   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                   decoration: BoxDecoration(
//                     color: Color.fromARGB(255, 106, 101, 210),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     userResponse!,
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       fontFamily: 'Roboto',
//                     ),
//                   ),
//                 ),
//               ),
//             Spacer(),
//             if (!isLoading && answers.isNotEmpty)
//               Column(
//                 children: answers.map((answer) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 5),
//                     child: ElevatedButton(
//                       onPressed: () => sendAnswer(answer),
//                       style: ElevatedButton.styleFrom(
//                         primary: Colors.grey[300],
//                         onPrimary: Colors.black,
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 40, vertical: 20),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                       child: Text(
//                         answer,
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontFamily: 'Roboto',
//                         ),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:KBS_app/services.dart';
import 'package:http/http.dart' as http;

class QuestionnairePage extends StatefulWidget {
  final String token;

  QuestionnairePage({required this.token});

  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  late IO.Socket socket;
  String? question;
  List<String> answers = [];
  List<Map<String, dynamic>> messages = [];
  bool isLoading = true;
  int? chatId;

  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService =
        ApiService(baseUrl: 'http://192.168.43.227:8080', token: widget.token);
    createAndFetchChat();
  }

  void createAndFetchChat() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      chatId = prefs.getInt("chat_id");

      if (chatId == null) {
        final chat = await apiService.createChat('test');
        chatId = chat['id'];
        saveChatId(chatId!);
      } else {
        final chatMessages = await apiService.fetchChatMessages(chatId!);
        if (chatMessages.isNotEmpty) {
          setState(() {
            question = chatMessages[0]['content'] as String;
            messages = chatMessages;
            isLoading = false;
          });
        }
      }
      connectSocketIO();
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> saveChatId(int chatId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('chat_id', chatId);
  }

  void connectSocketIO() {
    if (chatId == null) return;

    try {
      socket = IO.io('http://192.168.137.1:5000', <String, dynamic>{
        'transports': ['websocket'],
      });

      socket.on('connect', (_) {
        socket.emit(
            'message',
            jsonEncode(
                {'answer': 'user connected!', 'type': 'a', 'chat_id': chatId}));
      });
      socket.on('message', (data) {
        setState(() {
          question = data['answer'] != null ? data['answer'] : "";
          answers = data["valid"] != null
              ? List<String>.from(data['valid'])
              : <String>[];
          messages.add({'chat_id': chatId, 'content': question ?? ''});
          ChatStorage.saveMessages(messages); // Save messages
        });
      });

      socket.on('connect_error', (error) {
        print('Connection error: $error');
      });

      socket.on('disconnect', (_) {
        print('Disconnected from server');
      });
    } catch (e) {
      print('Error connecting to Socket.IO: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> sendMessage(String token, String answer, int chatId) async {
    final url = 'http://192.168.43.227:8080/api/chat/message';
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final data = {
      'content': answer,
      'chat_id': chatId,
    };

    final response = await http.post(Uri.parse(url),
        headers: headers, body: jsonEncode(data));

    if (response.statusCode == 200) {
      print('Message saved successfully');
    } else {
      print('Error saving message: ${response.body}');
    }
  }

  void sendAnswer(String answer) {
    if (chatId == null) return;

    sendMessage(widget.token, answer, chatId!);

    socket.emit('message',
        jsonEncode({'answer': answer, 'type': 'a', 'chat_id': chatId}));

    setState(() {
      messages.add({'chat_id': chatId, 'content': answer});
      ChatStorage.saveMessages(messages);
    });
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  Widget _buildChatUI() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 106, 101, 210),
        title: Text('Questions'),
        leading: Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(1),
          child: Image.asset(
            "pic/942802.png",
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isUser = message['chat_id'] == chatId;
                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: isUser
                            ? Color.fromARGB(255, 106, 101, 210)
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        message['content'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isUser ? Colors.white : Colors.black,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (isLoading) Center(child: CircularProgressIndicator()),
            if (!isLoading && answers.isNotEmpty)
              Column(
                children: answers.map((answer) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: ElevatedButton(
                      onPressed: () => sendAnswer(answer),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey[300],
                        onPrimary: Colors.black,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        answer,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildChatUI();
  }
}
