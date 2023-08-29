import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rate/providers/providers.dart';
import 'package:rate/views/LoginPage.dart';
import 'package:rate/views/ProfilePage.dart';
import 'package:rate/views/SearchPage.dart';

import '../models/RateUser.dart';

class HomePage extends ConsumerStatefulWidget {
  HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  TabController? tabController;
  int lastPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    tabController = tabController ?? TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            FirebaseAuth.instance.authStateChanges().listen((event) {
              ref
                  .read(messageProvider.notifier)
                  .update((state) => "Signed out!");
              ref.read(colorProvider.notifier).update((state) => false);
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()));
            });
          },
        ),
      ),
      body: TabBarView(controller: tabController, children: [
        ProfilePage(),
        SearchPage(),
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
