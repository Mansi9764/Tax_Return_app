import 'package:flutter/material.dart';
import 'package:retail_tax_filing_app/screenss/Login.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Professional gradient background with subtle shades
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 241, 220, 189),const Color.fromARGB(255, 244, 205, 146)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 80.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Professional image presentation
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/home.jpg',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 30),
                // Professional, simple heading
                Text(
                  "Welcome to EasyTax",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                // Simple, elegant subtitle
                Text(
                  "Effortless tax filing at your fingertips.",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                // Bullet point section with subtle icons
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Icon(Icons.upload_file, color: Colors.white70),
                      title: Text(
                        "Upload your documents securely",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.question_answer, color: Colors.white70),
                      title: Text(
                        "Answer a few simple questions",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.done_all, color: Colors.white70),
                      title: Text(
                        "Sit back and let us handle the rest!",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                // Professional card design for call-to-action
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.white.withOpacity(0.9),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          "Start Your Tax Journey Today!",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Join thousands of satisfied customers with EasyTax.",
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                // Simple, flat button with consistent style
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the login screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade600,  // Flat, solid color
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  child: Text('Let\'s Get Started!'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
