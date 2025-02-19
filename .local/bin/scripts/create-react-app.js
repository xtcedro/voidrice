const fs = require("fs"); const path = require("path"); const express = require("express");

// Project root directory const projectRoot = path.join(__dirname, "landing-page");

// Folder structure const folders = [ "public", "src", "src/components" ];

// Files and their contents const files = { "public/index.html": `<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Landing Page</title>
</head>
<body>
    <div id="root"></div>
    <script src="../src/index.js"></script>
</body>
</html>`,"src/index.js": `import React from 'react'; import ReactDOM from 'react-dom/client'; import App from './App'; import './styles.css';

const root = ReactDOM.createRoot(document.getElementById('root')); root.render(<App />); `,

"src/App.js": `import React from 'react'; import Header from './components/Header'; import HeroSection from './components/HeroSection'; import Footer from './components/Footer';

function App() { return ( <div> <Header /> <HeroSection /> <Footer /> </div> ); }

export default App; `,

"src/components/Header.js": `import React from 'react';

function Header() { return ( <header> <h1>Welcome to Our Landing Page</h1> </header> ); }

export default Header; `,

"src/components/HeroSection.js": `import React from 'react';

function HeroSection() { return ( <section> <h2>Your Business Solution</h2> <p>We provide the best services to boost your business.</p> <button>Get Started</button> </section> ); }

export default HeroSection; `,

"src/components/Footer.js": `import React from 'react';

function Footer() { return ( <footer> <p>© 2025 Your Company. All Rights Reserved.</p> </footer> ); }

export default Footer; `,

"src/styles.css": `body { font-family: Arial, sans-serif; text-align: center; margin: 0; padding: 0; background: #f4f4f4; }

header, footer { background: #333; color: white; padding: 1rem; }

section { margin: 2rem; padding: 2rem; background: white; border-radius: 5px; } `,

"package.json": JSON.stringify({ "name": "landing-page", "version": "1.0.0", "description": "A simple React landing page", "main": "server.js", "scripts": { "start": "node server.js", "build": "react-scripts build" }, "dependencies": { "express": "^4.17.1", "react": "^18.0.0", "react-dom": "^18.0.0", "react-scripts": "^5.0.0" } }, null, 2),

"server.js": `const express = require('express'); const path = require('path'); const fs = require('fs');

const app = express(); const PORT = process.env.PORT || 3000;

// Ensure the build folder exists const buildPath = path.join(__dirname, 'build'); if (!fs.existsSync(buildPath)) { console.error("❌ Build folder missing! Run npm run build first."); process.exit(1); }

// Serve static files from the React app's build directory app.use(express.static(buildPath));

// Serve index.html for all unknown routes (Single Page Application behavior) app.get('*', (req, res) => { res.sendFile(path.join(buildPath, 'index.html')); });

app.listen(PORT, () => { console.log(✅ Server is running on http://localhost:${PORT}); }); `,

"README.md": `# Landing Page

This is a simple React landing page.

Setup

1. Install dependencies: ``` npm install ```


2. Build the React app: ``` npm run build ```


3. Start the server: ``` npm start ``` ` };



// Create folders folders.forEach(folder => { fs.mkdirSync(path.join(projectRoot, folder), { recursive: true }); });

// Create files Object.entries(files).forEach(([filename, content]) => { fs.writeFileSync(path.join(projectRoot, filename), content); });

console.log("✅ React landing page setup complete! Run cd landing-page && npm install to continue.");

