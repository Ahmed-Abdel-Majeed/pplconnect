import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pplconnect/features/profile/presentation/pages/profile_page.dart';

import '../../../../core/navigation/app_navigator.dart';
import '../../../home/presentation/main_screen.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _users = [];
  bool _isLoading = false;

  void _searchUser(String username) async {
    setState(() {
      _isLoading = true;
    });

    final result = await FirebaseFirestore.instance
        .collection('Userss')
        .where('userName', isGreaterThanOrEqualTo: username)
        .where('userName', isLessThanOrEqualTo: '$username\uf8ff')
        .get();

    setState(() {
      _users = result.docs;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              setState(() {
                AppNavigator.pushReplacement(context, const MainScreen());
              });
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: TextFormField(
          onChanged: (value) {
            if (value.isNotEmpty) {
              _searchUser(value);
            } else {
              setState(() {
                _users = []; 
              });
            }
          },
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: "Search User...",
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              _searchUser(
                  _searchController.text); 
            },
          ),
        ],
        backgroundColor: Colors.grey.shade900,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Colors.grey.shade900,
              Colors.grey.shade800,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  var user = _users[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Card(
                      color: Colors.grey.shade800,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user['profImg']),
                          backgroundColor: Colors.blueGrey.shade700,
                        ),
                        title: Text(
                          user['userName'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            color: Colors.white70),
                        onTap: () {
                          AppNavigator.push(context, ProfilePage(userId: user["uid"]));
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
