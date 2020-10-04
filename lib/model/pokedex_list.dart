import 'dart:convert';

import 'package:PokeDex/model/pokemon_detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'pokedex.dart';

class PokemonList extends StatefulWidget {
  @override
  _PokemonListState createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  String url =
      "https://raw.githubusercontent.com/Biuni/PokemonGo-Pokedex/master/pokedex.json";
  Pokedex pokedex;
  Future<Pokedex> veri;

  Future<Pokedex> pokemonlariGetir() async {
    var response = await http.get(url);
    var decoded = json.decode(response.body);
    pokedex = Pokedex.fromJson(decoded);
    return pokedex;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    veri = pokemonlariGetir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("POKEDEX")),
        ),
        body: OrientationBuilder(
          builder: (context, orientation) => Orientation.portrait == orientation
              ? getBody(2, BoxFit.cover)
              : getBody(3, BoxFit.contain),
        ));
  }

  getBody(crossaxiscount, BoxFit fit) {
    return FutureBuilder(
      future: veri,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.done) {
          return GridView.count(
              crossAxisCount: crossaxiscount,
              children: snapshot.data.pokemon
                  .map<Widget>((poke) => InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PokemonDetail(
                              pokemon: poke,
                            ),
                          ));
                        },
                        child: Hero(
                            tag: poke.img,
                            child: Card(
                              color: Colors.cyan[50],
                              elevation: 6,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.height / 5,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: FadeInImage.assetNetwork(
                                      placeholder: "assets/image/loading.png",
                                      image: poke.img,
                                      fit: fit,
                                    ),
                                  ),
                                  Text(
                                    poke.name,
                                    style: TextStyle(
                                        fontSize: 22, color: Colors.black),
                                  )
                                ],
                              ),
                            )),
                      ))
                  .toList());
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
