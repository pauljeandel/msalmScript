update() {
     cd $HOME/bin/$scriptRootFolder
     git pull
}

ionicEnv() {
     cd $HOME$ionicAppFolder
     code . #Sorry cédric
     xterm -e "bash -c \"cd $HOME$ionicAppFolder && ionic serve --external  ; exec bash\"" &
     if [ ! $? -eq 0 ]; then
          echo "[ WARNING ] Ionic serve Failed "
     fi
     xterm -e "bash -c \"polypane; exec bash\"" & #sorry tt le monde
     if [ ! $? -eq 0 ]; then
          echo "[ WARNING ] Polypane non detecté "
     fi
}

ionicEnvWS() {
     wmctrl -d
     if [ ! $? ]; then
          echo "[ INFO ] Installation de wmctrl ( Workspace controler ) : "
          sudo apt install wmctrl
     fi
     cd $HOME$ionicAppFolder
     code . #Sorry cédric
     sleep 4
     wmctrl -s "0"
     sleep 1
     xterm -e "bash -c \"cd $HOME$ionicAppFolder && ionic serve --external  ; exec bash\"" &
     if [ ! $? -eq 0 ]; then
          echo "[ WARNING ] Ionic serve Failed "
     fi
     sleep 5
     wmctrl -s "2"
     sleep 1
     xterm -e "bash -c \"polypane; exec bash\"" & #sorry tt le monde
     if [ ! $? -eq 0 ]; then
          echo "[ WARNING ] Polypane non detecté "
     fi
     sleep 3
     wmctrl -s "0"

}

ionicUpdate() {
     cd $HOME$ionicAppFolder
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
     if [ $2 ] && [ $2 = "--open" ]; then
          xterm -e "bash -c \"cd $HOME$ionicAppFolder && ionic serve --external  ; exec bash\"" &
          if [ ! $? -eq 0 ]; then
               echo "[ ERREUR ] Ionic serve Failed "
          else
               echo "[ INFO ] Ionic serveur demarré"
          fi
     fi

}

sfUpdate() {
     cd $HOME$symphonyAppFolder
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
}

sfEnv() {
     cd $HOME$symphonyAppFolder
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
     if [ $1 ] && [[ ! ${str:0:1} == "-" ]]; then

          echo "Serving on : $1"
          cd $1

     else

          echo "[ INFO ] : No PATH - Serving on config default : $HOME$sharedFolderDirectory/$sharedFolderName"

          cd $HOME$sharedFolderDirectory
          if [ ! -d $sharedFolderName ]; then
               mkdir $sharedFolderName
               echo "[ INFO ] : Creation du dossier $sharedFolderName dans le dossier $sharedFolderDirectory"
          fi
          echo "[ INFO ] : Using config port : $port "
          cd $sharedFolderName
     fi
     echo "[ Quit : Ctrl + C ]"
     echo ""
     python3 -m http.server $port
     if [ ! $? -eq 0 ]; then
          echo "[ WARNING ] Python3 server failed"
          echo "[ INFO ] Trying Python ..."
          python -m SimpleHTTPServer $port
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
     if [ $2 ] && [[ ! ${str:0:1} == "-" ]] && [[ ! ${str:0:1} == "--" ]]; then

          header="http://"
          dots=":"
          link=$header${assArray1[$2]}$dots$port
          echo "[ INFO ] Ouverture du lien ShareService de $2 à l'adresse : $link "
          xdg-open $link
     else
          echo "[ ERREUR ] Usage : bash msalm.sh -os <PERSON> "
     fi
}

openIonicRemote() {
     declare -A assArray1
     assArray1[paulj]=$ipPaulj
     assArray1[paulm]=$ipPaulm
     assArray1[cedric]=$ipCedric
     assArray1[momo]=$ipMomo

     str=$2
     if [[ ! ${str:0:1} == "-" ]] && [[ ! ${str:0:1} == "--" ]] && [ $2 ]; then
          header="http://"
          dots=":"
          link=$header${assArray1[$2]}$dots$portDefaultIonicRemote
          echo "[ INFO ] Ouverture du lien Ionic de $2 à l'adresse : $link "
          xdg-open $link
     else
          echo "[ ERREUR ] Usage : bash msalm.sh -osr <PERSON> "
     fi
}

scriptInstall() {
     if [ ! $EUID -ne 0 ]; then
          echo "Vous devez avoir les privilèges root pour installer ce script"
          [ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"
     else
          cd $HOME/bin
          if [ ! -d "$scriptRootFolder" ]; then
               mkdir -m 777 $scriptRootFolder
               cd $scriptRootFolder
               git clone $gitProjectLink
               if [ ! $? -eq 0 ]; then
                    echo "[ ERREUR ] Récupération depuis git impossible. Abandon"
                    exit 0
               else
                    echo "[ INFO ] Script installé !"
               fi
               echo '[ IMPORTANT ] Ajoutez la ligne < export PATH=$PATH:$HOME/bin/$scriptRootFolder > à votre fichier bashrc'
               echo "Man : bash msalm.sh -help "
          else
               echo "[ ERROR ] Le dossier $scriptRootFolder existe déjà, installation impossible."
               exit 1
          fi
     fi
}

checkForMajorUpdate() {

     content=$(wget $githubReleaseAPILink -q -O -)
     #put the value of the last release in a variable
     lastRelease=$(echo "$content" | tr ' ' '\n' | grep -n refs/tags/ | grep -oP '(?<=refs\/tags\/)[^"]*')

     if [ ${lastRelease:0:1} ] && [ ${lastRelease:0:1} -gt ${version:0:1} ]; then
          echo ""
          echo "----------------------------MISE A JOUR MAJEURE DISPONIBLE-----------------------------"
          echo "Latest version : ${lastRelease:0:1}.X sur $gitProjectLink"
          echo "Current version : $version.X"
          echo "---------------------------------------------------------------------------------------"
          echo ""
          echo "> RUNING : bash msalm.sh update"
          sleep 3
          update
          if [ ! $? -eq 0 ]; then
               echo "[ ERREUR ] Mise à jour impossible"
          else
               echo "[ INFO ] Mise à jour effectuée"
          fi
          echo "[ INFO ] Will Re-run last command"
          sleep 2

          exit 0

     else
          checkForMinorUpdate

     fi
}

checkForMinorUpdate() {

     content=$(wget $githubReleaseAPILink -q -O -)
     #put the value of the last release in a variable
     Releases=$(echo "$content" | tr ' ' '\n' | grep -n refs/tags/ | grep -oP '(?<=refs\/tags\/)[^"]*')
     #echo "Last release : $lastRelease"
     lastRelease="${Releases##*$'\n'}"
     if [ ${lastRelease:2:3} ] && [ ${lastRelease:2:3} -gt ${version:2:3} ]; then
          echo ""
          echo "----------------------------MISE A JOUR MINEURE DISPONIBLE-----------------------------"
          echo "Latest version : ${lastRelease:0:3} sur $gitProjectLink"
          echo "Current version : $version"
          echo "---------------------------------------------------------------------------------------"
          echo ""
          echo "> PLEASE RUN : bash msalm.sh update"
          sleep 2

     else
          if [ ! $? -eq 0 ]; then
               echo "[ ERREUR ] GitHub API Down or API Limit exceeded - Will retry later"
               echo "[INFO] Actual Version : $version"
          else
               echo "[INFO] Script a jour. Version $version"
          fi
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
     echo "Script configuré pour $projectName"
     echo "Usage : bash msalm.sh -[COMMAND] <ARGS> --[OPTION] "
     echo ""
     echo "  help, -h                                   Affiche ce message et quitte"
     echo "  scriptInstall, -si                         NE PAS UTILISER GENRE VRAIMENT PAS DU TOUT Installe ce script de manière définitive. Nécessite les privilèges Root ( Marche pas )"
     echo "  --testDev, --dev                           Teste la fonctionnalité de développement"
     echo "  editScript, -es                            Edite le script sur VsCode"
     echo "  update                                     Mise à jour du projet git"
     echo "  version, -v                                Version"
     echo ""
     echo "  share, -s <PATH>                           Partage le dossier spécifié sur le réseau local. Port : $port"
     echo "                                             Default :  $HOME$sharedFolderDirectory/$sharedFolderName "
     echo "  openShareRemote, -osr <PERSON>                    Ouvre le lien de partage de fichier. PERSON = [ paulj , paulm , cedric , momo ]"
     echo ""
     echo "  ionicenv, -ie                              Lance l'environnement de dévellopement Ionic"
     echo "  ionicupdate, -iu [options]                 Met à jour le projet Ionic ( Git + Nodes modules )"
     echo "              --init                                    Inititialise le projet Ionic ( Git + Nodes modules + ionic )( TODO )"
     echo "              --open                                    Lance le serveur ionic"
     echo "  openIonicRemote, -oir <PERSON>             Ouvre le preview ionic à distance. PERSON = [ paulj , paulm , cedric , momo ]"
     echo ""
     echo "  sfenv, -sfe                                Lance l'environnement de dévellopement Symphony ( TODO )"
     echo "  sfupdate, -sfu [options]                   Met à jour le projet Symphony ( Git + Composer + Docktrin )"
     echo "              --init                                    Initialise le projet Symphony ( TODO )"
     echo ""
     echo "Git project : $gitProjectLink"
     echo "------------------------------------------------------------------------------------------------------------------------------"
}

source config_default.txt
checkForMajorUpdate
until [ ! $1 ]; do
     case $1 in
     "-h" | "help") helper ;;
     "version" | "-v") echo "Version : $version" ;;
     "update") update ;;
     #"scriptInstall" | "-si") scriptInstall ;;
     "share" | "-s") share $@ ;;
     "openShareRemote" | "-osr")
          openshare $@
          if [[ ! ${str:0:1} == "-" ]]; then
               shift
          fi
          ;;
     "sfEnv" | "-sfe") sfEnv ;;
     "sfUpdate" | "-sfu")
          sfUpdate $@
          if [ $2 = "--init" ]; then
               shift
          fi
          ;;

     "ionicEnv" | "-ie") ionicEnv ;;
     "ionicUpdate" | "-iu")
          ionicUpdate $@
          if [ $2 ] &&  [ $2 = "--open" ] || [ $2 = "--init" ]; then
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
     "editScript" | "-es") cd $HOME/bin && code . ;;
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



