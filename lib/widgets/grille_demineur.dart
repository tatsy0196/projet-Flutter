import 'package:flutter/material.dart';
import 'package:tp02/modele/case.dart';
import 'package:tp02/modele/coup.dart' as coup;
import 'package:tp02/modele/grille.dart' as modele;
import 'package:tp02/screens/ecran_score.dart';

class GrilleDemineur extends StatefulWidget {
  final int taille, nbMines;
  const GrilleDemineur(
      {required this.taille, required this.nbMines, super.key});
  @override
  State<StatefulWidget> createState() => _GrilleDemineur();
}

class _GrilleDemineur extends State<GrilleDemineur> {
  late modele.Grille _grille;
  bool partieTerminee = false;

  @override
  void initState() {
    _grille = modele.Grille(taille: widget.taille, nbMines: widget.nbMines);

    super.initState();
  }

  List<Widget> addContent() {
    List<Widget> content = [
      Expanded(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.taille,
          ),
          itemCount: widget.taille * widget.taille,
          itemBuilder: (context, index) {
            final row = index ~/ widget.taille;
            final col = index % widget.taille;
            final laCase = _grille.getCase((ligne: row, colonne: col));
            final text = caseToText(laCase, _grille.isFinie());
            final color = caseToColor(laCase);
            return GestureDetector(
              onTap: () {
                if (!partieTerminee) {
                  setState(() {
                    _grille.mettreAJour(
                        coup.Coup(row, col, coup.Action.decouvrir));
                    partieTerminee = _grille.isFinie();
                  });
                }
              },
              onLongPress: () {
                if (!partieTerminee) {
                  setState(() {
                    _grille
                        .mettreAJour(coup.Coup(row, col, coup.Action.marquer));
                    partieTerminee = _grille.isFinie();
                  });
                }
              },
              child: Container(
                color: color,
                child: Center(
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      Text(
        messageEtat(_grille),
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ];
    if (partieTerminee) {
      
      content.add(
        ElevatedButton(
            onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                      builder: (context) =>  EcranScore(
                          score: _grille.getScore(), temps: _grille.getTemps())),
                ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            child: const Text('Voir mon score')),
      );
    }
    return content;
  }

  /// construit l’interface du widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: addContent()),
      ),
    );
  }

  String caseToText(Case laCase, bool isFini) {
    if (isFini) {
      if (laCase.minee) {
        return 'B';
      } else {
        return laCase.nbMinesAutour.toString();
      }
    } else {
      if (laCase.etat == Etat.couverte) {
        return '*';
      } else if (laCase.etat == Etat.marquee) {
        return 'M';
      } else {
        if (laCase.minee) {
          return 'B';
        } else {
          if (laCase.nbMinesAutour == 0) {
            return '';
          } else {
            return laCase.nbMinesAutour.toString();
          }
        }
      }
    }
  }

  Color caseToColor(Case laCase) {
    if (laCase.etat == Etat.decouverte) {
      return Colors.grey;
    } else {
      return Colors.blue;
    }
  }

  String messageEtat(modele.Grille grille) {
    if (grille.isPerdue()) {
      return "BOUM ! DEFAITE !";
    } else if (grille.isGagnee()) {
      return "GG ! VOUS AVEZ GAGNÉ !";
    } else {
      return "Il faut continuer à déminer...";
    }
  }
}
