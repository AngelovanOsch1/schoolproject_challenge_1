import 'package:challenge_one_project/enums.dart';
import 'package:challenge_one_project/main.dart';
import 'package:challenge_one_project/models/user.dart';
import 'package:challenge_one_project/services/user_services.dart';
import 'package:flutter/material.dart';

class AddTeam extends StatefulWidget {
  const AddTeam({super.key});

  @override
  State<AddTeam> createState() => _AddTeamState();
}

class _AddTeamState extends State<AddTeam> {
  final TextEditingController teamNameController = TextEditingController();

  List<UserModel> userList = [];
  List<UserModel> addedUserList = []; // Users added to the team

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.only(bottom: 50),
      content: SizedBox(
        height: 400,
        width: 700,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              buildInputColumn('Team Name', teamNameController),
              const SizedBox(height: 20),
              Flexible(child: userListBuilder(context)),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text('Annuleren'),
            ),
            TextButton(
              onPressed: () {
                // Handle creating team logic here
                print('Team created with name: ${teamNameController.text}');
                Navigator.of(context).pop();
              },
              child: const Text('Maak team aan'),
            ),
          ],
        ),
      ],
    );
  }

  // Build the user list and show users from the backend (API or service)
  Widget userListBuilder(BuildContext context) {
    return FutureBuilder<List<UserModel>>(
      future: UserService.fetchUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No users found'));
        } else {
          // If data is available, filter the user list
          userList = snapshot.data!.where((user) => user.role == Role.user).toList();
          return box();
        }
      },
    );
  }

  // Display user list and allow users to be added to team
  Widget box() {
    return Expanded(
      child: Row(
        children: [
          Expanded(child: userListMembers()),
          const SizedBox(width: 30),
        ],
      ),
    );
  }

  // Display the list of users with checkboxes
  Widget userListMembers() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${addedUserList.length}/11 toegevoegd',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10), // Border radius applied here
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: userList.length,
            itemBuilder: (context, index) {
              UserModel user = userList[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListTile(
                      title: Text('${user.firstName} ${user.lastName}'),
                      leading: const Icon(Icons.person), // User icon
                      trailing: Checkbox(
                        value: addedUserList.contains(user), // Check if user is in the added list
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              addedUserList.add(user); // Add user to list when checked
                            } else {
                              addedUserList.remove(user); // Remove user from list when unchecked
                            }
                          });
                        },
                      ),
                    ),
                    const Divider(
                      color: Colors.black, // Black divider
                      thickness: 1,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Function for building input column for team name
  Widget buildInputColumn(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration:  InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter $label',
          ),
        ),
      ],
    );
  }
}
