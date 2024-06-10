import 'package:shared_preferences/shared_preferences.dart';
import 'package:tp02/modele/joueur.dart';
import 'dart:convert';

class Palmares {
   List<Joueur> joueurs;
  static const palmaresKey = 'palamaresKey';

  List<Joueur> get list => joueurs;
  // Constructeur pour fabriquer un Palmares à partir d'une liste de joueurs
  Palmares(this.joueurs);
    // Constructeur pour fabriquer un Palmares vide
  Palmares.empty() : joueurs=[];

    // Charge la liste des dépenses depuis le local storage
  Future<void> load() async {
    final localStorage = await SharedPreferences.getInstance();
    // On charge depuis le local storage le tableau des dépenses au format Json
    List<String> jsonJoueurs = localStorage.getStringList(palmaresKey) ?? [];
    // Et on décode le Json de chaque dépense
    joueurs = jsonJoueurs
        .map((jsonJoueur) => Joueur.fromJson(jsonDecode(jsonJoueur)))
        .toList();
  }

  // Sauvegarde la liste des dépenses dans le local storage
  Future<void> save() async {
    final localStorage = await SharedPreferences.getInstance();
    List<String> jsonExpenses =
        joueurs.map((joueur) => jsonEncode(joueur)).toList();
    localStorage.setStringList(palmaresKey, jsonExpenses);
  }
}
