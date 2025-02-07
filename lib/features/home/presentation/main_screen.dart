// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pplconnect/features/home/presentation/pages/home_page.dart';
import 'package:pplconnect/features/profile/presentation/pages/profile_page.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/user_provider.dart';
import '../../favorite/pages/favorite.dart';
import '../../posts/presentation/pages/add_post.dart';
import '../../search/presentation/pages/search.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getDataFromDB();
  }

  getDataFromDB() async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();
  }

  final PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CupertinoTabBar(
        onTap: (index) {
          _pageController.jumpToPage(index);
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.black,
        items: [
          buildBottomNavigationBarItem(Icons.home, 0),
          buildBottomNavigationBarItem(Icons.search, 1),
          buildBottomNavigationBarItem(Icons.add, 2),
          buildBottomNavigationBarItem(Icons.favorite, 3),
          buildBottomNavigationBarItem(Icons.person, 4),
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          HomePage(),
          Search(),
          AddPost(),
          Favorite(),
          ProfilePage(userId: FirebaseAuth.instance.currentUser!.uid),
        ],
      ),
    );
  }

  BottomNavigationBarItem buildBottomNavigationBarItem(
      IconData icon, int index) {
    return BottomNavigationBarItem(
      label: "",
      icon: Icon(
        icon,
        color: _selectedIndex == index ? Colors.white : Colors.grey,
      ),
    );
  }
}
