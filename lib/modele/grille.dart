import 'dart:math';
import 'package:tp02/modele/case.dart';
import 'package:tp02/modele/coup.dart';

/// [Grille] de démineur
class Grille {
  late Stopwatch watch;

  /// Dimension de la grille carrée : [taille]x[taille]
  final int taille;

  /// Nombre de mines présentes dans la grille
  final int nbMines;

  /// Attribut privé (_), liste composée [taille] listes de chacune [taille] cases
  final List<List<Case>> _grille = [];

  /// Construit une [Grille] comportant [taille] lignes, [taille] colonnes et [nbMines] mines
  Grille({required this.taille, required this.nbMines}) {
    watch = Stopwatch();
    startWatch();
    int nbCasesACreer = nbCases;
    int nbMinesAPoser = nbMines;
    Random generateur = Random();
    for (int lig = 0; lig < taille; lig++) {
      List<Case> uneLigne = []; //
      for (int col = 0; col < taille; col++) {
        // S'il reste nBMinesAPoser dans nbCasesACreer, la probabilité de miner est nbMinesAPoser/nbCasesACreer
        // Donc on tire un nombre aléatoire a dans [1..nbCasesACreer] et on pose une mine si a <= nbMinesAposer
        bool isMinee = generateur.nextInt(nbCasesACreer) < nbMinesAPoser;
        if (isMinee) nbMinesAPoser--; // une mine de moins à poser
        uneLigne.add(Case(isMinee)); // On ajoute une nouvelle case à la ligne
        nbCasesACreer--; // Une case de moins à créer
      }
      // On ajoute la nouvelle ligne à la grille
      _grille.add(uneLigne);
    }
    // Les cases étant créées et les mines posées, on calcule pour chaque case le 'nombre de mines autour'
    calculeNbMinesAutour();
  }

  /// Getter qui retourne le nombre de cases
  int get nbCases => taille * taille;

  /// Retourne la [Case] de la [Grille] située à [coord]
  Case getCase(Coordonnees coord) {
    return _grille[coord.ligne][coord.colonne];
  }

  /// Retourne la liste des [Coordonnees] des voisines de la case située à [coord]
  List<Coordonnees> getVoisines(Coordonnees coord) {
    List<Coordonnees> listeVoisines = [];
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        int newLigne = coord.ligne + i;
        int newColonne = coord.colonne + j;
        if (newLigne >= 0 &&
            newLigne < taille &&
            newColonne >= 0 &&
            newColonne < taille &&
            (i != 0 || j != 0)) {
          listeVoisines.add((ligne: newLigne, colonne: newColonne));
        }
      }
    }
    return listeVoisines;
  }

  /// Assigne à chaque [Case] le nombre de mines présentes dans ses voisines
  void calculeNbMinesAutour() {
    // A Corriger
    int nbMinesAutour = 0;
    for (int lig = 0; lig < taille; lig++) {
      for (int col = 0; col < taille; col++) {
        if (lig != 0 && _grille[lig - 1][col].minee) {
          nbMinesAutour++;
        }
        if (lig != taille - 1 && _grille[lig + 1][col].minee) {
          nbMinesAutour++;
        }
        if (col != 0 && _grille[lig][col - 1].minee) {
          nbMinesAutour++;
        }
        if (col != taille - 1 && _grille[lig][col + 1].minee) {
          nbMinesAutour++;
        }

        _grille[lig][col].nbMinesAutour = nbMinesAutour;
        nbMinesAutour = 0;
      }
    }
  }

  /// - Découvre récursivement toutes les cases voisines d'une case située à [coord]
  /// - La case située à [coord] doit être découverte
  void decouvrirVoisines(Coordonnees coord) {
    List<Coordonnees> voisines = getVoisines(coord);
    for (Coordonnees voisin in voisines) {
      Case caseVoisine = _grille[voisin.ligne][voisin.colonne];
      if (caseVoisine.etat != Etat.decouverte && !caseVoisine.minee) {
        caseVoisine.decouvrir();
        if (caseVoisine.nbMinesAutour == 0) {
          decouvrirVoisines(voisin);
        }
      }
    }
  }

  /// Met à jour la Grille en fonction du [coup] joué
  void mettreAJour(Coup coup) {
    int ligCase = coup.coordonnees.ligne;
    int colCase = coup.coordonnees.colonne;
    Case caseAct = _grille[ligCase][colCase];

    if (coup.action == Action.decouvrir) {
      _grille[ligCase][colCase].decouvrir();
      if (caseAct.nbMinesAutour == 0) {
        decouvrirVoisines(coup.coordonnees);
      }
    } else {
      _grille[ligCase][colCase].inverserMarque();
    }
  }

  /// Renvoie vrai si [Grille] ne comporte que des cases soit minées soit découvertes (mais pas les 2)
  bool isGagnee() {
    bool gagne = true;
    if (isPerdue()) {
      gagne = false;
    } else {
      for (int lig = 0; lig < taille && gagne; lig++) {
        for (int col = 0; col < taille && gagne; col++) {
          if (_grille[lig][col].minee == false &&
              _grille[lig][col].etat == Etat.couverte) {
            gagne = false;
          }
        }
      }
    }

    return gagne;
  }

  /// Renvoie vrai si [Grille] comporte au moins une case minée et découverte
  bool isPerdue() {
    bool perdu = false;
    for (int lig = 0; lig < taille && !perdu; lig++) {
      for (int col = 0; col < taille && !perdu; col++) {
        if (_grille[lig][col].minee == true &&
            _grille[lig][col].etat == Etat.decouverte) {
          perdu = true;
        }
      }
    }

    return perdu;
  }

  bool isFinie() {
    return isGagnee() || isPerdue();
  }

  void startWatch() {
    watch.start();
  }

  void stopWatch() {
    watch.stop();
  }

  void resetWatch() {
    watch.reset();
  }

  // Calcul du score
  int getScore() {
    stopWatch();
    if (isPerdue()) return 0;

    double coeffTempsParCase = max(
        1.0,
        10000.0 -
            watch.elapsedMilliseconds.toDouble() /
                (taille * taille - nbMines).toDouble());

    double coeffDifficulte =
        100.00 * nbMines.toDouble() / (taille * taille).toDouble();

    return ((taille * taille - nbMines).toDouble() *
            coeffTempsParCase /
            100.0 *
            coeffDifficulte)
        .toInt();
  }

  // Calcul du temps en secondes
  double getTemps() {
    return watch.elapsedMilliseconds.toDouble() / 1000.0;
  }
}
