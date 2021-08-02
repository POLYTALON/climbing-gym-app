import 'package:climbing_gym_app/models/AppUser.dart';
import 'package:climbing_gym_app/models/License.dart';
import 'package:climbing_gym_app/services/authservice.dart';
import 'package:climbing_gym_app/widgets/license/license.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/constants.dart' as Constants;
import '../../locator.dart';

class LegalNotesScreen extends StatefulWidget {
  @override
  _LegalNotesScreenState createState() => _LegalNotesScreenState();
}

class _LegalNotesScreenState extends State<LegalNotesScreen> {
  final authService = locator<AuthService>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Constants.polyDark,
        child: StreamBuilder<AppUser>(
            stream: authService.streamAppUser(),
            initialData: new AppUser().empty(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.active ||
                  !snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(color: Constants.polyGreen),
                );
              } else {
                return Scaffold(
                  // AppBar
                  backgroundColor: Constants.polyDark,
                  appBar: PreferredSize(
                      preferredSize: Size.fromHeight(64.0),
                      child: AppBar(
                          brightness: Brightness.dark,
                          backgroundColor: Constants.polyDark,
                          actions: [
                            IconButton(
                              icon: Image.asset(
                                  'assets/img/polytalon_logo_notext.png'),
                              onPressed: () {},
                            )
                          ],
                          title: Text("Legal Notes",
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.w900)),
                          bottom: PreferredSize(
                            preferredSize: Size.fromHeight(2.0),
                            child: Container(
                              color: Colors.white38,
                              height: 2.0,
                              margin: const EdgeInsets.only(
                                  left: 16.0, right: 16.0),
                            ),
                          ))),
                  body: FutureBuilder<List<License>>(
                    future: readLicense(),
                    builder: (context, snapshot) {
                      final allLicense = snapshot.data;

                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator());
                        default:
                          if (snapshot.hasError) {
                            return Center(child: Text('Can not load Licenses'));
                          } else {
                            return Container(
                                padding: EdgeInsets.only(bottom: 32.0),
                                child: LicenseView(allLicense: allLicense));
                          }
                      }
                    },
                  ),
                );
              }
            }));
  }

  Future<List<License>> readLicense() async =>
      LicenseRegistry.licenses.asyncMap<License>((license) async {
        final title = license.packages.join('\n');
        final text = license.paragraphs
            .map<String>((paragraph) => paragraph.text)
            .join('\n\n');

        return License(title, text);
      }).toList();
}
