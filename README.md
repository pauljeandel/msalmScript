# Script Mon sport a la maison

## Install
Works on : `Linux Shell`
#### Clone the repo in $HOME/bin :
```
cd $HOME/bin && git clone https://github.com/pauljeandel/msalmScript.git
```
[Options et exemples plus bas](#config)
#### Create a config_perso.txt file :
```
cd $HOME/bin/msalmScript && touch config_perso.txt
```
#### Add $HOME/bin/msalmScript to your PATH :
```
export PATH=$PATH:$HOME/bin/msalmScript
```
Aide : <a href=https://doc.ubuntu-fr.org/tutoriel/script_shell>Doc Ubuntu</a>
## Contribuer :
 Via ***issue github***. Trois options :
 - `Rapport de bug`
 - `Nouvelle fonctionnalité`
 - `Amélioration`
</br></br>***Creer une branche du même nom que l'issue puis une Pull Request liée à l'issue.***</br></br>
<a href=https://github.com/pauljeandel/msalmScript/contribute>***Good first issues***</a>
## Usage
#### Basic Usage :
- `:~$ bash msalm.sh [COMMAND] <ARGS> --[OPTION]`
#### Exemples :
- `:~$ bash msalm.sh -iu --open` / `bash msalm.sh ionicupdate --open`
- `:~$ bash msalm.sh -iu -ie`
- 
#### Basics commands :
- `help, -v` :             Affiche les commandes
- `update` :               Met à jour le script
- `editScript, -es` :      Edite le script
- `editConig, -ec` :       Edite le fichier de config personnel
- `version, -v` :          Affiche la version
- `--testdev, --dev` :     Lance la fonction dev
<a name="config"></a>
#### Config options :
- `autoUpdate` : Maj Majeures auto et notifications de Maj Mineures
- `port` : Port utilisé pour le partage de fichiers
- `portDefaultIonicRemote` :              Port ionic
- `sharedFolderDirectory` :      Emplacement du dossier partagé par default
- `sharedFolderName` :       Nom du dosier partagé
- `ionicAppFolder` :          Chemin du projet ionic
- `symphonyAppFolder` :     Chemin du projet Symphony
##### Exemple `config_perso.txt`:

```
auto-update=true
port=3200
portDefaultIonicRemote=8100

sharedFolderDirectory=/Bureau
sharedFolderName=Shared

ionicAppFolder=/web/www/mon-sport-maison/appli-msalm
symphonyAppFolder=/web/www/mon-sport-maison/mon-sport-maison-sf 
```
Le fichier config_perso est obligatoire
# Commands :
## Ionic

### Ionic environement

- `:~$ bash msalm.sh -ie` / `bash msalm.sh ionicenv` : Lance l'environnement de dévellopement Ionic

### Ionic Update project

- `:~$ bash msalm.sh -iu` / `bash msalm.sh ioniupdate` : Lance l'environnement de dévellopement Ionic
#### Options : 
- `--open` : Lance le serveur ionic
- `--init` : Inititialise le projet Ionic ( Git + Nodes modules + ionic )

## Symphony

### Symphony environement

- `:~$ bash msalm.sh -sfe` / `bash msalm.sh sfenv` : Lance l'environnement de dévellopement Symphony

### Symphony update project

- `:~$ bash msalm.sh -sfu` / `bash msalm.sh sfupdate` : Met à jour le projet Symphony ( Git + Composer + Docktrin )
#### Option : 
- `--init` :  Initialise le projet Symphony ( Git + Composer + Docktrin )

## Share Service

### Share ( Bloque l'execution du script et du terminal )
- `:~$ bash msalm.sh -s` / `bash msalm.sh share` : Partage le dossier par default sur le réseau local et le port configuré.</br>
- `:~$ bash msalm.sh -s <PATH>` / `bash msalm.sh share <PATH>` : Partage le dossier spécifié sur le réseau local et le port configuré.
</br></br>***Attention :*** Le port configuré doit etre superieur à 1200 ( Je sais pas vraiment pourquoi en vrai mais sinon ça marche pas )
### Open Share Remote
- `:~$ bash msalm.sh -osr <PERSON>` / `bash msalm.sh openShareRemote <PERSON>` : Ouvre l'acces au partage de la personne cible via le réseau.
#### Option : 
- `--linkFile <PATH>` :  Affiche le lien de téléchargement direct ShareService du fichier cible dans la console
```
:~$ bash msalm.sh -osr paulj --linkFile Project/ionic/test.png

>> http://192.168.3.236:3200/Project/ionic/test.png
```
### Open Ionic Remote
- `:~$ bash msalm.sh -oir <PERSON>` / `bash msalm.sh openIonicRemote <PERSON>` : Ouvre le preview ionic de la personne cible via le réseau.


