import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> history = []; // List to store log history

  // Function to save history to a txt file
  Future<void> saveHistoryToFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/history.txt');
    String logs = history.join('\n');
    await file.writeAsString(logs);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('History saved to history.txt')),
    );
  }

  // Function to add a sample log to the history
  void addSampleLog() {
    setState(() {
      history.add("Sample log at ${DateTime.now()}");
    });
  }

  // Navigate to the HistoryPage
  void goToHistoryPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryPage(history: history),
      ),
    );
  }

  // Additional button action
  void clearHistory() {
    setState(() {
      history.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('History cleared.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Colors.teal[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: addSampleLog,
                  child: const Text('Add Log'),
                ),
                ElevatedButton(
                  onPressed: goToHistoryPage,
                  child: const Text('View History'),
                ),
                ElevatedButton(
                  onPressed: saveHistoryToFile,
                  child: const Text('Save History'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // New button to clear history
            ElevatedButton(
              onPressed: clearHistory,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[400], // Button color
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 12), // Custom size
              ),
              child: const Text(
                'Clear History',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveHistoryToFile,
        backgroundColor: Colors.teal[800],
        child: const Icon(Icons.save),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class HistoryPage extends StatelessWidget {
  final List<String> history;

  const HistoryPage({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Colors.teal[800],
      ),
      body: history.isEmpty
          ? const Center(
              child: Text(
                'No history available.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.history, color: Colors.teal),
                  title: Text(
                    history[index],
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              },
            ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
