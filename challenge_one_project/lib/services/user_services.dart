import 'dart:convert';
import 'dart:async'; // Import Timer
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  static final StreamController<List<UserModel>> _usersStreamController = StreamController<List<UserModel>>.broadcast();

  // Fetch users from the API
  static Future<List<UserModel>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<UserModel> test = data.map((dynamic user) => UserModel.fromJson(user)).toList();
      return test;
    } else {
      throw Exception('');
    }
  }

  // Fetch users stream to provide real-time updates
  static Stream<List<UserModel>> fetchUsersStream() {
    _fetchAndUpdateUsers();
        return _usersStreamController.stream;
  }

  // Fetch users and update the stream
  static Future<void> _fetchAndUpdateUsers() async {
    try {
      List<UserModel> users = await fetchUsers();
      _usersStreamController.sink.add(users); // Add fetched data to the stream
    } catch (e) {
      _usersStreamController.sink.addError(e); // In case of error, add an error to the stream
    }
  }

  // Clean up the resources and close the stream
  static void dispose() {
    _usersStreamController.close(); // Close the stream controller
  }

  static void deleteUser(int userId) async {
    final response = await http.delete(Uri.parse('$baseUrl/deleteUser/$userId'));

    if (response.statusCode == 200) {  
      _fetchAndUpdateUsers();
    }
  }

  static Future<void> updateUser(UserModel user) async {
    final body = jsonEncode({
      'user_id': user.userId,
      'first_name': user.firstName,
      'last_name': user.lastName,
      'role': user.role.name,
      'team_name': user.teamName,
    });

    final response = await http.put(
      Uri.parse('$baseUrl/updateUser'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {  
      _fetchAndUpdateUsers();
    }
  }
  

 Future<List<UserModel>> test() async {

    final response = await http.get(
      Uri.parse('$baseUrl/users'),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<UserModel> users = body.map((dynamic item) => UserModel.fromJson(item)).toList();
      return users;
    } else {
      throw Exception("Failed to load users");
    }
  }
}
