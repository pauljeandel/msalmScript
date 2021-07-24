update() {
     cd $HOME/bin/msalmScript
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
     if [ $2 = "--open" ]; then
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

          echo "[ WARNING ] : No PATH - Serving on default : $HOME$sharedFolder/MsalmShared"
          cd $HOME$sharedFolder
          if [ ! -d MsalmShared ]; then
               mkdir MsalmShared
               echo "[ INFO ] : Creation du dossier MsalmShared dans le dossier $sharedFolder"
          fi
          cd MsalmShared
     fi
     echo "[ Quit : Ctrl + C ]"
     echo ""
     python3 -m http.server $port
     if [ ! $? -eq 0 ]; then
          echo "[ WARNING ] Python3 server failed"
          echo "[ INFO ] Trying Python ..."
          python -m SimpleHTTPServer $port
          if [ ! $? -eq 0 ]; then
               echo "[ WARNING ] Python server failed"
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
     if [ $EUID -ne 0 ]; then
          echo "Vous devez avoir les privilèges root pour installer ce script"
          [ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"
     else
          cd $HOME/bin
          if [ ! -d "msalmScript" ]; then
               mkdir -m 777 msalmScript
               mv msalm.sh $HOME/bin/msalmScript/msalm.sh
               echo "Script installé !"
               echo '[ IMPORTANT ] Ajoutez la ligne < export PATH=$PATH:$HOME/bin/msalmScript > à votre fichier bashrc'
               echo "Man : bash msalm.sh -help "
          else
               echo "[ ERROR ] Le dossier msalmScript existe déjà, installation impossible."
               exit 1
          fi
     fi
}

checkForUpdate() {

     content=$(wget $githubReleaseLink -q -O -)
     #put the value of the last release in a variable
     lastRelease=$(echo "$content" | tr ' ' '\n' | grep -n /pauljeandel/msalmScript/releases/tag/ | grep -oP '(?<=tag\/)[^"]*')

     if [ ${lastRelease:0:1} -gt ${version:0:1} ]; then
          echo ""
          echo "----------------------------MISE A JOUR MAJEURE DISPONIBLE-----------------------------"
          echo "Live version : ${lastRelease:0:1}.X sur $githubReleaseLink"
          echo "Current  : $version.X"
          echo "---------------------------------------------------------------------------------------"
          echo ""
          echo "> RUNING : bash msalm.sh update"
          sleep 3
          update
          if [ ! $? -eq 0 ]; then
               echo "[ ERREUR ] Mise à jour impossible"
          else
               echo "[ INFO ] Mise à jour effectuée"
               #il faut mettre la nouvelle version dans la config sinon ce sera jamais pris en compte


          fi
          exit 0

     else
          echo "[INFO] Script a jour. GG ! "
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
     echo "Git project : https://github.com/pauljeandel/msalmScript.git"
     echo ""
     echo "  help, -h                                   Affiche ce message et quitte"
     echo "  scriptInstall, -si                         NE PAS UTILISER GENRE VRAIMENT PAS DU TOUT Installe ce script de manière définitive. Nécessite les privilèges Root ( Marche pas )"
     echo "  --testDev, --dev                           Teste la fonctionnalité de développement"
     echo "  editScript, -es                            Edite le script sur VsCode"
     echo "  update                                     Mise à jour du projet git"
     echo "  version, -v                                Version"
     echo ""
     echo "  share, -s <PATH>                           Partage le dossier spécifié sur le réseau local. Port : $port"
     echo "                                             Default :  $HOME$sharedFolder /msalmShared "
     echo "  openShareRemote, -osr <PERSON>                    Ouvre le lien de partage de fichier. PERSON = [ paulj , paulm , cedric , momo ]"
     echo ""
     echo "  ionicenv, -ie                              Lance l'environnement de dévellopement Ionic"
     echo "  ionicupdate, -iu [options]                 Met à jour le projet Ionic ( Git + Nodes modules )"
     echo "              --init <PATH> <GIT-URL>                   Inititialise le projet Ionic ( Git + Nodes modules + ionic )( TODO )"
     echo "              --open                                    Lance le serveur ionic"
     echo "  openIonicRemote, -oir <PERSON>             Ouvre le preview ionic à distance. PERSON = [ paulj , paulm , cedric , momo ]"
     echo ""
     echo "  sfenv, -sfe                                Lance l'environnement de dévellopement Symphony ( TODO )"
     echo "  sfupdate, -sfu [options]                   Met à jour le projet Symphony ( Git + Composer + Docktrin )"
     echo "              --init <PATH> <GIT-URL>                   Initialise le projet Symphony ( TODO )"
     echo ""
     echo "------------------------------------------------------------------------------------------------------------------------------"
}

source config_default.txt
checkForUpdate
until [ ! $1 ]; do
     case $1 in
     "-h" | "help") helper ;;
     "version" | "-v") echo "Version : $version" ;;
     "update") update ;;
     "scriptInstall" | "-si") scriptInstall ;;
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
          if [ $2 = "--open" ] || [ $2 = "--init" ]; then
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
