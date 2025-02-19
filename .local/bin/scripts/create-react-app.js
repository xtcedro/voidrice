const fs = require('fs'); const { execSync } = require('child_process');

// Function to create directories 
function createDir(path) { if (!fs.existsSync(path)) { fs.mkdirSync(path, { recursive: true }); console.log(Created directory: ${path}); } }

// Function to write files 
function createFile(path, content) { fs.writeFileSync(path, content); console.log(Created file: ${path}); }

// Set up main project folder and subdirectories
 const projectName = "my_fullstack_app"; createDir(projectName); createDir(${projectName}/frontend); createDir(${projectName}/backend);

// Initialize package.json for frontend and backend 
execSync(cd ${projectName}/frontend && npm init -y, { stdio: 'inherit' }); execSync(cd ${projectName}/backend && npm init -y, { stdio: 'inherit' });

// Install dependencies 
console.log("Installing frontend dependencies..."); execSync(cd ${projectName}/frontend && npm install react react-dom react-router-dom, { stdio: 'inherit' }); execSync(cd ${projectName}/frontend && npm install --save-dev vite, { stdio: 'inherit' });

console.log("Installing backend dependencies..."); execSync(cd ${projectName}/backend && npm install express cors dotenv, { stdio: 'inherit' });

// Create frontend files 
createFile(${projectName}/frontend/index.html, `

<!DOCTYPE html><html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>React App</title>
</head>
<body>
    <div id="root"></div>
    <script type="module" src="/src/index.js"></script>
</body>
</html>`);createDir(${projectName}/frontend/src); createFile(${projectName}/frontend/src/index.js, ` import React from 'react'; import ReactDOM from 'react-dom/client'; import App from './App';

const root = ReactDOM.createRoot(document.getElementById('root')); root.render(<App />); `);

createFile(${projectName}/frontend/src/App.js, ` import React from 'react';

function App() { return ( <div> <h1>Welcome to My React App</h1> </div> ); }

export default App; `);

// Create backend files createFile(${projectName}/backend/index.js, ` const express = require('express'); const cors = require('cors'); const dotenv = require('dotenv');

dotenv.config(); const app = express(); const PORT = process.env.PORT || 5000;

app.use(cors()); app.use(express.json());

app.get('/', (req, res) => { res.send('Hello from Express backend!'); });

app.listen(PORT, () => { console.log(`Server running on http://localhost:${PORT}`); }); `);

console.log("Setup completed! Run 'cd my_fullstack_app/frontend && npm run dev' to start the React app.");

