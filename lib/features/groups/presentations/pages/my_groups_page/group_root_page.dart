import 'package:flutter/material.dart';

class GroupRootPage extends StatefulWidget{
  const GroupRootPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _GroupRootPage();
  }
}

class _GroupRootPage extends State<GroupRootPage>{
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:  _currentIndex,
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.groups)),
          BottomNavigationBarItem(icon: Icon(Icons.explore))
        ]
      ),
    );
  }
}