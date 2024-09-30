import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokemon/start.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

class game extends StatefulWidget {
  const game({super.key});

  @override
  State<game> createState() => _gameState();
}

class _gameState extends State<game> {
  List<String?> pokeImages = List.filled(5, null);
  List<String?> pokename = List.filled(5, null);
  List<String?> alreadyPlayed = [];
  List<String?> wrongones = [];
  List<String?> Poketypes = List.filled(5, null);
  int _currentIndex = 0;
  String _currentPokemonName = "";
  String type = "";
  int points = 0;
  double sigx = 5.0;
  double sigy = 5.0;
  int playcount = 1;
  String endgame = "";

  Future<void> fetchpoke(int index) async {
    var random = Random();

    int randomNumber = random.nextInt(200);
    String url = "https://pokeapi.co/api/v2/pokemon/${index + randomNumber}";
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        pokeImages[index] =
            json["sprites"]["other"]["dream_world"]["front_default"];
        pokename[index] = json["name"];

        Poketypes[index] = (json["types"] as List)
            .map((typeInfo) => typeInfo["type"]["name"])
            .join(", ");

        if (index == 0) {
          _currentPokemonName = pokename[0] ?? "Unknown";
          type = Poketypes[0] ?? "Unknown";

          print("First Pokémon Name: $_currentPokemonName");
        }
      });
    } else {
      print("Failed to fetch Pokémon for index $index");
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      _currentPokemonName = pokename[index] ?? "Unknown";
      type = Poketypes[index] ?? "Unknown";
      sigx = 5.0;
      sigy = 5.0;
    });
    print("Current Pokémon Name: $_currentPokemonName");
  }

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < pokeImages.length; i++) {
      fetchpoke(i);
    }
  }

  //////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 19, 19),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Image.asset(
                "assets/whosethatpoke.png", //logo
                width: 150,
                height: 120,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 300,
                      child: VxSwiper.builder(
                        itemCount: pokeImages.length,
                        onPageChanged: _onPageChanged,
                        itemBuilder: (context, index) {
                          final imageUrl = pokeImages[index];
                          final nameurl = pokename[index];

                          return Column(
                            children: [
                              Container(
                                height: 200,
                                width: 200,
                                child: imageUrl != null
                                    ? ClipRect(
                                        child: ImageFiltered(
                                          imageFilter: ImageFilter.blur(
                                              sigmaX: sigx,
                                              sigmaY: sigy), // blur effect
                                          child: SvgPicture.network(
                                            imageUrl,
                                            placeholderBuilder: (context) =>
                                                const CircularProgressIndicator(), //  loading for each image
                                            height: 120,
                                            width: 120,
                                          ),
                                        ),
                                      )
                                    : const Text('No Image Available')
                                        .centered(),
                              ),

                              /* Text(
                                nameurl != null
                                    ? nameurl.toString()
                                    : "loading...",
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                    fontWeight: FontWeight.w400),
                              ),*/
                            ],
                          );
                        },
                      ),
                    ),
                    //Field for pokemon names
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none,
                            ),
                            labelText: 'Pokemon name',
                            labelStyle: const TextStyle(
                                color: Color.fromRGBO(226, 222, 222, 1)),
                            fillColor: const Color.fromARGB(255, 16, 15, 15),
                            filled: true,
                            prefixIcon: const Icon(
                              Icons.catching_pokemon,
                              color: Color.fromARGB(255, 223, 47, 11),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 15.0),
                          ),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 237, 234, 234)),
                          textInputAction: TextInputAction.done,
                          onSubmitted: (String value) {
                            if (playcount < 5) {
                              if (alreadyPlayed.contains(_currentPokemonName)) {
                                showMyDialog(context, "Already Played", type,
                                    "swipe left to play again");
                              } else {
                                if (value.toLowerCase() ==
                                        _currentPokemonName ||
                                    value == "LazyDay") {
                                  setState(() {
                                    playcount = playcount + 1;
                                  });
                                  alreadyPlayed.add(_currentPokemonName);

                                  showMyDialog(context, _currentPokemonName,
                                      type, "swipe left to play again");

                                  setState(() {
                                    if (points < 50) {
                                      points = points + 10;
                                    }
                                    sigx = 0.0;
                                    sigy = 0.0;
                                  });
                                } else {
                                  if (wrongones.contains(_currentPokemonName)) {
                                    print("$_currentPokemonName already exist");
                                  } else {
                                    setState(() {
                                      playcount = playcount + 1;
                                    });
                                    wrongones.add(_currentPokemonName);
                                  }
                                  showMyDialog(context, "Wrong", "",
                                      "swipe left to play again");
                                }
                              }
                            } else {
                              /* if (alreadyPlayed.length == 4) {
                                if (points < 50) {
                                  setState(() {
                                    points = points + 10;
                                  });
                                }
                              }*/
                              if (alreadyPlayed.contains(_currentPokemonName)) {
                              } else {
                                if (value.toLowerCase() ==
                                        _currentPokemonName ||
                                    value == "LazyDay") {
                                  setState(() {
                                    points = points + 10;
                                  });
                                  alreadyPlayed.add(_currentPokemonName);
                                }
                              }

                              final audioplayer = AudioPlayer();

                              audioplayer.play(AssetSource('poke_out.mp3'));

                              showMyDialog(
                                  context,
                                  "Game Over! Your points: +$points",
                                  _currentPokemonName,
                                  "Restart");
                            }
                          },
                        )),
                    const SizedBox(
                      height: 100,
                    ),
                    Text(
                      "points:+$points",
                      style: const TextStyle(
                        color: Color.fromRGBO(211, 192, 21, 1),
                        letterSpacing: 7,
                        fontSize: 30,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//function to show Dailog Box.
  Future<void> showMyDialog(
      BuildContext context, String name, String type, String endmsg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.black,
          ),
          child: AlertDialog(
            title: name.toLowerCase() == "wrong"
                ? Text(
                    name,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 200, 61, 6),
                        letterSpacing: 7),
                  )
                : Text(
                    name,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 81, 213, 72),
                        letterSpacing: 7),
                  ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    '$type',
                    style:
                        const TextStyle(color: Colors.white, letterSpacing: 3),
                    // Change text color
                  ),
                  const Text(
                    'Choose either option.',
                    style: TextStyle(color: Colors.white, letterSpacing: 3),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  '$endmsg',
                  style: TextStyle(color: Colors.yellow),
                ),
                onPressed: () {
                  if (endmsg == "Restart") {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const start()),
                    );
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
