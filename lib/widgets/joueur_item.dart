import 'package:flutter/material.dart';
import 'package:tp02/modele/joueur.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tp02/provider/joueur_provider.dart';

// Map pour associer une catégorie à une ic

// Widget pour afficher un élément dépense dans la liste des dépenses (JoueursList)
class JoueurItem extends ConsumerWidget {

  // L'id de la dépense affichée dans le Widget
  final String joueurId;

  // Constructeur
  const JoueurItem(this.joueurId, {super.key});

  // Construit l'UI du widget JoueurItem
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // On recupère la dépense, grâce à son id, auprès du provider joueurProviderFamily
    Joueur joueur = ref.watch(joueurProvider(joueurId));
    // Et on fabrique une Card pour afficher cette dépense
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              joueur.nom,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 8),
                    Text(joueur.score as String),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
