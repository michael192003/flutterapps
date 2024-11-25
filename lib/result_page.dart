import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final String result; // Accept result as a parameter

  const ResultPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Result Page',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 64, 224, 208),
          ),
        ),
        backgroundColor: Colors.teal[800], // Matching AppBar color
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Result',
              style: TextStyle(fontSize: 44),
            ),
            const SizedBox(height: 30), // Space between text and the box

            // Added box to display the result
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: 350, // Width of the box
                height: 150, // Height of the box
                decoration: BoxDecoration(
                  color: Colors.blueAccent, // Box color
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                  border: Border.all(
                    color: Colors.black,
                    width: 3, // Thicker border on all sides
                  ), // Border style
                ),
                child: Center(
                  child: Text(
                    result.isEmpty
                        ? 'No result available'
                        : result, // Display result
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20), // Space between box and button
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to HomePage
              },
              child: const Text('Go Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
