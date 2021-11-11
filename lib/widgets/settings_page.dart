import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    var prefs = await SharedPreferences.getInstance();
    _firstNameController.text = prefs.getString('firstName') ?? '';
    _lastNameController.text = prefs.getString('lastName') ?? '';
    _schoolController.text = prefs.getString('school') ?? '';
  }

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
              child: TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
              child: TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
              child: TextField(
                controller: _schoolController,
                decoration: const InputDecoration(
                  labelText: 'School',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
              child: TextButton(
                onPressed: () async {
                  var prefs = await SharedPreferences.getInstance();
                  prefs.setString('firstName', _firstNameController.text);
                  prefs.setString('lastName', _lastNameController.text);
                  prefs.setString('school', _schoolController.text);
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: const Text('Submit'),
                ),
              ),
            ),
          ],
        ),
      );
}
