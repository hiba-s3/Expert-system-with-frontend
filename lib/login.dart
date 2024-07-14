import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'main.dart';
import 'questions.dart'; // Ensure this is the correct import path
import 'signUp.dart'; // Ensure this is the correct import path
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showErrorDialog('Please fill in all fields');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url = 'http://192.168.43.227:8080/api/auth/login';
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'username': username,
      'password': password,
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionnairePage(
              token: token,
            ),
          ),
        );
      } else {
        _showErrorDialog('Invalid username or password');
      }
    } catch (error) {
      _showErrorDialog('An error occurred. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _usernameController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Username',
                      hintStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.lock, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 106, 101, 210),
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPage()),
                    ),
                    child: Text(
                      'Don\'t have an account? Sign up',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// import 'dart:convert';
// import 'package:KBS_app/chat.dart';
// import 'package:KBS_app/questions.dart';
// import 'package:KBS_app/services.dart';
// import 'package:KBS_app/signUp.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isLoading = false;

//   Future<void> _login() async {
//     final String username = _usernameController.text;
//     final String password = _passwordController.text;

//     if (username.isEmpty || password.isEmpty) {
//       _showErrorDialog('Please fill in all fields');
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     final url = 'http://192.168.137.1:8080/api/auth/login';
//     final headers = {'Content-Type': 'application/json'};
//     final body = json.encode({
//       'username': username,
//       'password': password,
//     });

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: headers,
//         body: body,
//       );

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         final token = data['token'];

//         final messages = await ChatStorage.loadMessages();
//         Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => QuestionnairePage(
//                 token: token,
//               ),
//             ));

//         // if (messages.isNotEmpty) {
//         //   Navigator.pushReplacement(
//         //     context,
//         //     MaterialPageRoute(
//         //       builder: (context) => RecentMessagesPage(),
//         //     ),
//         //   );
//         // } else {
//         // Navigator.pushReplacement(
//         //   context,
//         //   MaterialPageRoute(
//         //     builder: (context) => QuestionnairePage(
//         //       token: token,
//         //     ),
//         //   ),
//         //   );
//         // }
//       } else {
//         _showErrorDialog('Invalid username or password');
//       }
//     } catch (error) {
//       _showErrorDialog('An error occurred. Please try again.');
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text('Error'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             child: Text('Okay'),
//             onPressed: () {
//               Navigator.of(ctx).pop();
//             },
//           )
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           Container(
//             color: Colors.black.withOpacity(0.5),
//           ),
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Welcome Back',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   TextField(
//                     controller: _usernameController,
//                     style: TextStyle(color: Colors.white),
//                     decoration: InputDecoration(
//                       hintText: 'Username',
//                       hintStyle: TextStyle(color: Colors.white70),
//                       filled: true,
//                       fillColor: Colors.white.withOpacity(0.3),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide.none,
//                       ),
//                       prefixIcon: Icon(Icons.person, color: Colors.white),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   TextField(
//                     controller: _passwordController,
//                     obscureText: true,
//                     style: TextStyle(color: Colors.white),
//                     decoration: InputDecoration(
//                       hintText: 'Password',
//                       hintStyle: TextStyle(color: Colors.white70),
//                       filled: true,
//                       fillColor: Colors.white.withOpacity(0.3),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide: BorderSide.none,
//                       ),
//                       prefixIcon: Icon(Icons.lock, color: Colors.white),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   _isLoading
//                       ? CircularProgressIndicator()
//                       : ElevatedButton(
//                           onPressed: _login,
//                           style: ElevatedButton.styleFrom(
//                             primary: Color.fromARGB(255, 106, 101, 210),
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 50, vertical: 15),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           child: Text(
//                             'Login',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                   SizedBox(height: 20),
//                   TextButton(
//                     onPressed: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => SignupPage()),
//                     ),
//                     child: Text(
//                       'Don\'t have an account? Sign up',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
