import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/player_model2.dart';

class PlayersListPage extends StatefulWidget {
  @override
  _PlayersListPageState createState() => _PlayersListPageState();
}

class _PlayersListPageState extends State<PlayersListPage> {
  late Future<PlayersResponseModel> futurePlayers;

  @override
  void initState() {
    super.initState();
    futurePlayers = fetchPlayers();
  }

  Future<PlayersResponseModel> fetchPlayers() async {
    final String apiUrl = 'https://api-football-v1.p.rapidapi.com/v2/players/squad/96/2023';
    final String apiKey = 'c8eabf52ebd3704dec98cbda88516473'; // Remplacer par votre clé d'API valide

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'x-rapidapi-host': 'api-football-v1.p.rapidapi.com',
        'x-rapidapi-key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return PlayersResponseModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load players: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Joueurs'),
      ),
      body: Center(
        child: FutureBuilder<PlayersResponseModel>(
          future: futurePlayers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Erreur: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.players.isEmpty) {
              return Text('Aucun joueur trouvé');
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.players.length,
                itemBuilder: (context, index) {
                  var player = snapshot.data!.players[index];
                  return ListTile(
                    title: Text(player.name),
                    subtitle: Text(player.nationality),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}