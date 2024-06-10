import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tp02/provider/palmares_provider.dart';
import 'package:tp02/modele/joueur.dart';

// Provider 'paramétré' (Family) pour accéder à un joueur parmi les joueurs fournies par JoueursProvider
// Ce provider est donc abonné à JoueursProvider et sera notifié quand celui-ci change d'état
final joueurProvider = Provider.family<Joueur, String>((ref, joueurId) {
  // En faisant un "watch" sur joueursProvide, on s'abonne à ce Provider
  final joueurs = ref.watch(palmaresProvider).joueurs;
  return joueurs.firstWhere((joueur) => joueur.id == joueurId);
});
