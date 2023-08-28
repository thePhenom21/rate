import 'package:flutter/material.dart';
import 'package:rate/views/ProfilePage.dart';
import 'package:rate/views/SearchPage.dart';

import '../models/RateUser.dart';

class HomePage extends StatefulWidget {
  RateUser? user;
  HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController? tabController;
  int lastPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(controller: tabController, children: [
        ProfilePage(
          user: widget.user!,
        ),
        const SearchPage(),
      ]),
      floatingActionButton: FloatingActionButton.small(
        shape: const CircleBorder(),
        onPressed: () {
          setState(() {
            tabController!.index = 1;
            lastPage = 0;
          });
        },
        child: const Icon(Icons.search),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  setState(() {
                    tabController!.index = 0;
                    lastPage = 1;
                  });
                },
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      tabController!.index = lastPage;
                    });
                  },
                  icon: const Icon(Icons.arrow_back))
            ],
          )),
    );
  }
}
