

import 'package:uuid/uuid.dart';

// Objet pour forger automatiquement un identifiant unique (String)
const uuid = Uuid();

class Joueur {
  Joueur({required this.nom}) : id = uuid.v4();
  final String id; // Identifiant unique (uuid)
  final String nom;
  int score = 0  ;

  void addScore(score) {
    if (score > this.score) {

    }
  }
    // Construit un objet joueur à partir d'une Map Json (utilisable par jsonDecode)
  Joueur.fromJson(Map<String, dynamic> json) 
  : id=json['id'],
    nom=json['nom'],
    score=json['score'];

  // Convertit un objet Joueur en Map Json (utilisable par jsonEncode)
  Map<String,dynamic> toJson() => {
    'id':id, 
    'nom':nom, 
    'score' :score 
  };
}
