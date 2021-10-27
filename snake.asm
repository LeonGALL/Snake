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
bge $t0,$t1,end_UGSLoop   # Si tout est parcouru, fin de la boucle
lw $t4,-4($t2)            # On charge la valeur en X d'une partie du serpent
sw $t4,0($t2)             # On l'écrit dans la case suivante
addi $t2,$t2,-4           # On décrémente la position du serpent en X
lw $t4,-4($t3)            # On charge la valeur en Y d'une partie du serpent
sw $t4,0($t3)             # On l'écrit dans la case suivante
addi $t3,$t3,-4           # On décrémente la position du serpent en Y
addi $t0,$t0,1            # On incrémente l'index
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
    lw $t0, snakePosX
    lw $t1, snakePosY
    lw $t2, tailleGrille
    bge $t0, $t2, endCFJtest ### BGE
    blt $t0, $zero, endCFJtest
    bge $t1, $t2, endCFJtest ### BGE
    blt $t1, $zero, endCFJtest

    li $t2, 0
    li $t3, 4
    lw $t7, numObstacles
CFJloop1:
    bge $t2, $t7, endCFJloop1
    mul $t4, $t3, $t2
    la $t5, obstaclesPosX
    add $t6, $t4, $t5
    lw $t6,0($t6) ###### <----
    beq $t0, $t6, endCFJtest
    la $t5, obstaclesPosY
    add $t6, $t4, $t5
    lw $t6,0($t6) ###### <----
    beq $t1, $t6, endCFJtest
    addi $t2, $t2, 1
    j CFJloop1
endCFJloop1:
    li $t2, 1 #### SINON TU AS LA TÊTE = LA TÊTE
    lw $t7, tailleSnake
CFJloop2:
    bge $t2, $t7, endCFJloop2
    mul $t4, $t3, $t2
    la $t5, snakePosX
    add $t6, $t4, $t5
    lw $t6,0($t6) ###### <----
    beq $t0, $t6, endCFJtest
    la $t5, snakePosY
    add $t6, $t4, $t5
    lw $t6,0($t6) ###### <----
    beq $t1, $t6, endCFJtest
    addi $t2, $t2, 1
    j CFJloop2
endCFJtest:
    li $v0, 1
    jr $ra

endCFJloop2:
    li $v0,0 ### <------
    jr $ra

############################### affichageFinJeu ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Affiche le score du joueur dans le terminal suivi d'un petit
#                mot gentil (Exemple : «Quelle pitoyable prestation !»).
# Bonus: Afficher le score en surimpression du jeu.
################################################################################

affichageFinJeu:

# Fin.

jr $ra
