import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirebaseDataScreen(),
    );
  }
}

class FirebaseDataScreen extends StatefulWidget {
  @override
  _FirebaseDataScreenState createState() => _FirebaseDataScreenState();
}

class _FirebaseDataScreenState extends State<FirebaseDataScreen> {
  DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child('Living Room/Presencia');

  double temperatura = 0.0;
  double humedad = 0.0;

  @override
  void initState() {
    super.initState();

    _databaseReference.onValue.listen((event) {
      var data = event.snapshot.value;
      if (data != null && data is Map) {
        if (data.containsKey('Temperatura')) {
          setState(() {
            temperatura = data['Temperatura'].toDouble();
          });
        }

        if (data.containsKey('Humedad')) {
          setState(() {
            humedad = data['Humedad'].toDouble();
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Data'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Temperatura: $temperatura °C',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Humedad: $humedad %',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
