import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tp02/modele/joueur.dart';
import 'package:tp02/provider/palmares_provider.dart';
import 'package:tp02/screens/dashboard.dart';

class EcranScore extends ConsumerWidget {
  // La fonction du Widget Quiz à appeler pour naviguer vers QuestionScreen
  final int score;
  final double temps;

  // Constructeur
  const EcranScore({required this.score, required this.temps, super.key});
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
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 120),
            Text(
              'vous avez finie en $temps',
              style: GoogleFonts.lato(
                color: Color.fromARGB(255, 19, 19, 180),
                fontSize: 24,
              ),
            ),
            Text(
              'vous avez finie avec $score point',
              style: GoogleFonts.lato(
                color: Color.fromARGB(255, 19, 19, 180),
                fontSize: 24,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Retour à l'accueil en faisant deux pop
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Retour à l\'accueil'),
            ),
            ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => Dashboard(onRemoveJoueur: _RemoveJoueur),
                ),
              );
            },
            child: const Text('dashboard'),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

void _RemoveJoueur(BuildContext context, WidgetRef ref, Joueur joueur) {
    // On supprime le joueur (modification d'état global)
    ref.watch(palmaresProvider.notifier).removeJoueur(joueur);
    // On efface les éventuelles SnackBars affichées
    ScaffoldMessenger.of(context).clearSnackBars();
    // On montre la SnackBar qui informe de la suppression et permet de l'annuler
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Joueur supprimée.'),
        action: SnackBarAction(
          label: 'Annuler',
          onPressed: () {
            // Si annulation, on rajoute le joueur qui venait d'être supprimée
            ref.watch(palmaresProvider.notifier).addJoueur(joueur);
          },
        ),
      ),
    );
  }

}
