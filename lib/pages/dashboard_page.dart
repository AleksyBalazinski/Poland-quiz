import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:poland_quiz/decoration.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          SizedBox(
            height: mq.size.height / 2,
            child: TabBarView(
              controller: _controller,
              children: const [
                PositionOfVoivodeshipLeaderboard(),
                VoivodeshipOnMapLeaderboard(),
              ],
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
