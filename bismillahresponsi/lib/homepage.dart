import 'package:flutter/material.dart';
import 'package:bismillahresponsi/base_network.dart';
import 'package:bismillahresponsi/matches_model.dart';

import 'detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Piala Dunia 2022"),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: FutureBuilder(
          future: BaseNetwork.getList("matches"),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingSection();
            } else if (snapshot.hasError) {
              debugPrint(snapshot.toString());
              return _buildErrorSection();
            } else if (snapshot.hasData) {
              MatchesDataModel matchesModel =
                  MatchesDataModel.fromJson(snapshot.data);
              return _buildSuccessSection(matchesModel);
            } else {
              return const ListTile(
                title: Text("Data tidak dapat ditemukan"),
              );
            }
          },
        ),
        // _buildSuccessSection(),
      ),
    );
  }

  Widget _buildErrorSection() {
    return const Text("Error");
  }

  Widget _buildLoadingSection() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSuccessSection(MatchesDataModel data) {
    return ListView.builder(
        itemCount: 48,
        itemBuilder: (BuildContext context, int index) {
          final MatchesModel? match = data.matches?[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Detail(match: match)));
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              elevation: 0.3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _countryBuilder(match?.homeTeam?.name),
                  Text(
                      " ${match?.homeTeam?.goals} - ${match?.awayTeam?.goals} "),
                  _countryBuilder(match?.awayTeam?.name),
                ],
              ),
            ),
          );
        });
  }

  Widget _countryBuilder(String? name) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade400, spreadRadius: 1, blurRadius: 8)
            ],
          ),
          child: Image.network(
            "https://countryflagsapi.com/png/${(name == "Korea Republic" ? 'kor' : name)}",
            width: MediaQuery.of(context).size.width / 3,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
        ),
        Text(
          "$name",
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
