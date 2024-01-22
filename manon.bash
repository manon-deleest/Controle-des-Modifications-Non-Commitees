#!/bin/bash

# Ajout d'un message d'aide
if [ "$1" = "-help" ]; then
    printf "Contrôle des Modifications Git avec Notifications\n"
    echo "------------------------------------------"
    printf "Utilisation: bash manon.bash [DELAI] [MAX_MODIFICATIONS]\n\n"
    printf "Options:\n"
    printf "  [DELAI]             Délai entre chaque vérification en secondes. (Par défaut: 30 secondes)\n"
    printf "  [MAX_MODIFICATIONS] Nombre maximum de modifications non commit avant annulation. (Par défaut: 10)\n\n"
    printf "Description:\n"
    printf "Ce script surveille les modifications non commit dans le dépôt Git courant.\n"
    printf "Si le nombre de modifications dépasse un seuil, il envoie des notifications.\n"
    printf "Si le seuil critique est atteint, toutes les modifications non commit et non traqués sont annulées.\n\n"
    printf "Notifications:\n"
    printf "Le script utilise des notifications adaptées à la plateforme (OS X, Linux avec notify-send, Windows avec PowerShell).\n\n"
    printf "Avertissement:\n"
    printf "Assurez-vous d'être dans un dépôt Git avant d'exécuter ce script.\n"
    printf "Si le dossier courant n'est pas un dépôt Git, le script affiche un message d'erreur et se termine.\n\n"
    printf "Configuration:\n"
    printf "- Le fichier 'manon.bash' est automatiquement ajouté au fichier '.gitignore'.\n"
    printf "  Cela évite de suivre les modifications du script dans le dépôt Git.\n\n"
    exit 0
fi

# Nombre maximum de modifications non commit avant que le script n'annule toutes les modifications non commit
MAX_MODIFICATIONS=${2:-10}
# Délai entre chaque vérification (en secondes)
DELAI=${1:-30}

PLATEFORM=$(uname -s)

# Fonction pour envoyer une notification
send_notification() {
    if [ $3 = "Darwin" ]; then
        MESSAGE="display notification \"$1\" with title \"$2\""
        osascript -e "$MESSAGE"
    elif [ $3 = "Linux" ]; then
        notify-send "$2" "$1" # A tester sur Linux
    else
        powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('$1', '$2')"
    fi
}

# Get Number of modifications
get_number_of_modification(){
    # obtenir les différentes dans le fichiers traqués 
    local shortstat=$(git diff --shortstat)

    # Extraire les nombres d'insertions et de suppressions
    local insertions=$(echo "$shortstat" | grep -oE '[0-9]+ insertion')
    local deletions=$(echo "$shortstat" | grep -oE '[0-9]+ deletion')

    # Récupérer les nombres uniquement (supprimer le texte)
    local insertions_count=$(echo "$insertions" | grep -oE '[0-9]+')
    local deletions_count=$(echo "$deletions" | grep -oE '[0-9]+')

    # Obtenir le statut des fichiers
    local added=$(git status --porcelain | grep -cE '^\?\?')  # Fichiers ajoutés
    local modified=$(git status --porcelain | grep -cE '^(M|MM)')  # Fichiers modifiés
    local deleted=$(git status --porcelain | grep -cE '^(D|DD)')  # Fichiers supprimés

    # Calculer le nombre total de modifications
    local total_modifications=$((insertions_count + deletions_count + added + modified + deleted))
    echo "$total_modifications"
}

# Vérifier que le projet est un dépôt git
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Le dossier courant n'est pas un dépôt git."
    exit 1
fi

# mettre le fichier dans le gitignore
if ! grep -q "manon.bash" .gitignore; then
    echo "manon.bash" >> .gitignore
    git add .gitignore
    git commit .gitignore -m "Ajout de manon.bash dans le gitignore"
    git push
fi

while true; do

    total_modifications=$(get_number_of_modification)
    echo $total_modifications
    message=""

    if [ $total_modifications -gt $MAX_MODIFICATIONS ]; then
        message="Il y a plus de $total_modifications modifications non commit dans le dossier. Veillez remédier à la situation avant de cliquer sur OK."
        title="Annulation des modifications"
        send_notification "$message" "$title" "$PLATEFORM"

        count=$(get_number_of_modification) 
        echo $count

        if [ $count -gt $MAX_MODIFICATIONS ]; then
            message="Il y a plus de $count modifications non commit dans le dossier. Annulation des modifications..."
            title="Annulation des modifications"
            send_notification "$message" "$title" "$PLATEFORM"
            git reset --hard HEAD  # Réinitialise tous les fichiers modifiés non commit
            git clean -f # Supprime tous les fichiers non traqués
        fi

    elif [ $total_modifications -gt 0 ]; then
        echo "Attention"; 
        printf "il vous reste $(($MAX_MODIFICATIONS - $total_modifications)) modifications avant que tout soit annuler";
    fi    

    sleep $DELAI  # Attendre avant de vérifier à nouveau
done


