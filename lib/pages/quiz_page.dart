import 'package:flutter/material.dart';
import 'package:poland_quiz/geojson.dart';
import 'package:poland_quiz/infojson.dart';
import 'package:poland_quiz/quizes/voivodeship_on_map.dart';
import 'package:poland_quiz/quizes/position_of_voivodeship.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuizPage extends StatelessWidget {
  final GeoJson geoJson;
  final InfoJson infoJson;
  const QuizPage({super.key, required this.geoJson, required this.infoJson});

  @override
  Widget build(BuildContext context) {
    var usersCollection = FirebaseFirestore.instance.collection('Users');
    String userId = FirebaseAuth.instance.currentUser!.uid.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.quizSelectionPage),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: usersCollection.doc(userId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            int positionOfVoivodeshipLevel = data['pos-of-voivodeship-lvl'];
            int voivodeshipOnMapLevel = data['voivodeship-on-map-lvl'];
            return Quizes(
              geoJson: geoJson,
              infoJson: infoJson,
              positionOfVoivodeshipLevel: positionOfVoivodeshipLevel,
              voivodeshipOnMapLevel: voivodeshipOnMapLevel,
            );
          }
        },
      ),
    );
  }
}

class Quizes extends StatefulWidget {
  const Quizes({
    Key? key,
    required this.geoJson,
    required this.infoJson,
    required this.positionOfVoivodeshipLevel,
    required this.voivodeshipOnMapLevel,
  }) : super(key: key);

  final GeoJson geoJson;
  final InfoJson infoJson;
  final int positionOfVoivodeshipLevel;
  final int voivodeshipOnMapLevel;

  @override
  State<Quizes> createState() => _QuizesState();
}

class _QuizesState extends State<Quizes> {
  late int _positionOfVoivodeshipLevel;
  late int _voivodeshipOnMapLevel;

  @override
  void initState() {
    super.initState();
    _positionOfVoivodeshipLevel = widget.positionOfVoivodeshipLevel;
    _voivodeshipOnMapLevel = widget.voivodeshipOnMapLevel;
  }

  void updatePositionOfVoivodeshipLevel(int level) {
    if (mounted) {
      setState(() {
        _positionOfVoivodeshipLevel = level;
      });
    }

    String userId = FirebaseAuth.instance.currentUser!.uid.toString();
    var usersCollection = FirebaseFirestore.instance.collection('Users');
    usersCollection.doc(userId).update({
      'pos-of-voivodeship-lvl': level,
    });
  }

  void updateVoivodeshipOnMapLevel(int level) {
    if (mounted) {
      setState(() {
        _voivodeshipOnMapLevel = level;
      });
    }

    String userId = FirebaseAuth.instance.currentUser!.uid.toString();
    var usersCollection = FirebaseFirestore.instance.collection('Users');
    usersCollection.doc(userId).update({
      'voivodeship-on-map-lvl': level,
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 20,
            child: Text(
              '$_voivodeshipOnMapLevel',
            ),
          ),
          title: Text(AppLocalizations.of(context)!.voivodeshipOnMap),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => VoivodeshipOnMapQuiz(
                  data: widget.geoJson,
                  info: widget.infoJson,
                  initialHp: 3,
                  optionsCount: 4,
                  level: _voivodeshipOnMapLevel,
                  nextLevelCallback: updateVoivodeshipOnMapLevel,
                ),
              ),
            );
          },
        ),
        ListTile(
          leading: CircleAvatar(
            radius: 20,
            child: Text(
              '$_positionOfVoivodeshipLevel',
            ),
          ),
          title: Text(AppLocalizations.of(context)!.posOfVoivodeship),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PositionOfVoivodeship(
                  data: widget.geoJson,
                  info: widget.infoJson,
                  initalHp: 3,
                  level: _positionOfVoivodeshipLevel,
                  nextLevelCallback: updatePositionOfVoivodeshipLevel,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
