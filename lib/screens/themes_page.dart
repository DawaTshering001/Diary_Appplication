import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';
import '../theme/app_theme.dart';

class ThemesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Your Theme'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Select a Theme for Your App',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _themeList.length,
                itemBuilder: (context, index) {
                  final theme = _themeList[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: InkWell(
                      onTap: () => themeProvider.setTheme(theme['theme']),
                      borderRadius: BorderRadius.circular(15),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              theme['icon'],
                              size: 40,
                              color: theme['theme'].primaryColor,
                            ),
                            SizedBox(height: 10),
                            Text(
                              theme['name'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: theme['theme'].primaryColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // List of themes with icons and theme names
  final List<Map<String, dynamic>> _themeList = [
    {
      'name': 'Light Theme',
      'theme': lightTheme,
      'icon': Icons.wb_sunny,
    },
    {
      'name': 'Dark Theme',
      'theme': darkTheme,
      'icon': Icons.nights_stay,
    },
    {
      'name': 'Green Theme',
      'theme': greenTheme,
      'icon': Icons.eco,
    },
    {
      'name': 'Purple Theme',
      'theme': purpleTheme,
      'icon': Icons.star_purple500,
    },
    {
      'name': 'Red Theme',
      'theme': redTheme,
      'icon': Icons.fiber_manual_record,
    },
    {
      'name': 'Pink Theme',
      'theme': pinkTheme,
      'icon': Icons.favorite,
    },
    {
      'name': 'Teal Theme',
      'theme': tealTheme,
      'icon': Icons.airline_seat_recline_extra,
    },
    {
      'name': 'Orange Theme',
      'theme': orangeTheme,
      'icon': Icons.photo_camera_back,
    },
    {
      'name': 'Blue Grey Theme',
      'theme': blueGreyTheme,
      'icon': Icons.lens_blur,
    },
    {
      'name': 'Indigo Theme',
      'theme': indigoTheme,
      'icon': Icons.pan_tool,
    },
    {
      'name': 'Yellow Theme',
      'theme': yellowTheme,
      'icon': Icons.highlight,
    },
  ];
}
