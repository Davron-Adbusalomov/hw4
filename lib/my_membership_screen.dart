// my_membership_screen.dart
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MyMembershipScreen extends StatefulWidget {
  @override
  _MyMembershipScreenState createState() => _MyMembershipScreenState();
}

class _MyMembershipScreenState extends State<MyMembershipScreen> {
  String selectedPlan = '';

  Future<void> _retrieveSelectedPlan() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'membership_database.db'),
      version: 1,
    );

    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.query('membership');
    if (result.isNotEmpty) {
      setState(() {
        selectedPlan = result.first['plan'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _retrieveSelectedPlan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Membership Screen'),
      ),
      body: Center(
        child: Text('Your Selected Plan: $selectedPlan'),
      ),
    );
  }
}
