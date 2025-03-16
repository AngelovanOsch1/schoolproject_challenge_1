// ignore_for_file: library_private_types_in_public_api

import 'package:challenge_one_project/enums.dart';
import 'package:challenge_one_project/models/user.dart';
import 'package:challenge_one_project/services/user_services.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gebruikers')),
      body: StreamBuilder<List<UserModel>>(
        stream: UserService.fetchUsersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error: geen lijst beschikbaar'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text(''));
          }

          final users = snapshot.data!;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20.0,
              columns: const [
                DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Voornaam', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Achternaam', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Role', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Team Naam', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Aanpassen', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Verwijderen', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: users.map((user) {
                return DataRow(
                  cells: [
                    DataCell(Text(user.userId.toString())),
                    DataCell(Text(user.firstName)),
                    DataCell(Text(user.lastName)),
                    DataCell(Text(user.role.name)),
                    DataCell(Text(user.teamName ?? 'Geen team')),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          iconSize: 20,
                          onPressed: () {
                            // Open the dialog when the edit icon is clicked
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return updateUserDialog(context, user); // Show update dialog
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    // Delete button
                    DataCell(
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          iconSize: 20,
                          onPressed: () {
                            deleteUser(user.userId);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  // Function to handle delete logic
  deleteUser(int userId) {
    UserService.deleteUser(userId);
  }

  // Function to show the update dialog
  Widget updateUserDialog(BuildContext context, UserModel user) {
    TextEditingController firstNameController = TextEditingController(text: user.firstName);
    TextEditingController lastNameController = TextEditingController(text: user.lastName);
    TextEditingController teamNameController = TextEditingController(text: user.teamName ?? '');
    
    Role selectedRole = user.role;

    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Update User'),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'Voornaam'),
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Achternaam'),
              ),
              // Role dropdown
              DropdownButton<Role>(
                value: selectedRole,
                onChanged: (Role? newRole) {
                  if (newRole != null) {
                    setState(() {
                      selectedRole = newRole;
                    });
                  }
                },
                items: Role.values.map((role) {
                  return DropdownMenuItem<Role>(
                    value: role,
                    child: Text(role.name),
                  );
                }).toList(),
                isExpanded: true,
              ),
              TextField(
                controller: teamNameController,
                decoration: const InputDecoration(labelText: 'Team Name'),
              ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () {      
              UserService.updateUser(
                UserModel(
                userId: user.userId,
                firstName: firstNameController.text,
                lastName:  lastNameController.text,
                role: selectedRole,
                teamName: teamNameController.text,
              ));
            Navigator.pop(context);
          },
          child: const Text('Opslaan'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Annuleren'),
        ),
      ],
    );
  }
}
