import 'package:flutter/material.dart';
import 'package:tp02/screens/ecran_accueil.dart';

class Demineur extends StatefulWidget {
  const Demineur({super.key});
  @override
  State<Demineur> createState() {
    return _DemineurState();
  }
}

// Les différents types de Screen à afficher
enum ScreenState { accueil, grille, score }

class _DemineurState extends State<Demineur> {
  // Le choix de grille du joueur
  List difficulteGrille = [];
  // Le score du joueur par le joueur
  int score = 0;
  // Pour savoir quel widget afficher
  ScreenState screenState = ScreenState.accueil;
  // StopWatch
  final stopWatch = Stopwatch();

  // Méthode appelée depuis StartScreen pour "naviguer" vers QuestionsScreen
  // void showGrille(int taille, int nbBombe) {
  //   setState(() {
  //     score = 0; // on vide la liste des réponses
  //     difficulteGrille = [taille, nbBombe];
  //     screenState = ScreenState.grille; // on va afficher QuestionScreen
  //   });
  // }
  // Retourne le widget à afficher selon l'état (valeur de screenState)
  // Widget chooseScreenWidget() {
  //   switch (screenState) {
  //     case ScreenState.accueil:
  //       {
  //         return EcranAccueil(showGrille : showGrille);
  //       }
  //     case ScreenState.grille:
  //       {
  //         return EcranGrille(
  //           theQuestions: theQuestions,
  //           onSelectAnswer: chooseAnswer,
  //         );
  //       }
  //     case ScreenState.score:
  //       {
  //         return  EcranAccueil(showGrille: showGrille);
  //       }
  //   }
  // }
    // Construction de l'UI du Widget Quiz
    
  @override
  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(139, 78, 13, 151),
                Color.fromARGB(81, 107, 15, 168),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const EcranAccueilForm(),
        ),
      ),
    );
  }
}
