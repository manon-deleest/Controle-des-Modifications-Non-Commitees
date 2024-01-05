# Script de Contrôle des Modifications Non Commitées (Git Commit Reminder)

Ce script Bash a été créé dans le but d'aider à contrôler les modifications non commitées dans un dépôt Git en notifiant les utilisateurs lorsque le nombre de modifications dépasse un seuil défini.

## Fonctionnalités

- Vérifie périodiquement le statut du dépôt Git pour détecter les modifications non commitées.
- Envoie des notifications pour avertir les utilisateurs en cas de dépassement du nombre maximum de modifications non commitées.
- Réinitialise automatiquement les modifications non commitées si le nombre reste élevé pendant une certaine période.

## Utilisation

1. Assurez-vous d'avoir les permissions d'exécution sur le script : `chmod +x manon.bash`.
2. Exécutez le script en ligne de commande : `./manon.bash`.
3. Le script tourne en arrière-plan et surveille les modifications non commitées dans le dépôt Git.

## Configuration

- `MAX_MODIFICATIONS`: Nombre maximum de modifications non commitées autorisées avant de déclencher une notification et éventuellement une réinitialisation.
- `DELAY`: Délai en secondes entre chaque vérification du statut des modifications.

## Notifications

- Les notifications sont envoyées en fonction du système d'exploitation :
  - Sur macOS, les notifications sont affichées via `osascript`.
  - Sur Linux, elles utilisent `notify-send`.
  - Sur Windows, elles s'appuient sur `powershell`.

## Contributions et Améliorations

Les contributions sous forme de suggestions, d'améliorations ou de correctifs sont les bienvenues. N'hésitez pas à ouvrir une pull request ou à soumettre une issue pour discuter des modifications.

## Remarques

- Ce script peut annuler automatiquement les modifications non commitées. Utilisez-le avec prudence et informez les utilisateurs des conséquences potentielles.
- Testez le script dans différents environnements avant une utilisation en production.

## Licence

Ce script est distribué sous la licence MIT. Voir le fichier `LICENSE` pour plus de détails.

---
Auteur : Manon DELEEST 

