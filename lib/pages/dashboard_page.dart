import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poland_quiz/decoration.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:poland_quiz/pages/opening_view.dart';

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
    final mq = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.dashboard),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const OpeningView()),
                    (route) => false);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _controller,
            labelColor: Colors.black,
            tabs: [
              Tab(text: AppLocalizations.of(context)!.posOfVoivodeship),
              Tab(text: AppLocalizations.of(context)!.voivodeshipOnMap),
            ],
          ),
          Expanded(
            child: SizedBox(
              height: mq.size.height / 2,
              child: TabBarView(
                controller: _controller,
                children: const [
                  PositionOfVoivodeshipLeaderboard(),
                  VoivodeshipOnMapLeaderboard(),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            decoration: getDecoration(color: Colors.blue.shade200),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(
                    Icons.emoji_events_outlined,
                    color: Colors.amber,
                    size: 60,
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    child: Text(
                      AppLocalizations.of(context)!.proTip,
                      style: const TextStyle(
                          fontSize: 20, fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VoivodeshipOnMapLeaderboard extends StatelessWidget {
  const VoivodeshipOnMapLeaderboard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(20),
        decoration: getDecoration(),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .orderBy("voivodeship-on-map-lvl", descending: true)
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
                        AppLocalizations.of(context)!
                            .level(doc.get('voivodeship-on-map-lvl')),
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}

class PositionOfVoivodeshipLeaderboard extends StatelessWidget {
  const PositionOfVoivodeshipLeaderboard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(20),
        decoration: getDecoration(),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .orderBy("pos-of-voivodeship-lvl", descending: true)
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
                        AppLocalizations.of(context)!
                            .level(doc.get('pos-of-voivodeship-lvl')),
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}
