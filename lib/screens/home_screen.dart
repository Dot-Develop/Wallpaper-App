import 'package:flutter/material.dart';
import 'package:wallyapp/screens/account_screen.dart';
import 'package:wallyapp/screens/explore_screen.dart';
import 'package:wallyapp/screens/favorite_screen.dart';
import 'package:wallyapp/screens/test.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavItemIndex = 0;
  var pages = [ExploreScreen(), FavoriteScreen(), AccountScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WallyApp'),
      ),
      body: pages[_selectedNavItemIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Explore'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            title: Text('Favorites'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Account'),
          ),
        ],
        currentIndex: _selectedNavItemIndex,
        onTap: (index) {
          setState(() {
            _selectedNavItemIndex = index;
          });
        },
      ),
    );
  }
}
