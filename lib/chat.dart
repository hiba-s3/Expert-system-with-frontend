import 'package:KBS_app/services.dart';
import 'package:flutter/material.dart';

class RecentMessagesPage extends StatefulWidget {
  final int? chatId;

  RecentMessagesPage({this.chatId});

  @override
  _RecentMessagesPageState createState() => _RecentMessagesPageState();
}

class _RecentMessagesPageState extends State<RecentMessagesPage> {
  List<Map<String, dynamic>> messages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  void loadMessages() async {
    final loadedMessages = await ChatStorage.loadMessages();
    setState(() {
      messages = loadedMessages;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 106, 101, 210),
        title: Text('Recent Messages'),
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
                  final isUser = message['chat_id'] == widget.chatId;
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
          ],
        ),
      ),
    );
  }
}
