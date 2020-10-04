import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'pokedex.dart';

class PokemonDetail extends StatefulWidget {
  Pokemon pokemon;

  PokemonDetail({this.pokemon});
  @override
  _PokemonDetailState createState() => _PokemonDetailState();
}

class _PokemonDetailState extends State<PokemonDetail> {
  PaletteGenerator paletteGenerator;
  Color baskinrenk;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    baskinrenk = Colors.transparent;
    baskinRengiBul();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Theme(
      data: Theme.of(context).copyWith(primaryColor: baskinrenk),
      child: Scaffold(
          backgroundColor: baskinrenk,
          appBar: AppBar(
            title: Align(
                alignment: Alignment(-0.3, 0),
                child: Text(widget.pokemon.name.toUpperCase())),
          ),
          body: OrientationBuilder(
              builder: (context, orientation) =>
                  orientation == Orientation.portrait
                      ? getDikey(size)
                      : getYatay(context))),
    );
  }

  Widget dividerCard(String text,
      {double fontSize = 14, FontWeight fontWeight = FontWeight.normal}) {
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
        ),
        getDivider()
      ],
    );
  }

  Widget getGroupQuality(String types, List<dynamic> liste, bool divider,
      {double titlefontSize = 20,
      fontWeight = FontWeight.normal,
      double boxheight = 5,
      double chipfontsize = 20,
      double dividerheight = 11}) {
    List<Widget> widget_list;
    bool hasList = false;
    if (liste != null) {
      widget_list = liste
          .map(
            (e) => Chip(
              label: Text(
                liste.contains(widget.pokemon.type)
                    ? e.toString()
                    : e.toString().substring(e.toString().indexOf(".") + 1),
                style: TextStyle(fontSize: chipfontsize),
              ),

              //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          )
          .toList();
      hasList = true;
    }

    return Column(
      children: [
        Text(types,
            style: TextStyle(fontSize: titlefontSize, fontWeight: fontWeight)),
        SizedBox(
          height: boxheight,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: hasList ? widget_list : [Text("Has not $types")],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ),
        divider ? getDivider(height: dividerheight) : SizedBox()
      ],
    );
  }

  Widget getDivider({double height = 11}) {
    return Divider(
      height: height,
      color: baskinrenk,
      thickness: 1,
    );
  }

  getDikey(size) {
    return Stack(
      children: [
        Positioned(
          height: size.height / 1.3,
          width: size.width / 1.4,
          top: size.height / 15,
          left: size.width / 7,
          child: Card(
            shadowColor: Colors.cyan[300],
            elevation: 6,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height / 10,
                  ),
                  dividerCard("Height:${widget.pokemon.height}", fontSize: 20),
                  dividerCard("Weight:${widget.pokemon.weight}", fontSize: 20),
                  getGroupQuality("Types", widget.pokemon.type, true),
                  getGroupQuality(
                      "Next Evolution", widget.pokemon.nextEvolution, true),
                  getGroupQuality(
                      "Prev Evolution", widget.pokemon.prevEvolution, true),
                  getGroupQuality("Weekness", widget.pokemon.weaknesses, false),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment(0, -1.1),
          child: Hero(
              tag: widget.pokemon.img,
              child: Container(
                width: size.height / 5,
                height: size.height / 5,
                child: Image.network(
                  widget.pokemon.img,
                  fit: BoxFit.cover,
                ),
              )),
        )
      ],
    );
  }

  getYatay(context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: Hero(
                tag: widget.pokemon.img,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: Image.network(
                    widget.pokemon.img,
                    fit: BoxFit.cover,
                  ),
                )),
            flex: 2,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  dividerCard("Height:${widget.pokemon.height}", fontSize: 12),
                  dividerCard("Weight:${widget.pokemon.weight}", fontSize: 12),
                  getGroupQuality("Types", widget.pokemon.type, true,
                      titlefontSize: 10,
                      fontWeight: FontWeight.bold,
                      chipfontsize: 10,
                      dividerheight: 0.5),
                  getGroupQuality(
                      "Next Evolution", widget.pokemon.nextEvolution, true,
                      titlefontSize: 10,
                      fontWeight: FontWeight.bold,
                      chipfontsize: 10,
                      dividerheight: 0.5),
                  getGroupQuality(
                      "Prev Evolution", widget.pokemon.prevEvolution, true,
                      titlefontSize: 10,
                      fontWeight: FontWeight.bold,
                      chipfontsize: 10,
                      dividerheight: 0.5),
                  getGroupQuality("Weekness", widget.pokemon.weaknesses, false,
                      titlefontSize: 10,
                      fontWeight: FontWeight.bold,
                      chipfontsize: 10,
                      dividerheight: 0.5),
                ],
              ),
            ),
            flex: 3,
          )
        ],
      ),
    );
  }

  void baskinRengiBul() {
    Future<PaletteGenerator> fPaletGenerator =
        PaletteGenerator.fromImageProvider(NetworkImage(widget.pokemon.img));
    fPaletGenerator.then((value) {
      paletteGenerator = value;
      debugPrint(
          "secilen renk:" + paletteGenerator.dominantColor.color.toString());
      setState(() {
        baskinrenk = paletteGenerator.dominantColor.color;
      });
    });
  }
}
