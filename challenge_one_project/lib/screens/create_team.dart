import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:challenge_one_project/models/User.dart';
import 'package:http/http.dart' as http;

class CreateTeam extends StatefulWidget {
  const CreateTeam({super.key});

  @override
  State<CreateTeam> createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {

  Future<List<UserModel>> fetchUsers() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/users'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Team')),
      body: FutureBuilder(
        future: fetchUsers(), // Use the Future here
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Loading state
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Error state
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found')); // No data state
          } else {
            List<UserModel> users = snapshot.data!;

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                UserModel user = users[index];
                return ListTile(
                  title: Text('${user.firstName} ${user.lastName}'), // Display first & last name
                  leading: const Icon(Icons.person), // User icon
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      // Handle adding user to a team
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
