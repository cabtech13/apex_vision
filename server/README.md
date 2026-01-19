# Apex Vision Pairing Server

Serveur de pairing Node.js/Express pour l'application IPTV Apex Vision.

## Déploiement sur Render

1.  Créez un compte sur [Render.com](https://render.com).
2.  Cliquez sur **"New +"** > **"Web Service"**.
3.  Connectez votre dépôt GitHub.
4.  Configurez le service :
    - **Name** : `apex-vision-pairing`
    - **Environment** : `Node`
    - **Build Command** : `npm install`
    - **Start Command** : `npm start`
5.  Une fois déployé, récupérez l'URL (ex: `https://votre-app.onrender.com`).

## Mise à jour des URLs

Après le déploiement, n'oubliez pas de mettre à jour :
1.  `web_pairing/script.js` -> `const SERVER_URL = 'https://votre-app.onrender.com';`
2.  `lib/data/services/pairing_service.dart` -> `final String _pairingBaseUrl = 'https://votre-app.onrender.com/api/pairing';`
