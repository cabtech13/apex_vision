const express = require('express');
const cors = require('cors');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Stockage en mémoire (Disparait au redémarrage, idéal pour du pairing temporaire)
const pairingStore = new Map();

// --- ENDPOINTS POUR L'APP TV ---

// Enregistrer un code généré par la TV
app.post('/api/pairing/register', (req, res) => {
    const { code, deviceId } = req.body;
    if (!code) return res.status(400).json({ error: 'Code manquant' });
    
    // On enregistre le code avec un statut "en attente"
    pairingStore.set(code, { 
        status: 'pending', 
        deviceId, 
        createdAt: Date.now() 
    });
    
    console.log(`[TV] Code ${code} enregistré.`);
    res.json({ success: true });
});

// Vérifier si des données ont été soumises pour ce code (Polling)
app.get('/api/pairing/status/:code', (req, res) => {
    const { code } = req.params;
    const data = pairingStore.get(code);
    
    if (!data) return res.status(404).json({ error: 'Code invalide ou expiré' });
    
    if (data.status === 'success') {
        // Une seule lecture autorisée pour plus de sécurité puis on supprime
        pairingStore.delete(code);
        console.log(`[TV] Code ${code} récupéré avec succès.`);
        return res.json({ status: 'success', playlist: data.playlist });
    }
    
    res.json({ status: 'pending' });
});

// --- ENDPOINTS POUR LE WEB (MOBILE) ---

// Soumettre les données de playlist depuis le site web
app.post('/api/pairing/submit', (req, res) => {
    const { code, playlist } = req.body;
    const entry = pairingStore.get(code);

    if (!entry) return res.status(404).json({ error: 'Code invalide' });

    // On met à jour l'entrée avec les données de la playlist
    entry.status = 'success';
    entry.playlist = playlist;

    console.log(`[WEB] Données soumises pour le code ${code}.`);
    res.json({ success: true });
});

// Nettoyage automatique des vieux codes (toutes les 10 minutes)
setInterval(() => {
    const now = Date.now();
    for (const [code, data] of pairingStore.entries()) {
        if (now - data.createdAt > 10 * 60 * 1000) { // 10 minutes
            pairingStore.delete(code);
            console.log(`[SYS] Code ${code} expiré et supprimé.`);
        }
    }
}, 60000);

app.listen(PORT, () => {
    console.log(`Serveur de pairing lancé sur le port ${PORT}`);
});
