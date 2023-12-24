import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'my_membership_screen.dart';

class MembershipScreen extends StatefulWidget {
  @override
  _MembershipScreenState createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  List<String> membershipPlans = [];
  String selectedPlan = '';

  Future<void> _fetchMembershipDetails() async {
    final response = await http.get(Uri.parse('https://api.example.com/membership-plans'));
    if (response.statusCode == 200) {
      final List<String> fetchedPlans = List<String>.from(json.decode(response.body));
      setState(() {
        membershipPlans = fetchedPlans;
      });
    }
  }

  Future<void> _storeSelectedPlan() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'membership_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE membership(id INTEGER PRIMARY KEY AUTOINCREMENT, plan TEXT)',
        );
      },
      version: 1,
    );

    final Database db = await database;
    await db.insert(
      'membership',
      {'plan': selectedPlan},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Membership Screen'),
      ),
      body: Column(
        children: [
          // Display membership plans
          Expanded(
            child: ListView.builder(
              itemCount: membershipPlans.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(membershipPlans[index]),
                  onTap: () {
                    setState(() {
                      selectedPlan = membershipPlans[index];
                    });
                  },
                );
              },
            ),
          ),
          // Buttons for fetching more details and storing selections
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _fetchMembershipDetails(),
                child: Text('Fetch More Details'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _storeSelectedPlan();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyMembershipScreen()),
                  );
                },
                child: Text('Go to My Membership'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
