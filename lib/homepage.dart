import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'result_page.dart'; // Import the ResultPage
import 'history_page.dart'; // Import the history_page
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> terminalLogs = []; // List to hold terminal output
  List<String> history = []; // List to store history logs
  CameraController? _controller;
  bool isCameraActive = false; // Camera toggle state
  bool isCameraInitialized = false; // Track camera initialization state
  String scanningResult = ''; // To store scanning result

  // Initialize the camera
  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      _controller = CameraController(firstCamera, ResolutionPreset.medium);
      await _controller!.initialize();

      setState(() {
        isCameraInitialized = true;
      });
    } catch (e) {
      setState(() {
        isCameraInitialized = false;
      });
      print("Error initializing camera: $e");
    }
  }

  // Function to toggle the camera on and off
  void _toggleCamera() async {
    setState(() {
      if (isCameraActive) {
        // If camera is active, dispose of it
        _controller?.dispose();
        _controller = null;
        isCameraInitialized = false;
      } else {
        // If camera is off, initialize it
        _initializeCamera();
      }
      isCameraActive = !isCameraActive; // Toggle camera state
    });
  }

  // Function to simulate starting the process
  void _startProcess() {
    setState(() {
      terminalLogs.add('Process started...');
      terminalLogs.add('Simulating disease detection...');
    });

    // Simulate a scanning process and generate a result
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        terminalLogs.add('Process completed.');
        scanningResult = 'Disease Detected: Type A'; // Example result
        history.add(scanningResult); // Add result to history
      });

      // Navigate to ResultPage when process is completed
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(result: scanningResult),
        ),
      );
    });
  }

  // Function to clear terminal logs
  void _clearLogs() {
    setState(() {
      terminalLogs.clear();
    });
  }

  // List of folder paths
  final List<String> categories = [
    'Fresh Water Fish Dataset/Argulus',
    'Fresh Water Fish Dataset/Broken antennae and rostrum',
    'Fresh Water Fish Dataset/EUS',
    'Fresh Water Fish Dataset/Healthy Fish',
    'Fresh Water Fish Dataset/Redspot',
    'Fresh Water Fish Dataset/Tail And Fin Rot',
    'Fresh Water Fish Dataset/THE BACTERIAL GILL ROT',
  ];

  // Function to read files in a category and return images
  Future<List<File>> _getImagesInCategory(String categoryPath) async {
    final directory = Directory(categoryPath);

    if (!await directory.exists()) {
      return [];
    }

    final files = directory.listSync();
    List<File> imageFiles = [];
    for (var file in files) {
      if (file is File && _isImageFile(file.path)) {
        imageFiles.add(file);
      }
    }
    return imageFiles;
  }

  // Helper function to check if a file is an image
  bool _isImageFile(String path) {
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif'];
    final extension = path.split('.').last.toLowerCase();
    return imageExtensions.contains(extension);
  }

  @override
  void dispose() {
    _controller?.dispose(); // Dispose of the camera controller when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tilapia Disease Detection',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal[800],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),

            // Camera box and toggle button in a Stack
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Stack(
                children: [
                  // Monitor box (container for camera or status)
                  Container(
                    height: 400, // Set height to match terminal log
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green, width: 2),
                    ),
                    child: isCameraInitialized && isCameraActive
                        ? CameraPreview(_controller!) // Show the camera preview
                        : Center(
                            child: Text(
                              isCameraActive
                                  ? 'Initializing Camera...'
                                  : 'Camera is turned off',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                  ),

                  // Toggle Camera Button at the top
                  Positioned(
                    top: 8,
                    right: 8,
                    child: ElevatedButton.icon(
                      onPressed: _toggleCamera,
                      icon: Icon(
                        isCameraActive ? Icons.videocam_off : Icons.videocam,
                      ),
                      label: Text(isCameraActive
                          ? 'Turn Off Camera'
                          : 'Turn On Camera'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCameraActive
                            ? Colors.redAccent
                            : Colors.greenAccent, // Change color dynamically
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Terminal-style output section with a clear button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(
                          color: const Color.fromARGB(
                              255, 54, 255, 61)), // Green border
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Terminal Logs
                        Expanded(
                          child: ListView.builder(
                            itemCount: terminalLogs.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  terminalLogs[index],
                                  style: const TextStyle(
                                    fontFamily: 'Courier',
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 90, 251, 95),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                      onPressed: _clearLogs, // Clear the terminal log
                    ),
                  ),
                ],
              ),
            ),

            // Row with buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _startProcess, // Start the process
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryPage(history: history),
                        ),
                      );
                    },
                    icon: const Icon(Icons.history),
                    label: const Text('History'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Show Categories in a Dialog or Navigate to a new page
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Categories'),
                            content: SizedBox(
                              height: 200,
                              width: 300,
                              child: ListView.builder(
                                itemCount: categories.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(categories[index]),
                                    onTap: () async {
                                      // Show loading indicator while fetching images
                                      showDialog(
                                        context: context,
                                        barrierDismissible:
                                            false, // Prevent dismissal
                                        builder: (context) => const Center(
                                            child: CircularProgressIndicator()),
                                      );

                                      // Get images for the clicked category
                                      List<File> images =
                                          await _getImagesInCategory(
                                              categories[index]);

                                      // Close the loading dialog
                                      Navigator.pop(context);

                                      // Navigate to a new screen showing images
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ImageGalleryPage(
                                            categoryName: categories[index]
                                                .split('/')
                                                .last,
                                            images: images,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the dialog
                                },
                                child: const Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.image),
                    label: const Text('Show Dataset'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Image Gallery Page to show images in a grid
class ImageGalleryPage extends StatelessWidget {
  final String categoryName;
  final List<File> images;

  const ImageGalleryPage(
      {super.key, required this.categoryName, required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: Colors.teal[800],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Image.file(images[index]);
        },
      ),
    );
  }
}
