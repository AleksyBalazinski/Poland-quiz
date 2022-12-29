import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poland_quiz/decoration.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _controller,
            labelColor: Colors.black,
            tabs: const [
              Tab(text: 'Position of voivodeship'),
              Tab(text: 'Voivodeship on map'),
            ],
          ),
          SizedBox(
            height: 200,
            child: TabBarView(
              controller: _controller,
              children: [
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(20),
                    decoration: getDecoration(),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Users')
                          .orderBy("pos-of-voivodeship-lvl")
                          .limit(15)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListView(
                            children: snapshot.data!.docs.map((doc) {
                              return Card(
                                child: ListTile(
                                  title: Text(
                                    doc.get('user-name') as String,
                                  ),
                                  trailing: Text(
                                    'level ${doc.get('pos-of-voivodeship-lvl')}',
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(20),
                    decoration: getDecoration(),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Users')
                          .orderBy("voivodeship-on-map-lvl")
                          .limit(15)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListView(
                            children: snapshot.data!.docs.map((doc) {
                              return Card(
                                child: ListTile(
                                  title: Text(
                                    doc.get('user-name') as String,
                                  ),
                                  trailing: Text(
                                    'level ${doc.get('voivodeship-on-map-lvl')}',
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
