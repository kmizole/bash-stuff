# Description
Script qui permet de capturer une image png du site web exposé en partant de son nom de domaine.

Curl permet de récupérer l'url http en face du nom de domaine

Cutycapt réalise la capture en jpg

le script génère une sortie HTML et CSV.

# Installation
## Debian
```
apt install curl cutycapt
```
# Utilisation
```
./capture-site.sh ./liste.txt
```
# liste.txt

contient la liste des domaines à scanner

# Sortie

+ Un dossier timestampé qui contient un fichier html (css bootstrap) sous forme de tableau
+ Un fichier CSV
+ Un dossier avec les png des sites capturé
