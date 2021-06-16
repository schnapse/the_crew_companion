import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:the_crew_companion/views/playGame.dart';

import '../constant.dart';
import '../controller.dart';
import '../entities/team.dart';
import 'components/menu.dart';
import 'components/teamListComponents.dart';
import 'teamCreation.dart';
import 'teamStats.dart';

class TeamList extends StatefulWidget {
  TeamList(
      {Key? key,
      required this.title,
      required this.controller})
      : super(key: key);

  final String title;
  final Controller controller;
  
  @override
  _TeamListState createState() => _TeamListState();
}

class _TeamListState extends State<TeamList> {
  void _addTeam() async {
    final newTeam = Team();
    final created = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => TeamCreation(team: newTeam)));
    if (created == true) {
      widget.controller.teams.add(newTeam);
      await widget.controller.saveDatas();
      setState(() {}); //refresh UI
    }
  }

  void _editTeam(Team team) async {
    final edited = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => TeamCreation(team: team)));
    if (edited == true) {
      await widget.controller.saveDatas();
      setState(() {}); //refresh UI
    }
  }

  void _goToStats(Team team) async {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => TeamStats(team: team)));
  }

  void _removeTeam(Team team) async {
    bool confirmed = await confirm(context,
        content:
            Text("Voulez vous vraiment supprimer l'équipe " + team.name + " ?"),
        textOK: Text("Oui"),
        textCancel: Text("Non"),
        title: Text("Suppression de l'équipe"));
    if (confirmed == true) {
      widget.controller.teams.remove(team);
      await widget.controller.saveDatas();
      setState(() {});
    }
  }

  void _play(Team team) async {
    await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => PlayGame(controller: widget.controller, team: team)));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Menu(controller: widget.controller),
      appBar: AppBar(
        title:  Text(widget.title),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(top: defaultPadding/2),
        child: Column(
          children: [
            Expanded(
              child: new ListView.builder(
                itemCount: widget.controller.teams.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  final team = widget.controller.teams[index];
                  return Container(
                    padding: EdgeInsets.fromLTRB(defaultPadding, defaultPadding/2, defaultPadding, defaultPadding/2),
                    child: OutlinedButton(
                      onPressed: (){
                        _play(team);
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Theme.of(context).backgroundColor.withOpacity(0.30),
                        padding: EdgeInsets.all(defaultPadding),
                        elevation: 10,
                        side: BorderSide(
                          width: 2,
                          color: primaryColor.withOpacity(0.70),
                        ),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TeamName(team: team),
                                TeamPlayers(team: team),
                                TeamProgress(team: team)
                              ],
                            )
                          ),
                          Expanded(
                            flex: 1,
                            child: PopupMenuButton(
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    child: Text("Editer l'équipe"),
                                    value: 1,
                                  ),
                                  PopupMenuItem(
                                    child: Text(
                                        "Voir les statistiques l'équipe"),
                                    value: 2,
                                  ),
                                  PopupMenuItem(
                                    child: Text("Supprimer l'équipe"),
                                    value: 3,
                                  ),
                                ];
                              },
                              icon: Icon(Icons.more_vert,
                                  color: Colors.white54),
                              onSelected: (value) async {
                                switch (value) {
                                  case 1:
                                    _editTeam(team);
                                    break;
                                  case 2:
                                    _goToStats(team);
                                    break;
                                  case 3:
                                    _removeTeam(team);
                                    break;
                                }
                              },
                            ),
                          )
                        ],
                      )
                    )
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTeam,
        tooltip: 'Ajouter une équipe',
        child: Icon(Icons.add),
      ),
    );
  }
}