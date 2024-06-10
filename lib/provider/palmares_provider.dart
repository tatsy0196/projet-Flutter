import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tp02/modele/joueur.dart';
import 'package:tp02/modele/palmares.dart';

final palmaresProvider = StateNotifierProvider<PalmaresNotifier, Palmares>(
    (ref) => PalmaresNotifier());

// Classe héritant de StateNotifier pour gèrer un objet PersistentJoueurs (liste des dépenses)
// L'attribut state est l'état géré par le StateNotifier, ici ce sera donc un objet Palmares
// Le StateNotifier doit fournir des méthodes pour modifier son état
class PalmaresNotifier extends StateNotifier<Palmares> {
  // Constructeur du Notifier
  // On appelle le constructeur de la classe mère en lui transmettant l'état (state)
  // Ici l'état est donc un objet de la classe Palmares
  PalmaresNotifier() : super(Palmares.empty()) {
    // On charge de façon asynchrone le contenu sauvegardé dans le local storage
    // et on crée une nouvelle instance de PersistentJoueurs
    // pour que le changement d'état soit notifié aux abonnées
    state.load().whenComplete(() => state = Palmares(state.joueurs));
  }

  // Méthode qui ajoute une dépense à l'état du Provider
  // Il faut que l'état soit une nouvelle instance de PersistentJoueurs
  // pour que le changement d'état soit notifié aux abonnés
  String addJoueur(Joueur newJoueur) {
    // On ajoute la nouvelle dépense à l'état actuel
    state.joueurs.add(newJoueur);
    // Et on instancie un nouvel objet Palmares (clone de l'état actuel)
    // pour que le changement d'état soit bien pris en compte
    state = Palmares(state.joueurs);
    state.save();
    return newJoueur.id; // Renvoie l'ID du joueur nouvellement créé
  }

  // Méthode qui supprimer une dépense de l'état du Provider
  // Il faut que l'état soit une nouvelle instance de PersistentJoueurs
  // pour que le changement d'état soit notifié aux abonnés
  void removeJoueur(Joueur expenseToRemove) {
    // On supprimer la dépense de l'état actuel
    state.joueurs.removeAt(state.joueurs
        .indexWhere((expense) => expense.id == expenseToRemove.id));
    // Et on instancie un nouvel objet Palmares (clone de l'état actuel)
    // pour que le changement d'état soit bien pris en compte
    state = Palmares(state.joueurs);
    state.save();
  }
}
