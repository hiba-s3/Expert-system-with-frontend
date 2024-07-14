import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(MyApp());
}

final String font_family = "SignikaNegative";

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: font_family,
        ),
        home: DefinitionalSightScreen());
  }
}

class DefinitionalSightScreen extends StatefulWidget {
  @override
  _DefinitionalSightScreenState createState() =>
      _DefinitionalSightScreenState();
}

class _DefinitionalSightScreenState extends State<DefinitionalSightScreen> {
  final List<Map<String, String>> imageUrls = [
    {
      'imageUrl': "pic/cyber-securityprotect-shield-8936474-7277200.png",
      'n': "Are you experiencing problems with your computer?"
    },
    {
      'imageUrl': "pic/cyber-security-hacke-8936456-7277182 (2).png",
      'n': "Do you feel like you are being hacked?"
    },
    {
      'imageUrl': "pic/insecure-5441237-4543974.png",
      'n': "Don't worry, we will help you find the problem and solve it"
    },
  ];

  int currentIndex = 0;

  void nextDefinition() {
    setState(() {
      if (currentIndex < imageUrls.length - 1) {
        currentIndex++;
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(30, 7, 33, 255),
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imageUrls[currentIndex]['imageUrl']!,
            height: 300,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              // margin: EdgeInsets.all(20),
              child: Text(
            imageUrls[currentIndex]['n']!,
            style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                //Color.fromARGB(235, 219, 215, 232),
                //Color.fromARGB(236, 223, 221, 230),

                fontFamily: font_family),
            textAlign: TextAlign.center,
          )),
          Container(
            margin: EdgeInsets.only(top: 200),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  child: TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    ),
                    child: Text(
                      'Skip',
                      selectionColor: Color.fromARGB(107, 133, 129, 129),
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: font_family,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        decoration:
                            TextDecoration.underline, 
                        decorationColor: Color.fromARGB(
                            107, 133, 129, 129), 
                        decorationThickness:
                            1.0, 
                        decorationStyle: TextDecorationStyle.solid,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: nextDefinition,
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 106, 101, 210),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: font_family,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}

