import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dashboard_page.dart';
import 'profile.dart';
import 'settings.dart';

void main() {
  runApp(const dairyScreen());
}

class dairyScreen extends StatelessWidget {
  const dairyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Diary Form',
      home: FormPage(),
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController previous_dateController = TextEditingController();
  final TextEditingController court_hallController = TextEditingController();
  final TextEditingController perticularsController = TextEditingController();
  final TextEditingController stagesController = TextEditingController();
  final TextEditingController next_dateController = TextEditingController();
  bool _isLoading = false;

  // Submit the form data to the API
  Future<void> submitForm(String previous_date, String court_hall, String perticulars,
      String stages, String next_date) async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    final response = await http.post(
      Uri.parse('http://10.0.2.2/api/wereads/visitors1.php'), // Make sure the URL is correct
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'previous_date': previous_date,
        'court_hall': court_hall,
        'perticulars': perticulars,
        'stages': stages,
        'next_date': next_date,
      },
    );

    setState(() {
      _isLoading = false; // Hide loading indicator after request
    });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['message'] != null) {
        _showPopupDialog(context, 'Success', responseData['message']);
      } else {
        _showPopupDialog(context, 'Error', responseData['error'] ?? 'Something went wrong!');
      }
    } else {
      _showPopupDialog(context, 'Error', 'Failed to submit form. Please try again.');
    }
  }

  void _showPopupDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diary Form'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
                  (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Previous Date',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: previous_dateController,
                  hintText: 'Enter previous date',
                  icon: Icons.calendar_today,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Court Hall',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: court_hallController,
                  hintText: 'Enter court hall',
                  icon: Icons.business,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Perticulars',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: perticularsController,
                  hintText: 'Enter particulars',
                  icon: Icons.note,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Stage',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: stagesController,
                  hintText: 'Enter stage',
                  icon: Icons.flag,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Next Date',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: next_dateController,
                  hintText: 'Enter next date',
                  icon: Icons.calendar_today,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                    if (_formKey.currentState?.validate() ?? false) {
                      String previous_date = previous_dateController.text.trim();
                      String court_hall = court_hallController.text.trim();
                      String perticulars = perticularsController.text.trim();
                      String stages = stagesController.text.trim();
                      String next_date = next_dateController.text.trim();

                      submitForm(previous_date, court_hall, perticulars, stages, next_date);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text(
                    'Submit',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70.0,
        color: Colors.blueAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const DashboardPage()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Reusable function for text fields with icons
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.deepPurpleAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a valid value';
        }
        return null;
      },
    );
  }
}
