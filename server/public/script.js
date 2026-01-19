document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('pairing-form');
    const tabBtns = document.querySelectorAll('.tab-btn');
    const m3uFields = document.getElementById('m3u-fields');
    const xtreamFields = document.getElementById('xtream-fields');
    const statusMessage = document.getElementById('status-message');
    const successScreen = document.getElementById('success-screen');
    let currentType = 'm3u';

    // Tab Switching Logic
    tabBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            tabBtns.forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            
            currentType = btn.dataset.type;
            if (currentType === 'm3u') {
                m3uFields.classList.remove('hidden');
                xtreamFields.classList.add('hidden');
            } else {
                m3uFields.classList.add('hidden');
                xtreamFields.classList.remove('hidden');
            }
        });
    });

    // CONFIGURATION : Remplacez par votre URL de serveur une fois en ligne
    const SERVER_URL = 'https://apex-vision-server.onrender.com';

    // Form Submission
    form.addEventListener('submit', async (e) => {
        e.preventDefault();
        
        const pairCode = document.getElementById('pair-code').value;
        const playlistName = document.getElementById('playlist-name').value;
        
        let playlistData = {
            type: currentType,
            name: playlistName || 'Remote Playlist'
        };

        if (currentType === 'm3u') {
            playlistData.url = document.getElementById('m3u-url').value;
        } else {
            playlistData.serverUrl = document.getElementById('server-url').value;
            playlistData.username = document.getElementById('username').value;
            playlistData.password = document.getElementById('password').value;
        }

        // Show loading
        form.classList.add('hidden');
        statusMessage.classList.remove('hidden');

        try {
            const response = await fetch(`${SERVER_URL}/api/pairing/submit`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ code: pairCode, playlist: playlistData })
            });

            const result = await response.json();

            if (response.ok) {
                // Succès
                statusMessage.classList.add('hidden');
                successScreen.classList.remove('hidden');
            } else {
                throw new Error(result.error || "Une erreur est survenue");
            }
            
        } catch (error) {
            alert('Erreur: ' + error.message);
            form.classList.remove('hidden');
            statusMessage.classList.add('hidden');
        }
    });
});
