# Jeu du snake

Projet d'architecture des ordinateurs 2021.

## Présentation

Le but de ce projet est d’implémenter un petit jeu populaire : le snake.

A titre de rappel, le principe du jeu repose sur le contrôle d’une longue ligne semblable à un serpent en se basant sur un système de scoring : il s’agit d’obtenir le meilleur score possible à chaque partie.
Pour cela, il est nécessaire de faire grandir son serpent le plus possible en mangeant des pastilles de nourriture disséminées dans l’environnement. Le jeu prend fin lorsque le serpent heurte un obstacle, un bord de l’écran ou son propre corps.

Le code sera réaliséen assembleur **MIPS**, et exécuté grâce à l’émulateur _Mars_.

## Délai

Ce projet est à rendre avant le **5 décembre 2021 à 23h59**.

## Exécution

L'émulateur Mars se lance à partir de l’archive javaMars4\*5.jar grâce à la commande `java -jar Mars4_5.jar`. Pour lancer votre programme, vous devez charger votre fichier snake.asm. Ensuite, vous devez activer l’affichage et la capture des entrées claviers en allant dans l’onglet Tools pour lancer _Bitmap Display & Keyboard_ ainsi que _Display MMIO Simulator_. Dans l’outil _BitMap Display_, vous devez sélectionner une fenêtre carrée 256x256 et une taille de pixel 16x16. Ne pas oublier de connecter les deux widgets à votre code MIPS. Finalement, il ne vous reste plus qu’à lancer l’exécution votre programme et interagir grâce aux entrées claviers.

## Déroulement du jeu

Au départ le serpent est positionné dans la case en haut à gauche avec une taille initialisé à 1 et la direction du serpent pointe vers la droite.

Le serpent est représenté en vert avec sa tête en vert foncé, les obstacles sont en rouge et la nourriture permettant de faire grandir votre serpent est coloriée en rose.

### Capture d'une touche directionnelle

- <kbd>z</kbd> Haut
- <kbd>q</kbd> Gauche
- <kbd>s</kbd> Bas
- <kbd>d</kbd> Droite

Si une touche directionnelle est capturée, la direction du serpent est mise à jour.

### Nourriture

Mise à jour du serpent et de l’environnement si une pastille de nourriture était présente sur la tête du serpent après le décalage. Dans ce cas la taille du serpent augmente de un et la position suivante de la prochaine pastille de nourriture est calculée aléatoirement.

Un obstacle supplémentaire est ajouté lorsqu'une pastille de nourriture est consommée et le score augmente.

### Fin de jeu

Si une des trois contraintes suivantes n'est plus respectée, la partie est terminée.

- La tête du serpent ne doit pas dépasser la bordure de la grille.
- La tête du serpent ne doit pas rentrer en contact avec un obstacle.
- Le serpent ne doit pas rencontrer une partie de son propre corps.

Le score est alors affiché dans la console.

# Travail à fournir

**NE PAS OUBLIER DE COMMENTER LE CODE !**

**NE PAS UTILISER LE MOT CLEF _.macro_ !**

## Fonctionnalités à implémenter

- [ ] Mise à jour de la position.
- [ ] Mise à jour des structures de données :
  - [ ] serpent.
  - [ ] obstacle.
  - [ ] nourriture.
- [ ] Détecter et programmer les conditions de fin de jeu.
- [ ] Affichage de fin de partie avec le score.

## Options

- [ ] Afficher le score graphiquement sur l’écran de jeu en fin de partie.
- [ ] _"Rainbow snake"_ où chaque partie du serpent possède une couleur différente.
- [ ] Système de niveau prédéfini en fonction du score obtenu.

## Travail à rendre

- [ ] Archive _.tar.gz_
  - [ ] Code source _.s_
  - [ ] Rapport _.pdf_ d'au maximum 2 pages expliquant :
    - les choix effectués durant la conception de votre projet.
    - vos structures de données.
    - la répartition du travail.
    - les difficultés rencontrées.
    - les fonctionnalités ajoutées.
    - les autres observations.

Pour archiver les fichiers on pourra utiliser la commande bash suivante :

```bash
tar -cvzf Beaurepere_Gall.tar.gz snake.asm rapport.pdf
```
