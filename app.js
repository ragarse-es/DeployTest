const express = require('express');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3100;

// Servir archivos estáticos desde la carpeta 'public'
app.use(express.static(path.join(__dirname, 'public')));

// Ruta principal que sirve el HTML
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Iniciar el servidor
app.listen(PORT, () => {
    console.log(`X20Edge Deploy Test Server running on port ${PORT}`);
    console.log(`Access at: http://localhost:${PORT}`);
});