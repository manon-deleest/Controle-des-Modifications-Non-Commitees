# Script de Contrôle des Modifications Non Commitées

Ce script Bash a été créé dans le but d'aider à contrôler les modifications non commitées dans un dépôt Git en notifiant les utilisateurs lorsque le nombre de modifications dépasse un seuil défini.

## Fonctionnalités

- Vérifie périodiquement le statut du dépôt Git pour détecter les modifications non commitées.
- Envoie des notifications pour avertir les utilisateurs en cas de dépassement du nombre maximum de modifications non commitées.
- Réinitialise automatiquement les modifications non commitées si le nombre reste élevé après l'avertissement envoyé à l'utilisateur.

## Utilisation

Exécutez le script en ligne de commande :
```bash
./manon.bash [DELAI] [MAX_MODIFICATIONS]
```

### Options :
- `[DELAI]` : Délai entre chaque vérification en secondes. (Par défaut: 30 secondes)
- `[MAX_MODIFICATIONS]` : Nombre maximum de modifications non commitées autorisées avant de déclencher une notification et éventuellement une réinitialisation. (Par défaut: 10)

## Notifications

- Les notifications sont envoyées en fonction du système d'exploitation :
  - Sur macOS, les notifications sont affichées via `osascript`.
  - Sur Linux, elles utilisent `notify-send`.
  - Sur Windows, elles s'appuient sur `powershell`.

## Contributions et Améliorations

Les contributions sous forme de suggestions, d'améliorations ou de correctifs sont les bienvenues. N'hésitez pas à ouvrir une pull request ou à soumettre une issue pour discuter des modifications.

## Remarques

- Ce script peut annuler automatiquement les modifications non commitées. Utilisez-le avec prudence ! 

---
Auteur : Manon DELEEST