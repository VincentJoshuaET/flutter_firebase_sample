import 'package:flutter/material.dart';
import 'package:flutter_firebase_sample/service/auth.dart';
import 'package:flutter_firebase_sample/util/widgets.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _signOut() async {
    final dynamic result = await _auth.signOut();
    if (result == null) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      showSnackBarAction(
          key: _scaffoldKey,
          text: result.message as String,
          label: 'Retry',
          onPressed: () => _signOut());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: const Text('Home'), centerTitle: true, actions: [
          FlatButton.icon(
              onPressed: () async => _signOut(),
              icon: const Icon(Icons.exit_to_app, color: Colors.white),
              label: const Text('Log Out'),
              textColor: Colors.white)
        ]));
  }
}
