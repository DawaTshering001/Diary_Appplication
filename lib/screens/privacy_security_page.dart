import 'package:flutter/material.dart';

class PrivacySecurityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy & Security'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy & Security Overview',
              style: Theme.of(context).textTheme.titleLarge, // Changed from headline6 to titleLarge
            ),
            SizedBox(height: 10),
            Text(
              'This section explains the privacy and security measures taken by the app to protect your data and ensure a safe user experience.',
              style: TextStyle(fontSize: 16),
            ),
            Divider(),
            
            Text(
              '1. Data Collection',
              style: Theme.of(context).textTheme.titleLarge, // Changed from headline6 to titleLarge
            ),
            SizedBox(height: 5),
            Text(
              'We collect the following types of data:\n- Personal information (name, email, etc.)\n- Usage data (app usage statistics)\n- Device information (OS version, device type, etc.)',
              style: TextStyle(fontSize: 16),
            ),
            Divider(),
            
            Text(
              '2. Data Usage',
              style: Theme.of(context).textTheme.titleLarge, // Changed from headline6 to titleLarge
            ),
            SizedBox(height: 5),
            Text(
              'Your data is used for:\n- Providing personalized services\n- Improving app functionality\n- Sending notifications and updates',
              style: TextStyle(fontSize: 16),
            ),
            Divider(),

            Text(
              '3. Third-Party Services',
              style: Theme.of(context).textTheme.titleLarge, // Changed from headline6 to titleLarge
            ),
            SizedBox(height: 5),
            Text(
              'We may share your data with third-party services for the following purposes:\n- Analytics and performance monitoring\n- Push notifications',
              style: TextStyle(fontSize: 16),
            ),
            Divider(),

            Text(
              '4. User Control and Permissions',
              style: Theme.of(context).textTheme.titleLarge, // Changed from headline6 to titleLarge
            ),
            SizedBox(height: 5),
            Text(
              'You have control over your data and can:\n- Review and update permissions\n- Request data deletion at any time',
              style: TextStyle(fontSize: 16),
            ),
            Divider(),

            Text(
              '5. Security Measures',
              style: Theme.of(context).textTheme.titleLarge, // Changed from headline6 to titleLarge
            ),
            SizedBox(height: 5),
            Text(
              'We implement the following security measures to protect your data:\n- Data encryption\n- Secure authentication methods (PIN, fingerprint)\n- Regular security updates',
              style: TextStyle(fontSize: 16),
            ),
            Divider(),

            Text(
              '6. Data Retention',
              style: Theme.of(context).textTheme.titleLarge, // Changed from headline6 to titleLarge
            ),
            SizedBox(height: 5),
            Text(
              'We retain your data for as long as necessary to provide the services and for legal purposes. You can request data deletion by contacting us.',
              style: TextStyle(fontSize: 16),
            ),
            Divider(),

            Text(
              '7. Contact Us',
              style: Theme.of(context).textTheme.titleLarge, // Changed from headline6 to titleLarge
            ),
            SizedBox(height: 5),
            Text(
              'If you have any questions or concerns regarding privacy or security, please contact us at:\n\nEmail: support@yourapp.com',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
