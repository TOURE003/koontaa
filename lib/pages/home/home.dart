import 'package:flutter/material.dart';
import 'package:koontaa/functions/firebase_auth.dart';
import 'package:koontaa/functions/fonctions.dart';
import 'package:koontaa/pages/compte/connection/compte.dart';
import 'package:koontaa/pages/compte/connection/page_connection.dart';
import 'package:koontaa/pages/recherche/recherche.dart';

int nbrPageActif = 0;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  bool _showAppBar = true;
  bool _showBottomBar = true;
  double _lastOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    if (offset > _lastOffset && offset - _lastOffset > 5) {
      // Scroll vers le bas
      if (_showAppBar || _showBottomBar) {
        setState(() {
          _showAppBar = false;
          _showBottomBar = false;
        });
      }
    } else if (offset < _lastOffset && _lastOffset - offset > 5) {
      // Scroll vers le haut
      if (!_showAppBar || !_showBottomBar) {
        setState(() {
          _showAppBar = true;
          _showBottomBar = true;
        });
      }
    }
    _lastOffset = offset;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _showAppBar
          ? AppBar(title: const Text('Vidéo & contenu'), elevation: 0)
          : null,

      body: Stack(
        children: [
          NotificationListener<UserScrollNotification>(
            onNotification: (_) => true,
            child: ListView(
              controller: _scrollController,
              children: [
                nbrPageActif == 2
                    ? pageCompte(context, () {
                        setState(() {});
                      })
                    : SizedBox(),
                /*Container(
                  height: 250,
                  color: Colors.black,
                  alignment: Alignment.center,
                  child: const Text(
                    "🎬 Vidéo ici",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                for (int i = 0; i < 20; i++)
                  ListTile(title: Text('Contenu $i')),*/
              ],
            ),
          ),

          // BottomAppBar animé
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 300),
              offset: _showBottomBar ? Offset.zero : const Offset(0, 1),
              curve: Curves.easeInOut,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _showBottomBar ? 1.0 : 0.0,
                child: BottomAppBar(
                  shape: const CircularNotchedRectangle(inverted: true),
                  notchMargin: 8,
                  elevation: 10,
                  color: couleurDeApp(), // ta fonction de couleur
                  child: SizedBox(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.home),
                          color: Colors.grey,
                          onPressed: () {
                            setState(() {
                              nbrPageActif = 0;
                            });
                          },
                        ),
                        const SizedBox(width: 40),
                        IconButton(
                          icon: const Icon(Icons.person),
                          color: Colors.grey,
                          onPressed: () {
                            if (AuthFirebase().currentUser != null) {
                              setState(() {
                                nbrPageActif = 2;
                              });
                            } else {
                              changePage(
                                context,
                                PageConnection(title: "Connection"),
                              );
                              return;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // Floating button reste visible
      floatingActionButton: Transform.translate(
        offset: const Offset(0, 0), // vers le haut de 20 pixels
        child: FloatingActionButton(
          onPressed: () {
            // Action panier
          },
          backgroundColor: Colors.red,
          elevation: 8,
          shape: const CircleBorder(),
          child: const Icon(Icons.shopping_cart, size: 30, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

Widget iconAvecNum(IconData typeIcone, int numn, Color couleur) {
  if (numn == 0) {
    return Icon(typeIcone, color: couleur);
  } else {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(typeIcone, color: couleur), // Icône de base
        // Le badge
        Positioned(
          right: -6,
          top: -6,
          child: Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.red, // Couleur du badge
              shape: BoxShape.circle,
            ),
            child: Text(
              '$numn', // Le nombre à afficher
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget rechercheFactis(context) {
  return GestureDetector(
    onTap: () {
      changePage(context, const Recherche(title: "Page de Récherche"));
    },
    child: Container(
      height: 36,
      width: 550,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 220, 211, 198),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: const [
          Icon(Icons.search, color: Color.fromARGB(255, 62, 62, 62)),
          SizedBox(width: 10),
          Text(
            "Rechercher...",
            style: TextStyle(
              color: Color.fromARGB(255, 47, 46, 46),
              fontSize: 16,
            ),
          ),
        ],
      ),
    ),
  );
}
