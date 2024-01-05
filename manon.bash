#!/bin/bash

MAX_MODIFICATIONS=3
DELAI=30

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
        fi

    elif [ $total_modifications -gt 0 ]; then
        title="Attention"
        message="il vous reste $(($MAX_MODIFICATIONS - $total_modifications)) modifications avant que tout soit annuler"
        send_notification "$message" "$title" "$PLATEFORM"
    fi    

    sleep $DELAI  # Attendre avant de vérifier à nouveau
done


