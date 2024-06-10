import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tp02/modele/joueur.dart';
import 'package:tp02/provider/palmares_provider.dart';
import 'package:tp02/screens/ecran_grille.dart';

// Le formulaire pour saisir une nouvelle dépense (ConsumerStatefulWidget)
class EcranAccueilForm extends ConsumerStatefulWidget {
  // Constructeur
  const EcranAccueilForm({super.key});
  // Création de l'état associé au Stateful Widget ExpenseForm
  @override
  ConsumerState<EcranAccueilForm> createState() {
    return EcranAccueil();
  }
}

class EcranAccueil extends ConsumerState<EcranAccueilForm> {
  // Contrôleur du champ texte "nom". Son attribut text contient le texte saisi
  final _nameController = TextEditingController();

  // Validation du formulaire
  void _submitExpenseData(BuildContext context,int taille, int nbMines) {
    // Si le titre est vide, le montant non correct ou la date vide
    //  on montre un dialogue pour demander à l'utilisateur de corriger
    if (_nameController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Saisie Non Valide'),
          content: const Text('Vous devez saisir pseudo valides.'),
          actions: [
            TextButton(
              onPressed: () {
                // on dépile le dialogue de l'UI
                Navigator.pop(ctx);
              },
              child: const Text('Ok'),
            ),
          ],
        ),
      );
    } else {
      // les données du forumaire sont valides : on ajoute une dépense à expensesProvider
      final newJoueur = Joueur(
        nom: _nameController.text,
      );
      String joueurid = newJoueur.id ?? "Killroy";
      ref.watch(palmaresProvider.notifier).addJoueur(newJoueur);
      // On navigue vers la page EcranGrille
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) =>  EcranGrille(
              taille: taille, nbMines: nbMines, playerId: joueurid),
        ),
      );
    }
  }

  // Construction de l'UI du Widget StartScreen
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 120),
            Text(
              'Entrez votre pseudo :',
              style: GoogleFonts.lato(
                color: const Color.fromARGB(255, 237, 223, 252),
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Pseudo',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Text(
              'choix de grille',
              style: GoogleFonts.lato(
                color: const Color.fromARGB(255, 237, 223, 252),
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _submitExpenseData(context,5, 3),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
              ),
                child: const Text('Facile : 5x5 - 3 mines')),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _submitExpenseData(context, 7, 7),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
              ),
                child: const Text('moyen : 7x7 - 7 mines')),
            const SizedBox(height: 30),
              ElevatedButton(
              onPressed: () => _submitExpenseData(context, 10, 10),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
              ),
                child: const Text('difficile :10x10 - 10 mines')),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
