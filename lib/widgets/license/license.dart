import 'package:climbing_gym_app/models/License.dart';
import 'package:flutter/material.dart';

class LicenseView extends StatelessWidget {
  final List<License> allLicense;

  const LicenseView({
    Key key,
    @required this.allLicense,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView.builder(
        padding: EdgeInsets.only(bottom: 24),
        itemCount: allLicense.length,
        itemBuilder: (context, index) {
          final license = allLicense[index];
          return ListTile(
            title: Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                license.title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent),
              ),
            ),
            subtitle: Text(
              license.text + '\n\n',
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          );
        },
      );
}
