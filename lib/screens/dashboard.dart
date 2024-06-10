import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tp02/modele/joueur.dart';
import 'package:tp02/provider/palmares_provider.dart';
import 'package:tp02/widgets/joueur_item.dart';

// Widget pour afficher une liste déroulante de dépenses (ExpenseItem), triée
// Utilise un widget Listview (https://api.flutter.dev/flutter/widgets/ListView-class.html)
// Chaque élément pourra être supprimé (Dismissible) par un balayage
class Dashboard extends ConsumerWidget {
  // Méthode transmise ExpensesScreen pour pouvoir supprimer un joueur
  final void Function(BuildContext context, WidgetRef ref, Joueur joueur) onRemoveJoueur;

  // Constructeur
  const Dashboard({super.key, required this.onRemoveJoueur});

  // Construire l'UI du Widget dashboard
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // La liste des dépenses triée, récupérée auprès de son provider
    final List<Joueur> joueurs = ref.watch(palmaresProvider).joueurs;
    return ListView.builder(
      // On précise le nombre d'éléments dans la liste
      itemCount: joueurs.length,
      // Chaque élément de la liste est ici enveloppé dans un Widget Dismissible
      // (https://api.flutter.dev/flutter/widgets/Dismissible-class.html)
      // Ce Widget permet de réaliser une action lorsque son contenu est balayé
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(joueurs[index]),
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.75),
          margin: EdgeInsets.symmetric(
            horizontal: Theme.of(context).cardTheme.margin!.horizontal,
          ),
        ),
        onDismissed: (direction) {
          onRemoveJoueur(context , ref ,joueurs[index]);
        },
        child: JoueurItem(
          joueurs[index].id,
        ),
      ),
    );
  }
  
}
