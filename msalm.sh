#!/bin/bash

update() {
     cd "$HOME"/bin/"$scriptRootFolder" || exit

     if ! git pull; then
          echo "[ ERREUR ] Mise à jour impossible"
     else
          echo ""
          RED='\033[0;31m'
          NC='\033[0m' # No Color
          printf "${RED}[ INFO ] Le script est à jour.${NC}\n"
     fi
}

ionicEnv() {
     cd "$HOME""$ionicAppFolder" || exit
     code . #Sorry cédric
     xterm -e "bash -c \"cd $HOME$ionicAppFolder && ionic serve --external  ; exec bash\"" &
     xterm -e "bash -c \"polypane; exec bash\"" & #sorry tt le monde

}

ionicEnvWS() {
     wmctrl -d
     if [ ! $? ]; then
          echo "[ INFO ] Installation de wmctrl ( Workspace controler ) : "
          sudo apt install wmctrl
     fi
     cd "$HOME""$ionicAppFolder" || exit
     code . #Sorry cédric
     sleep 4
     wmctrl -s "0"
     sleep 1
     xterm -e "bash -c \"cd $HOME$ionicAppFolder && ionic serve --external  ; exec bash\"" &
     sleep 5
     wmctrl -s "2"
     sleep 1
     xterm -e "bash -c \"polypane; exec bash\"" & #sorry tt le monde
     sleep 3
     wmctrl -s "0"

}

ionicUpdate() {

     if [ "$2" ] && [ "$2" = "--init" ]; then
          git clone "$gitRepoIonic" "$HOME""$ionicAppFolder"
          cd "$HOME""$ionicAppFolder" || exit
          npm install
          ionic -v
          if [ ! $? -eq 0 ]; then
               sudo npm install -g @ionic/cli
          fi
          RED='\033[0;31m'
          NC='\033[0m' # No Color
          printf "${RED}Installation terminé !${NC}\n"
     else

          cd "$HOME""$ionicAppFolder" || exit
          git pull
          if [ ! $? -eq 0 ]; then
               echo "[ ERREUR ] Mise à jour du projet git impossible"
               exit 1
          else
               echo "[ INFO ] Mise à jour du projet git effectuée"
          fi
          npm install
          if [ ! $? -eq 0 ]; then
               echo "[ ERREUR ] Mise à jour des modules npm impossible"
               exit 1
          else
               echo "[ INFO ] Mise à jour des modules npm effectuée"
          fi
          if [ "$2" ] && [ "$2" = "--open" ]; then
               xterm -e "bash -c \"cd $HOME$ionicAppFolder && ionic serve --external  ; exec bash\"" &
          fi
     fi
}

sfUpdate() {
     if [ "$2" ] && [ "$2" = "--init" ]; then
          echo "in progress .."
     else
          cd "$HOME""$symphonyAppFolder" || exit
          git pull
          if [ ! $? -eq 0 ]; then
               echo "[ ERREUR ] Mise à jour du projet impossible"
               exit 1
          fi
          composer update
          if [ ! $? -eq 0 ]; then
               echo "[ ERREUR ] Mise à jour du projet impossible"
               exit 1
          fi
          php bin/console d:s:u --force
          php bin/console cache:clear
          php bin/console cache:clear --env=prod
     fi
}

sfEnv() {
     cd "$HOME""$symphonyAppFolder" || exit
     code . #Sorry cédric
     xterm -e "bash -c \"postman; exec bash\"" &
}

share() {

     echo ""
     echo "------------IP LOCALE-------------"
     ip -4 addr | grep -oP '(?<=inet\s)\d+(\.\d+){3}'
     echo "----------------------------------"
     echo ""
     shift
     if [ "$1" ] && [[ ! ${str:0:1} == "-" ]]; then

          echo "Serving on : $1"
          echo "[ INFO ] : Config port : $port "
          cd "$1" || exit

     else

          echo "[ INFO ] : No PATH - Serving on config default : $HOME$sharedFolderDirectory/$sharedFolderName"

          cd "$HOME""$sharedFolderDirectory" || exit
          if [ ! -d "$sharedFolderName" ]; then
               mkdir "$sharedFolderName"
               echo "[ INFO ] : Creation du dossier $sharedFolderName dans le dossier $sharedFolderDirectory"
          fi
          echo "[ INFO ] : Config port : $port "
          cd "$sharedFolderName" || exit
     fi
     echo "[ Quit : Ctrl + C ]"
     echo ""
     python3 -m http.server "$port"
     if [ ! $? -eq 0 ]; then
          echo "[ WARNING ] Python3 server failed"
          echo "[ INFO ] Trying Python ..."
          python -m SimpleHTTPServer "$port"
          if [ ! $? -eq 0 ]; then
               echo "[ WARNING ] Python server failed. Please verify your python3 or python install"
               echo "[ INFO ] Usage : bash msalm.sh -s <PATH> "
               exit 1
          fi
     fi

     exit 0 #End of the script

}

openshare() {

     declare -A assArray1
     assArray1[paulj]=$ipPaulj
     assArray1[paulm]=$ipPaulm
     assArray1[cedric]=$ipCedric
     assArray1[momo]=$ipMomo

     str=$2
     if [ "$2" ] && [[ ! ${str:0:1} == "-" ]] && [[ ! ${str:0:1} == "--" ]]; then

          header="http://"
          dots=":"
          linkToFile=$header${assArray1[$2]}$dots$port

          if [ "$3" ] && [ "$3" = "--linkFile" ]; then
               str2=$4
               if [ "$4" ] && [[ ! ${str2:0:1} == "-" ]] && [[ ! ${str2:0:1} == "--" ]]; then
                    linkToFile=$linkToFile/$4
                    RED='\033[0;31m'
                    NC='\033[0m' # No Color
                    printf "Direct link for $str : ${RED}$linkToFile${NC}\n"

               else
                    echo "[ ERREUR ] Pas de fichier à ouvrir" && exit 1
               fi
          else
               echo "[ INFO ] Ouverture du lien ShareService de $2 à l'adresse : $linkToFile "
               xdg-open "$linkToFile"
          fi
     else
          echo "[ ERREUR ] OpenShareServiceRemote Usage : bash msalm.sh -osr <PERSON> "
          #display assArray1 in one line
          echo "[ INFO ] PERSON is in the following : "
          for key in ${!assArray1[@]}; do
               echo ">    $key"
          done
          exit 0
     fi
}

openIonicRemote() {
     declare -A assArray1
     assArray1[paulj]=$ipPaulJ
     assArray1[paulm]=$ipPaulM
     assArray1[cedric]=$ipCedric
     assArray1[momo]=$ipMomo

     str=$2
     if [[ ! ${str:0:1} == "-" ]] && [[ ! ${str:0:1} == "--" ]] && [ "$2" ]; then
          header="http://"
          dots=":"
          link=$header${assArray1[$2]}$dots$portDefaultIonicRemote
          echo "[ INFO ] Ouverture du lien Ionic de $2 à l'adresse : $link "
          xdg-open "$link"
     else
          echo "[ ERREUR ] IonicShareRemote Usage : bash msalm.sh -osr <PERSON> "
          #display assArray1 in one line
          echo "[ INFO ] PERSON is in the following : "
          for key in ${!assArray1[@]}; do
               echo ">    $key"
          done
          exit 0
     fi
}

scriptInstall() {
     if [ ! $EUID -ne 0 ]; then
          echo "Vous devez avoir les privilèges root pour installer ce script"
          [ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"
     else
          cd "$HOME"/bin || exit
          #TODO : script install
     fi
}

checkForMajorUpdate() {

     content=$(wget $githubReleaseLink -q -O -)
     #put the value of the last release in a variable
     lastRelease=$(echo "$content" | tr ' ' '\n' | grep -n /pauljeandel/msalmScript/releases/tag/ | grep -oP '(?<=tag\/)[^"]*')

     if [ "${lastRelease:0:1}" ] && [ "${lastRelease:0:1}" -gt "${version:0:1}" ]; then
          echo ""
          echo "----------------------------MISE A JOUR MAJEURE DISPONIBLE-----------------------------"
          echo "Latest version : ${lastRelease:0:1}.X sur $gitProjectLink"
          echo "Current version : $version.X"
          echo "---------------------------------------------------------------------------------------"
          echo ""
          echo "> RUNING : bash msalm.sh update"
          sleep 3
          update
          sleep 1
          exit 0

     else
          checkForMinorUpdate

     fi
}

checkForMinorUpdate() {

     content=$(wget $githubReleaseLink -q -O -)
     #put the value of the last release in a variable
     lastRelease=$(echo "$content" | tr ' ' '\n' | grep -n /pauljeandel/msalmScript/releases/tag/ | grep -oP '(?<=tag\/)[^"]*')
     LIVEVERSION=(${lastRelease[@]})

     if [ "${LIVEVERSION[0]:2:3}" ] && [ "${LIVEVERSION[0]:2:3}" -gt "${version:2:3}" ]; then
          echo ""
          echo "----------------------------MISE A JOUR MINEURE DISPONIBLE-----------------------------"
          echo "Latest version : ${LIVEVERSION[0]} sur $gitProjectLink"
          echo "Current version : $version"
          echo "---------------------------------------------------------------------------------------"
          echo ""
          echo "> PLEASE RUN : bash msalm.sh update"
          sleep 2

     else
          echo "[ AUTO UPDATE ] Script a jour."
          sleep 1
     fi
}

testDev() {
     echo ""
     echo "============================DEV TEST ==================================="
     echo ""

     echo ""
     echo "========================================================================"
     echo ""

}

helper() {
     echo "------------------------------------------------------------------------------------------------------------------------------"
     echo ""
     echo "[ INFO ] Script configuré pour : $projectName"
     echo "[ INFO ] Usage : bash msalm.sh [COMMAND] <ARGS> --[OPTION] "
     echo ""
     echo "  help, -h                                   Affiche ce message et quitte"
     echo "  scriptInstall, -si                         Installe ce script de manière définitive. Nécessite les privilèges Root ( Marche pas )"
     echo "  --testDev, --dev                           Teste la fonctionnalité de développement"
     echo "  editScript, -es                            Edite le script sur VsCode"
     echo "  editConfig, -ec                            Edite le fichier de config personnel avec nano"
     echo "  update                                     Mise à jour du projet git"
     echo "  version, -v                                Version"
     echo ""
     echo "  share, -s <PATH>                           Partage le dossier spécifié sur le réseau local. Port : $port"
     echo "                                             Default :  $HOME$sharedFolderDirectory/$sharedFolderName "
     echo "  openShareRemote, -osr <PERSON>             Ouvre le lien de partage de fichier. PERSON = [ paulj , paulm , cedric , momo ]"
     echo "              --linkFile                                Affiche le lien de léléchargement direct du fichier cible "
     echo "  openIonicRemote, -oir <PERSON>             Ouvre le preview ionic à distance. PERSON = [ paulj , paulm , cedric , momo ]"
     echo ""
     echo "  ionicenv, -ie                              Lance l'environnement de dévellopement Ionic"
     echo "  ionicupdate, -iu [options]                 Met à jour le projet Ionic ( Git + Nodes modules )"
     echo "              --init                                    Inititialise le projet Ionic ( Git + Nodes modules + ionic )" #TODO : ionic
     echo "              --open                                    Lance le serveur ionic"
     echo ""
     echo "  sfenv, -sfe                                Lance l'environnement de dévellopement Symphony ( TODO )" #TODO : sf
     echo "  sfupdate, -sfu [options]                   Met à jour le projet Symphony ( Git + Composer + Docktrin )"
     echo "              --init                                    Initialise le projet Symphony ( TODO )" #TODO : sf
     echo ""
     echo "[ INFO ] Git project : $gitProjectLink"
     echo "[ INFO ] Release note : https://github.com/$gitAccount/$repoName/releases/tag/$version"
     echo ""
     echo "------------------------------------------------------------------------------------------------------------------------------"
}

scriptRootFolder="msalmScript"
cd "$HOME/bin/$scriptRootFolder" || exit

if [ -f "config_default.txt" ]; then
     source config_default.txt

else
     echo "[ ERREUR ] No config file"
     exit 1
fi

if [ -f "config_perso.txt" ]; then
     source config_perso.txt
     if [ $autoupdate = "true" ]; then
          checkForMajorUpdate
          echo ""
     else
          echo "[ INFO ] Mise à jour auto désactivées"
     fi
else
     RED='\033[0;31m'
     NC='\033[0m' # No Color
     printf "${RED}[ ERREUR ] No personnal config file - Script Wont Work${NC}\n"
     printf "${RED}Reduce to : -h --dev Working for Github integration testing only.${NC}\n"
     helper

fi

until [ ! "$1" ]; do
     case $1 in
          "-h" | "help") helper ;;
          "version" | "-v") echo "Version : $version" ;;
          "update" | "-u") update ;;
               #"scriptInstall" | "-si") scriptInstall ;;
          "share" | "-s") share $@ ;;
          "openShareRemote" | "-osr")
               openshare $@
               if [[ ! ${str:0:1} == "-" ]]; then
                    shift
               fi
               if [[ $2 == "--linkFile" ]] && [[ ! ${str2:0:1} == "-" ]]; then
                    shift
                    shift
               fi
               ;;
          "sfEnv" | "-sfe") sfEnv ;;
          "sfUpdate" | "-sfu")
               sfUpdate $@
               if [ "$2" = "--init" ]; then
                    shift
               fi
               ;;

          "ionicEnv" | "-ie") ionicEnv ;;
          "ionicUpdate" | "-iu")
               ionicUpdate $@
               if [ "$2" ] && [ "$2" = "--open" ] || [ "$2" = "--init" ]; then
                    shift
               fi
               ;;
          "openIonicRemote" | "-oir")
               openIonicRemote $@
               if [[ ! ${str:0:1} == "-" ]]; then
                    shift
               fi
               ;;
          "-ieu" | "-iue") exec bash "$0" "-iu" "-ie" ;;
          "-sfeu" | "-sfue") exec bash "$0" "-sfu" "-sfe" ;;
          "ionicEnv--flemme" | "-ief") ionicEnvWS ;;
          "editScript" | "-es") cd "$HOME"/bin && code . ;;
          "editConfig" | "-ec") sudo nano "$HOME"/bin/"$scriptRootFolder"/config_perso.txt ;;
          "--testDev" | "--dev") testDev ;;
          "")
               echo "OPTION INVALIDE : $1"
               echo "Usage : bash msalm.sh -[COMMAND] <ARGS> --[OPTION] "
               helper
               exit 1
               ;;
          *)
               echo "[ ERREUR ] Argument invalide : $1"
               helper
               exit 1
               ;;
     esac
     shift
done
