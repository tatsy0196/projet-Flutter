import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tp02/modele/joueur.dart';
import 'package:tp02/provider/palmares_provider.dart';
import 'package:tp02/widgets/grille_demineur.dart';

class EcranGrille extends ConsumerWidget {
  // La fonction du Widget Quiz à appeler pour naviguer vers QuestionScreen
  //final void Function() getDifficulte;
  final int taille;
  final int nbMines;
  final String playerId;

  // Constructeur
  const EcranGrille(
      {required this.taille,
      required this.nbMines,
      required this.playerId,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer(builder: (context, watch, child) {
          // Obtenez le nom du joueur à partir du PalmaresProvider
          final joueurs = ref.watch(palmaresProvider).joueurs;
          final nomJoueur = joueurs.isNotEmpty ? joueurs.last.nom : 'Joueur';

          return Text(nomJoueur);
        }),
      ),
      body:
          GrilleDemineur(taille: taille, nbMines: nbMines),
    );
  }
}
