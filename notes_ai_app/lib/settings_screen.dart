import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkModeEnabled = false;
  bool isAutoSaveEnabled = true;
  bool isTextToSpeechEnabled = false;
  bool isNotificationsEnabled = true; // Renamed for clarity
  bool isCloudSyncEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Dark Mode'),
            subtitle: Text('Enable dark theme throughout the app.'),
            value: isDarkModeEnabled,
            onChanged: (bool value) {
              setState(() {
                isDarkModeEnabled = value;
              });
              // Add logic to persist this setting
            },
          ),
          SwitchListTile(
            title: Text('Auto-Save'),
            subtitle: Text('Automatically save changes.'),
            value: isAutoSaveEnabled,
            onChanged: (bool value) {
              setState(() {
                isAutoSaveEnabled = value;
              });
              // Add logic to persist this setting
            },
          ),
          SwitchListTile(
            title: Text('Text-to-Speech'),
            subtitle: Text('Read the text aloud.'),
            value: isTextToSpeechEnabled,
            onChanged: (bool value) {
              setState(() {
                isTextToSpeechEnabled = value;
              });
              // Add logic to persist this setting
            },
          ),
          SwitchListTile(
            title: Text('Notifications'),
            subtitle: Text('Receive app notifications.'),
            value: isNotificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                isNotificationsEnabled = value;
              });
              // Add logic to persist this setting
            },
          ),
          SwitchListTile(
            title: Text('Cloud Sync'),
            subtitle: Text('Synchronize data with cloud storage.'),
            value: isCloudSyncEnabled,
            onChanged: (bool value) {
              setState(() {
                isCloudSyncEnabled = value;
              });
              // Add logic to persist this setting
            },
          ),
        ],
      ),
    );
  }
}