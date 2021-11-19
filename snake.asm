#                      _..._                 .           __.....__
#                    .'     '.             .'|       .-''         '.
#                   .   .-.   .          .'  |      /     .-''"'-.  `.
#                   |  '   '  |    __   <    |     /     /________\   \
#               _   |  |   |  | .:--.'.  |   | ____|                  |
#             .' |  |  |   |  |/ |   \ | |   | \ .'\    .-------------'
#            .   | /|  |   |  |`" __ | | |   |/  .  \    '-.____...---.
#          .'.'| |//|  |   |  | .'.''| | |    /\  \  `.             .'
#        .'.'.-'  / |  |   |  |/ /   | |_|   |  \  \   `''-...... -'
#        .'   \_.'  |  |   |  |\ \._,\ '/'    \  \  \
#                   '--'   '--' `--'  `"'------'  '---'
#
#
#
#                                               .......
#                                     ..  ...';:ccc::,;,'.
#                                 ..'':cc;;;::::;;:::,'',,,.
#                              .:;c,'clkkxdlol::l;,.......',,
#                          ::;;cok0Ox00xdl:''..;'..........';;
#                          o0lcddxoloc'.,. .;,,'.............,'
#                           ,'.,cc'..  .;..;o,.       .......''.
#                             :  ;     lccxl'          .......'.
#                             .  .    oooo,.            ......',.
#                                    cdl;'.             .......,.
#                                 .;dl,..                ......,,
#                                 ;,.                   .......,;
#                                                        ......',
#                                                       .......,;
#                                                       ......';'
#                                                      .......,:.
#                                                     .......';,
#                                                   ........';:
#                                                 ........',;:.
#                                             ..'.......',;::.
#                                         ..';;,'......',:c:.
#                                       .;lcc:;'.....',:c:.
#                                     .coooc;,.....,;:c;.
#                                   .:ddol,....',;:;,.
#                                  'cddl:'...,;:'.
#                                 ,odoc;..',;;.                    ,.
#                                ,odo:,..';:.                     .;
#                               'ldo:,..';'                       .;.
#                              .cxxl,'.';,                        .;'
#                              ,odl;'.',c.                         ;,.
#                              :odc'..,;;                          .;,'
#                              coo:'.',:,                           ';,'
#                              lll:...';,                            ,,''
#                              :lo:'...,;         ...''''.....       .;,''
#                              ,ooc;'..','..';:ccccccccccc::;;;.      .;''.
#          .;clooc:;:;''.......,lll:,....,:::;;,,''.....''..',,;,'     ,;',
#       .:oolc:::c:;::cllclcl::;cllc:'....';;,''...........',,;,',,    .;''.
#      .:ooc;''''''''''''''''''',cccc:'......'',,,,,,,,,,;;;;;;'',:.   .;''.
#      ;:oxoc:,'''............''';::::;'''''........'''',,,'...',,:.   .;,',
#     .'';loolcc::::c:::::;;;;;,;::;;::;,;;,,,,,''''...........',;c.   ';,':
#     .'..',;;::,,,,;,'',,,;;;;;;,;,,','''...,,'''',,,''........';l.  .;,.';
#    .,,'.............,;::::,'''...................',,,;,.........'...''..;;
#   ;c;',,'........,:cc:;'........................''',,,'....','..',::...'c'
#  ':od;'.......':lc;,'................''''''''''''''....',,:;,'..',cl'.':o.
#  :;;cclc:,;;:::;''................................'',;;:c:;,'...';cc'';c,
#  ;'''',;;;;,,'............''...........',,,'',,,;:::c::;;'.....',cl;';:.
#  .'....................'............',;;::::;;:::;;;;,'.......';loc.'.
#   '.................''.............'',,,,,,,,,'''''.........',:ll.
#    .'........''''''.   ..................................',;;:;.
#      ...''''....          ..........................'',,;;:;.
#                                ....''''''''''''''',,;;:,'.
#                                    ......'',,'','''..
#


################################################################################
#                  Fonctions d'affichage et d'entrée clavier                   #
################################################################################

# Ces fonctions s'occupent de l'affichage et des entrées clavier.
# Il n'est pas obligatoire de comprendre ce qu'elles font.

.data

# Tampon d'affichage du jeu 256*256 de manière linéaire.

frameBuffer: .word 0 : 1024  # Frame buffer

# Code couleur pour l'affichage
# Codage des couleurs 0xwwxxyyzz où
#   ww = 00
#   00 <= xx <= ff est la couleur rouge en hexadécimal
#   00 <= yy <= ff est la couleur verte en hexadécimal
#   00 <= zz <= ff est la couleur bleue en hexadécimal

colors: .word 0x00000000, 0x00ff0000, 0xff00ff00, 0x00396239, 0x00ff00ff
.eqv black 0
.eqv red   4
.eqv green 8
.eqv greenV2  12
.eqv rose  16

# Dernière position connue de la queue du serpent.

lastSnakePiece: .word 0, 0

.text
j main

############################# printColorAtPosition #############################
# Paramètres: $a0 La valeur de la couleur
#             $a1 La position en X
#             $a2 La position en Y
# Retour: Aucun
# Effet de bord: Modifie l'affichage du jeu
################################################################################

printColorAtPosition:
lw $t0 tailleGrille
mul $t0 $a1 $t0
add $t0 $t0 $a2
sll $t0 $t0 2
sw $a0 frameBuffer($t0)
jr $ra

################################ resetAffichage ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Réinitialise tout l'affichage avec la couleur noir
################################################################################

resetAffichage:
lw $t1 tailleGrille
mul $t1 $t1 $t1
sll $t1 $t1 2
la $t0 frameBuffer
addu $t1 $t0 $t1
lw $t3 colors + black

RALoop2: bge $t0 $t1 endRALoop2
  sw $t3 0($t0)
  add $t0 $t0 4
  j RALoop2
endRALoop2:
jr $ra

################################## printSnake ##################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage aux emplacement ou se
#                trouve le serpent et sauvegarde la dernière position connue de
#                la queue du serpent.
################################################################################

printSnake:
subu $sp $sp 12
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)

lw $s0 tailleSnake
sll $s0 $s0 2
li $s1 0

lw $a0 colors + greenV2
lw $a1 snakePosX($s1)
lw $a2 snakePosY($s1)
jal printColorAtPosition
li $s1 4

PSLoop:
bge $s1 $s0 endPSLoop
  lw $a0 colors + green
  lw $a1 snakePosX($s1)
  lw $a2 snakePosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
  j PSLoop
endPSLoop:

subu $s0 $s0 4
lw $t0 snakePosX($s0)
lw $t1 snakePosY($s0)
sw $t0 lastSnakePiece
sw $t1 lastSnakePiece + 4

lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
addu $sp $sp 12
jr $ra

################################ printObstacles ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage aux emplacement des obstacles.
################################################################################

printObstacles:
subu $sp $sp 12
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)

lw $s0 numObstacles
sll $s0 $s0 2
li $s1 0

POLoop:
bge $s1 $s0 endPOLoop
  lw $a0 colors + red
  lw $a1 obstaclesPosX($s1)
  lw $a2 obstaclesPosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
  j POLoop
endPOLoop:

lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
addu $sp $sp 12
jr $ra

################################## printCandy ##################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage à l'emplacement du bonbon.
################################################################################

printCandy:
subu $sp $sp 4
sw $ra ($sp)

lw $a0 colors + rose
lw $a1 candy
lw $a2 candy + 4
jal printColorAtPosition

lw $ra ($sp)
addu $sp $sp 4
jr $ra

eraseLastSnakePiece:
subu $sp $sp 4
sw $ra ($sp)

lw $a0 colors + black
lw $a1 lastSnakePiece
lw $a2 lastSnakePiece + 4
jal printColorAtPosition

lw $ra ($sp)
addu $sp $sp 4
jr $ra

################################## printGame ###################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Effectue l'affichage de la totalité des éléments du jeu.
################################################################################

printGame:
subu $sp $sp 4
sw $ra 0($sp)

jal eraseLastSnakePiece
jal printSnake
jal printObstacles
jal printCandy

lw $ra 0($sp)
addu $sp $sp 4
jr $ra

############################## getRandomExcluding ##############################
# Paramètres: $a0 Un entier x | 0 <= x < tailleGrille
# Retour: $v0 Un entier y | 0 <= y < tailleGrille, y != x
################################################################################

getRandomExcluding:
move $t0 $a0
lw $a1 tailleGrille
li $v0 42
syscall
beq $t0 $a0 getRandomExcluding
move $v0 $a0
jr $ra

########################### newRandomObjectPosition ############################
# Description: Renvoie une position aléatoire sur un emplacement non utilisé
#              qui ne se trouve pas devant le serpent.
# Paramètres: Aucun
# Retour: $v0 Position X du nouvel objet
#         $v1 Position Y du nouvel objet
################################################################################

newRandomObjectPosition:
subu $sp $sp 4
sw $ra ($sp)

lw $t0 snakeDir
and $t0 0x1
bgtz $t0 horizontalMoving
li $v0 42
lw $a1 tailleGrille
syscall
move $t8 $a0
lw $a0 snakePosY
jal getRandomExcluding
move $t9 $v0
j endROPdir

horizontalMoving:
lw $a0 snakePosX
jal getRandomExcluding
move $t8 $v0
lw $a1 tailleGrille
li $v0 42
syscall
move $t9 $a0
endROPdir:

lw $t0 tailleSnake
sll $t0 $t0 2
la $t0 snakePosX($t0)
la $t1 snakePosX
la $t2 snakePosY
li $t4 0

ROPtestPos:
bge $t1 $t0 endROPtestPos
lw $t3 ($t1)
bne $t3 $t8 ROPtestPos2
lw $t3 ($t2)
beq $t3 $t9 replayROP
ROPtestPos2:
addu $t1 $t1 4
addu $t2 $t2 4
j ROPtestPos
endROPtestPos:

bnez $t4 endROP

lw $t0 numObstacles
sll $t0 $t0 2
la $t0 obstaclesPosX($t0)
la $t1 obstaclesPosX
la $t2 obstaclesPosY
li $t4 1
j ROPtestPos

endROP:
move $v0 $t8
move $v1 $t9
lw $ra ($sp)
addu $sp $sp 4
jr $ra

replayROP:
lw $ra ($sp)
addu $sp $sp 4
j newRandomObjectPosition

################################# getInputVal ##################################
# Paramètres: Aucun
# Retour: $v0 La valeur 0 (haut), 1 (droite), 2 (bas), 3 (gauche), 4 erreur
################################################################################

getInputVal:
lw $t0 0xffff0004
li $t1 115
beq $t0 $t1 GIhaut
li $t1 122
beq $t0 $t1 GIbas
li $t1 113
beq $t0 $t1 GIgauche
li $t1 100
beq $t0 $t1 GIdroite
li $v0 4
j GIend

GIhaut:
li $v0 0
j GIend

GIdroite:
li $v0 1
j GIend

GIbas:
li $v0 2
j GIend

GIgauche:
li $v0 3

GIend:
jr $ra

################################ sleepMillisec #################################
# Paramètres: $a0 Le temps en milli-secondes qu'il faut passer dans cette
#             fonction (approximatif)
# Retour: Aucun
################################################################################

sleepMillisec:
move $t0 $a0
li $v0 30
syscall
addu $t0 $t0 $a0

SMloop:
bgt $a0 $t0 endSMloop
li $v0 30
syscall
j SMloop

endSMloop:
jr $ra

##################################### main #####################################
# Description: Boucle principal du jeu
# Paramètres: Aucun
# Retour: Aucun
################################################################################

main:

# Initialisation du jeu

jal resetAffichage
jal newRandomObjectPosition
sw $v0 candy
sw $v1 candy + 4

# Boucle de jeu

mainloop:

jal getInputVal
move $a0 $v0
jal majDirection
jal updateGameStatus
jal conditionFinJeu
bnez $v0 gameOver
jal printGame
li $a0 500
jal sleepMillisec
j mainloop

gameOver:
jal affichageFinJeu
li $v0 10
syscall

################################################################################
#                                Partie Projet                                 #
################################################################################

# À vous de jouer !

.data

tailleGrille:  .word 16        # Nombre de case du jeu dans une dimension.

# La tête du serpent se trouve à (snakePosX[0], snakePosY[0]) et la queue à
# (snakePosX[tailleSnake - 1], snakePosY[tailleSnake - 1])
tailleSnake:   .word 1         # Taille actuelle du serpent.
snakePosX:     .word 0 : 1024  # Coordonnées X du serpent ordonné de la tête à la queue.
snakePosY:     .word 0 : 1024  # Coordonnées Y du serpent ordonné de la t.

# Les directions sont représentés sous forme d'entier allant de 0 à 3:
snakeDir:      .word 1         # Direction du serpent: 0 (haut), 1 (droite)
                               #                       2 (bas), 3 (gauche)
numObstacles:  .word 0         # Nombre actuel d'obstacle présent dans le jeu.
obstaclesPosX: .word 0 : 1024  # Coordonnées X des obstacles
obstaclesPosY: .word 0 : 1024  # Coordonnées Y des obstacles
candy:         .word 0, 0      # Position du bonbon (X,Y)
scoreJeu:      .word 0         # Score obtenu par le joueur

printZero:     .word 32,  0,5,	0,6,	0,7,	0,8,	0,9,	0,10,	1,4,	1,11,	2,4,	2,11,	3,5,	3,6,	3,7,	3,8,	3,9,	3,10  # Affichage de 0 : TAILLE, Y,X,Y2,X2,...
printUn:       .word 22,  0,7,	1,6,	2,5,	3,4,	3,5,	3,6,	3,7,	3,8,	3,9,	3,10,	3,11                                # Affichage de 1 : TAILLE, Y,X,Y2,X2,...
printDeux:     .word 28,  0,5,	0,6,	0,10,	0,11,	1,4,	1,9,	1,11,	2,4,	2,8,	2,11,	3,5,	3,6,	3,7,	3,11              # Affichage de 2 : TAILLE, Y,X,Y2,X2,...
printTrois:    .word 24,  0,4,	0,11,	1,4,	1,7,	1,11,	2,4,	2,6,	2,8,	2,10,	3,4,	3,5,	3,9                           # Affichage de 3 : TAILLE, Y,X,Y2,X2,...
printQuatre:   .word 26,  0,4,  0,5,  0,6,	0,7,	1,7,	2,5,	2,6,	2,7,	2,8,	2,9,	2,10,	2,11,	3,7                     # Affichage de 4 : TAILLE, Y,X,Y2,X2,...
printCinq:     .word 30,  0,4,	0,5,	0,6,	0,7,	0,11,	1,4,	1,7,	1,11,	2,4,	2,7,	2,11,	3,4,	3,8,	3,9,	3,10        # Affichage de 5 : TAILLE, Y,X,Y2,X2,...
printSix:      .word 26,  0,7,	0,8,	0,9,	0,10,	1,6,	1,11,	2,5,	2,7,	2,11,	3,4,	3,8,	3,9,	3,10                    # Affichage de 6 : TAILLE, Y,X,Y2,X2,...
printSept:     .word 22,  0,4,	0,10,	0,11,	1,4,	1,8,	1,9,	2,4,	2,6,	2,7,	3,4,	3,5                                 # Affichage de 7 : TAILLE, Y,X,Y2,X2,...
printHuit:     .word 32,  0,5,	0,6,	0,8,	0,9,	0,10,	1,4,	1,7,	1,11,	2,4,	2,8,	2,11,	3,5,	3,6,	3,7,	3,9,	3,10  # Affichage de 8 : TAILLE, Y,X,Y2,X2,...
printNeuf:     .word 26,  0,5,	0,6,	0,7,	0,11,	1,4,	1,8,	1,10,	2,4,	2,9,	3,5,	3,6,	3,7,	3,8                     # Affichage de 9 : TAILLE, Y,X,Y2,X2,...

printNumber: .word printZero, printUn, printDeux, printTrois, printQuatre, printCinq, printSix, printSept, printHuit, printNeuf

scoreMessage:   .asciiz "Votre score est : "                      # Message d'introduction du score
endGameMessage: .asciiz "\nQuelle performance éblouissante ;)\n"  # Mot gentil

.text

################################# majDirection #################################
# Paramètres: $a0 La nouvelle position demandée par l'utilisateur. La valeur
#                 étant le retour de la fonction getInputVal.
# Retour: Aucun
# Effet de bord: La direction du serpent à été mise à jour.
# Post-condition: La valeur du serpent reste intacte si une commande illégale
#                 est demandée, i.e. le serpent ne peut pas faire de demi-tour
#                 en un unique tour de jeu. Cela s'apparente à du cannibalisme
#                 et à été proscrit par la loi dans les sociétés reptiliennes.
################################################################################

majDirection:
li $t0,4 
# On regarde si il y a eu une erreur dans getInputVal
beq $a0,$t0,endMD 

# On vérifie DirectionDemandée != ((DirectionActuelle + 2) modulo 4) pour s'assurer que le serpent ne fait pas de demi-tour.
lw $t1,snakeDir   # On récupère la direction précédente dans $t1
addi $t2,$t1,2    # $t2 = $t1 + 2
divu $t2,$t0      # On applique la division entière de $t1 par 4 (stocké dans $t0)
mfhi $t2          # On récupère le reste de cette division entière dans $t1
beq $a0,$t2,endMD # On vérifie que ce n'est pas un demi-tour

# On met à jour la direction du serpent
sw $a0,snakeDir

endMD:
jr $ra

############################### updateGameStatus ###############################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: L'état du jeu est mis à jour d'un pas de temps. Il faut donc :
#                  - Faire bouger le serpent
#                  - Tester si le serpent a mangé le bonbon
#                    - Si oui déplacer le bonbon et ajouter un nouvel obstacle
################################################################################

updateGameStatus:
# Sauvegarde de $ra
addi $sp,$sp,-4
sw $ra,0($sp)
# Décalage des positions du serpent d'une case du tableau
li $t0,0
lw $t1,tailleSnake        # $t1 = Taille du serpent
la $t2,snakePosX          # $t2 = Adresse de la tête du serpent en X
la $t3,snakePosY          # $t3 = Adresse de la tête du serpent en Y
li $t4,4
mul $t4,$t4,$t1           # On fait le calcul $t4 = 4*(taille du serpent)
add $t2,$t2,$t4           # On se place à la fin du serpent en X ($t2 += longueur en octets du serpent)
add $t3,$t3,$t4           # On se place à la fin du serpent en Y ($t3 += longueur en octets du serpent)

UGSLoop:                  # On va parcourir à l'envers le serpent
  bge $t0,$t1,end_UGSLoop # Si tout est parcouru, fin de la boucle
  lw $t4,-4($t2)          # On charge la valeur en X d'une partie du serpent
  sw $t4,0($t2)           # On l'écrit dans la case suivante
  addi $t2,$t2,-4         # On décrémente la position du serpent en X
  lw $t4,-4($t3)          # On charge la valeur en Y d'une partie du serpent
  sw $t4,0($t3)           # On l'écrit dans la case suivante
  addi $t3,$t3,-4         # On décrémente la position du serpent en Y
  addi $t0,$t0,1          # On incrémente l'index
  j UGSLoop
end_UGSLoop:

# Calcul de la nouvelle position de la tête
lw $t0,snakeDir           # $t0 = Direction du serpent
lw $t3,snakePosX          # $t3 = Adresse de la tête du serpent en X
lw $t4,snakePosY          # $t4 = Adresse de la tête du serpent en Y
beq $t0,$zero,UGS_haut    # Cas direction = haut
li $t2,1
beq $t0,$t2,UGS_droite    # Cas direction = droit
li $t2,2
beq $t0,$t2,UGS_bas       # Cas direction = bas
                          # Sinon cas direction = gauche
UGS_gauche:
addi $t4,$t4,-1           # Tête en Y -= 1
j endNP_UGS

UGS_haut:
addi $t3,$t3,1            # Tête en X += 1
j endNP_UGS

UGS_droite:
addi $t4,$t4,1            # Tête en Y += 1
j endNP_UGS

UGS_bas:
addi $t3,$t3,-1           # Tête en X -= 1

endNP_UGS:
sw $t3,snakePosX          # On change la position de la tête en X suivant le calcul précédent
sw $t4,snakePosY          # On change la position de la tête en Y suivant le calcul précédent

# Candy
la $t0,candy              # On récupère l'adresse du bonbon
lw $t2,0($t0)
bne $t3,$t2,end_UGS       # On compare la position de la tête à la position du bonbon (en X) si différent, on va à la fin
lw $t2,4($t0)
bne $t4,$t2,end_UGS       # On compare la position de la tête à la position du bonbon (en Y) si différent, on va à la fin

addi $t1,$t1,1            # On incrémente la taille du serpent ($t1 = taille du serpent)
sw $t1,tailleSnake        

lw $t0,scoreJeu           # On incrémente le score
addi $t0,$t0,1
sw $t0,scoreJeu

jal newRandomObjectPosition # On récupère des positions aléatoires inocupées pour y placer le nouveau bonbon
la $t0,candy
sw $v0,0($t0)               # On place la position aléatoire du bonbon en X
sw $v1,4($t0)               # On place la position aléatoire du bonbon en Y

jal newRandomObjectPosition # On récupère des positions aléatoires inocupées pour y placer le nouvel obstacle
lw $t0,numObstacles         # On charge le nombre d'obstacles
li $t1,4
mul $t1,$t0,$t1             
la $t2,obstaclesPosX        # On charge l'adresse du premier obstacle en X dans $t2
add $t2,$t2,$t1             # On se place après le dernier obstacle en X
sw $v0,0($t2)               # On écrit la postion du dernier obstacle en X
la $t2,obstaclesPosY        # On charge l'adresse du premier obstacle en Y dans $t2
add $t2,$t2,$t1             # On se place après le dernier obstacle en Y
sw $v1,0($t2)               # On écrit la postion du dernier obstacle en Y

addi $t0,$t0,1              # On incrémente le nombre d'obstacles
sw $t0,numObstacles

end_UGS:
# Récupération de $ra
lw $ra,0($sp)
addi $sp,$sp,4
jr $ra                      # Retour à la fonction appelante


############################### conditionFinJeu ################################
# Paramètres: Aucun
# Retour: $v0 La valeur 0 si le jeu doit continuer ou toute autre valeur sinon.
################################################################################

conditionFinJeu:
lw $t0,snakePosX		        # $t0 = PositionX du serpent
lw $t1,snakePosY		        # $t1 = PositionY du serpent
lw $t2,tailleGrille	        # $t2 = Taille de la grille

# Test de sortie de grille
bge $t0,$t2,endCFJtest 	    # Test si il y un a overflow de x
blt $t0,$zero,endCFJtest	  # Test si il y a un underflow de x
bge $t1,$t2,endCFJtest 	    # Test si il y un a overflow de y
blt $t1,$zero,endCFJtest	  # Test si il y a un underflow de y

# Test de collision entre la tête du serpent et obstacle
li $t2,-1			              # $t2 = compteur de boucle
li $t3,4		                # $t3 = 4
lw $t7,numObstacles	        # $t7 = nombre d'obstacles
CFJloop1:
  addi $t2,$t2,1            # Incrémentation du compteur
  bge $t2,$t7,endCFJloop1	  # Condition fin de loop
  mul $t4,$t3,$t2		        # On stocke le décalage d'octets dans $t4
  la $t5,obstaclesPosX	    # On stocke l'adresse de obstaclesPosX dans $t5
  add $t5,$t4,$t5		        # On additionne avec le décalage
  lw $t6,0($t5) 	          # On stocke x dans $t6
  bne $t0,$t6,CFJloop1	    # Si tête du serpent en x != obstacle en x on passe à l'obstacle suivant
  la $t5,obstaclesPosY 	    # Sinon on stocke l'adresse de obstaclesPosY dans $t5
  add $t5,$t4,$t5		        # On fait la somme avec le décalage
  lw $t6,0($t5) 		        # On stocke y dans $t6
  beq $t1,$t6,endCFJtest	  # Si tête du serpent en y == obstacle en y alors on va à la fin du test (collision)
  j CFJloop1			          # Boucle suivante
endCFJloop1:

# Test de collision entre la tête du serpent et sa queue
li $t2,0 			              # On met notre compteur de boucle a 0
lw $t7,tailleSnake	        # On charge la taille de notre snake dans  $t7
CFJloop2:
  addi $t2,$t2,1		        # Incrémentation de $t2
  bge $t2,$t7,endCFJloop2	  # Condition fin de boucle
  mul $t4,$t3,$t2		        # On stocke le décalage d'octets dans $t4
  la $t5,snakePosX		      # On stocke snakePosX dans $t5
  add $t5,$t4,$t5		        # On additionne avec le décalage
  lw $t6,0($t5) 		        # On stocke snakePosX (décalé) dans $t6
  bne $t0,$t6,CFJloop2	    # si tête en x != snakePosX on passe a la prochain boucle
  la $t5,snakePosY		      # Sinon on stocke snakePosY dans $t5
  add $t5,$t4,$t5		        # On fait la somme avec le décalage
  lw $t6,0($t5) 		        # On stocke snakePosY (décalé) dans $t6
  beq $t1,$t6,endCFJtest	  # Si tête en y == snakePosY alors on va a la fin du test (collision)
  j CFJloop2			          # Boucle suivante

# Sortie de fonction collision
endCFJtest:
li $v0,1			              # Stocke dans $v0 qu'il y a eu collision 
jr $ra			

# Sortie de fonction sans collision
endCFJloop2:
li $v0,0			              # Stocke dans $v0 qu'il n'y a pas eu de collision
jr $ra

############################### affichageFinJeu ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Affiche le score du joueur dans le terminal suivi d'un petit
#                mot gentil (Exemple : «Quelle pitoyable prestation !»).
# Bonus: Afficher le score en surimpression du jeu.
################################################################################

affichageFinJeu:
# Prologue
addi $sp,$sp,-4
sw $ra,0($sp)

jal printScore            # On affiche en surimpression du jeu le score.
la $a0,scoreMessage       # On charge l'adresse du message du score
li $v0,4
syscall                   # On affiche le message
lw $a0,scoreJeu           # On charge le score
li $v0,1
syscall                   # On l'affiche
la $a0,endGameMessage     # On charge l'adresse du message gentil
li $v0,4
syscall                   # On affiche le message

# Épilogue
lw $ra,0($sp)
addi $sp,$sp,4
jr $ra                    # Retour à la fonction appelante



################################### printScore #################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Affiche le score du joueur en surimpression du jeu.
################################################################################

printScore:
# Sauvegarde de registres
addi $sp,$sp,-8
sw $ra,0($sp)
sw $s0,4($sp)

jal resetAffichage        # On réninitialise l'affichage

lw $t0,scoreJeu           # On charge le score
li $t1,10
blt $t0,$t1,unique_PS     # Si il est supérieur ou égal à 10 (2 chiffres)
divu $t0,$t1              # On divise le score par 10
mflo $a1                  # On récupère le chiffre des dizaines dans $a1
mfhi $s0                  # On sauvegarde le chiffre des unités dans $s0
li $a0,1                  # Mode dizaine dans $a0
jal printVal              # On affiche le chiffre des dizaines  
move $a1,$s0              # On met dans $a1 le chiffre des unités
li $a0,2                  # Mode unité dans $a2
jal printVal              # On affiche le chiffre des unités
j end_PS                  # fin si

unique_PS:                # Sinon (1 chiffre)
li $a0,0                  # Mode 1 chiffre dans $a0
move $a1,$t0              # Score dans $a1
jal printVal              # On affiche à le score

end_PS:
# Récupération des registres sauvegardés
lw $ra,0($sp)
lw $s0,4($sp)
addi $sp,$sp,8
jr $ra                    # Retour à la fonction appelante



################################### printVal ###################################
# Paramètres: $a0 mode (0 : 1 seul chiffre, 1 : dizaine, 2 : unité) sert pour
#                 calculer le décalage.
#             $a1 chiffre à afficher.
# Retour: Aucun
# Effet de bord: Affiche un chiffre en surimpression du jeu.
################################################################################

printVal:
# Sauvegarde de registres
addi $sp,$sp,-16
sw $ra,0($sp)
sw $s0,4($sp)
sw $s1,8($sp)
sw $s2,12($sp)

# calcul du décalage
beq $a0,$zero,unique_PV
li $t0,1
beq $a0,$t0,dizaine_PV
li $s0,9                    # Si MODE != 0 et MODE != 1 alors DÉCALAGE = DÉCALAGE_UNITÉ = 9
j end_decalage_PV
unique_PV:                  # Si MODE == 0 alors DÉCALAGE = DÉCALAGE_UNIQUE = 6
li $s0,6
j end_decalage_PV
dizaine_PV:                 # Si MODE == 1 alors DÉCALAGE = DÉCALAGE_DIZAINE = 3
li $s0,3
end_decalage_PV:

# chargement dans $s1 de l'adresse tableau contenant les points du chiffre
blt $a1,$zero,error_PV
li $t0, 9
bgt $a1,$t0,error_PV

li $t0, 4
mul $t1,$a1,$t0
la $t0,printNumber
add $t0,$t0,$t1
la $s1, ($t0)
j end_chargement_PV

error_PV:
la $s1,printZero            #   $s1 = printZero
j end_chargement_PV

# bne $a1,$zero,Nzero_PV      # Si $a1 == 0 :
# la $s1,printZero            #   $s1 = printZero
# j end_chargement_PV
# Nzero_PV:

# li $t0,1
# bne $a1,$t0,Nun_PV          # Si $a1 == 1 :
# la $s1,printUn              #   $s1 = printUn
# j end_chargement_PV
# Nun_PV:

# li $t0,2
# bne $a1,$t0,Ndeux_PV        # Si $a1 == 2 :
# la $s1,printDeux            #   $s1 = printDeux
# j end_chargement_PV
# Ndeux_PV:

# li $t0,3
# bne $a1,$t0,Ntrois_PV       # Si $a1 == 3 :
# la $s1,printTrois           #   $s1 = printTrois
# j end_chargement_PV
# Ntrois_PV:

# li $t0,4
# bne $a1,$t0,Nquatre_PV      # Si $a1 == 4 :
# la $s1,printQuatre          #   $s1 = printQuatre
# j end_chargement_PV
# Nquatre_PV:

# li $t0,5
# bne $a1,$t0,Ncinq_PV        # Si $a1 == 5 :
# la $s1,printCinq            #   $s1 = printCinq
# j end_chargement_PV
# Ncinq_PV:

# li $t0,6
# bne $a1,$t0,Nsix_PV         # Si $a1 == 6 :
# la $s1,printSix             #   $s1 = printSix
# j end_chargement_PV
# Nsix_PV:

# li $t0,7
# bne $a1,$t0,Nsept_PV        # Si $a1 == 7 :
# la $s1,printSept            #   $s1 = printSept
# j end_chargement_PV
# Nsept_PV:

# li $t0,8
# bne $a1,$t0,Nhuit_PV        # Si $a1 == 8 :
# la $s1,printHuit            #   $s1 = printHuit
# j end_chargement_PV
# Nhuit_PV:
#                             # Sinon :
# la $s1,printNeuf            #   $s1 = printNeuf
# j end_chargement_PV
end_chargement_PV:

# Affichage du chiffre
lw $s2,0($s1)               # $s2 = TAILLE du tableau (à partir des positions)
addi $s1,$s1,4              # On se place au début des positions

loop_PV:                    # Tant que $s2 > 0
  ble $s2,$zero,endloop_PV
  lw $a2,0($s1)             # On charge Y dans $a2
  add $a2,$a2,$s0           # On ajoute le décalage
  lw $a1,4($s1)             # On charge X dans $a1
  lw $a0, colors + red      # On charge la couleur dans $a0
  jal printColorAtPosition  # On affiche la case
  addi $s1,$s1,8            # On se déplace dans le tableau
  addi $s2,$s2,-2           # On décrémente la taille des 2 positions du tableau consultées
  j loop_PV
endloop_PV:

# Récupération des registres sauvegardés
lw $ra,0($sp)
lw $s0,4($sp)
lw $s1,8($sp)
lw $s2,12($sp)
addi $sp,$sp,16
jr $ra                      # Retour à la fonction appelante
