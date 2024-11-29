import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hides the debug banner
      title: 'Jokes App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Jokes App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _joke = "Press the button below to load a joke!"; // Default message
  bool _isLoading = false; // Loading state

  // Function to fetch jokes from the API
  Future<void> _fetchJoke() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    final url = Uri.parse(
        'https://v2.jokeapi.dev/joke/Any?blacklistFlags=sexist');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check if the joke is single or two-part
        setState(() {
          if (data['type'] == 'single') {
            _joke = data['joke'];
          } else if (data['type'] == 'twopart') {
            _joke = "${data['setup']}\n\n${data['delivery']}";
          }
          _isLoading = false; // Stop loading
        });
      } else {
        setState(() {
          _joke = "Failed to fetch joke. Try again!";
          _isLoading = false; // Stop loading
        });
      }
    } catch (e) {
      setState(() {
        _joke = "An error occurred: $e";
        _isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          widget.title,
          style: const TextStyle(
              fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Add an image or icon at the top
              const Icon(
                  Icons.emoji_emotions, size: 100, color: Colors.orangeAccent),

              const SizedBox(height: 20),

              // Add a Card for the joke text
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                    _joke,
                    textAlign: TextAlign.center,
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Add a gradient-styled button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 32),
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
                onPressed: _fetchJoke,
                child: const Text(
                  'Get a Joke',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.teal
          .shade50, // Light background color for better contrast
    );
  }
}