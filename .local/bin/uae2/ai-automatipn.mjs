#!/usr/bin/env node

import { execSync } from "child_process";
import os from "os";
import express from "express";
import { WebSocketServer } from "ws";

// Configuration
const platform = os.platform();
const HTTP_PORT = process.env.HTTP_PORT || 3000;
const WS_PORT = process.env.WS_PORT || 8080;
const SAFE_COMMANDS = ["clear-cache", "update-system", "optimize-system", "deploy-app", "restart-services"];

// Function to execute safe commands
const executeCommand = (command) => {
    if (!SAFE_COMMANDS.includes(command)) {
        console.log(`❌ Command "${command}" is not allowed.`);
        return "❌ Command not allowed.";
    }

    console.log(`🚀 Executing AI Automation: ${command}`);

    try {
        switch (command) {
            case "clear-cache":
                if (platform === "linux" || platform === "darwin") execSync("sudo sync && sudo purge", { stdio: "inherit" });
                if (platform === "win32") execSync("powershell.exe Clear-DnsClientCache", { stdio: "inherit" });
                break;
            case "update-system":
                if (platform === "linux") execSync("sudo apt update && sudo apt upgrade -y", { stdio: "inherit" });
                if (platform === "darwin") execSync("softwareupdate -ia", { stdio: "inherit" });
                if (platform === "win32") execSync("powershell.exe Install-Module PSWindowsUpdate -Force", { stdio: "inherit" });
                break;
            case "optimize-system":
                if (platform === "linux") execSync("sudo apt autoremove -y && sudo apt clean", { stdio: "inherit" });
                if (platform === "darwin") execSync("brew cleanup", { stdio: "inherit" });
                if (platform === "win32") execSync("powershell.exe Cleanmgr /sagerun:1", { stdio: "inherit" });
                break;
            case "deploy-app":
                execSync("git pull origin main && npm install && pm2 restart all", { stdio: "inherit" });
                break;
            case "restart-services":
                if (platform === "linux" || platform === "darwin") execSync("sudo systemctl restart nginx", { stdio: "inherit" });
                if (platform === "win32") execSync("powershell.exe Restart-Service W3SVC", { stdio: "inherit" });
                break;
        }
        return `✅ Successfully executed: ${command}`;
    } catch (error) {
        console.error(`❌ Error executing ${command}:`, error.message);
        return `❌ Error executing: ${command}`;
    }
};

// Express HTTP Server (Static File Serving)
const app = express();
app.use(express.static("public")); // Serve static files from the 'public' directory

app.get("/", (req, res) => {
    res.sendFile("index.html", { root: "public" });
});

app.listen(HTTP_PORT, () => {
    console.log(`✅ Static file server is running at http://localhost:${HTTP_PORT}`);
});

// WebSocket Server for AI-Controlled Automation
const wss = new WebSocketServer({ port: WS_PORT });

wss.on("connection", (ws) => {
    console.log("✅ AI Automation Engine Connected.");
    ws.send("✅ Connected to AI Automation Engine.");

    ws.on("message", (message) => {
        const command = message.toString().trim();
        console.log(`🔹 AI Triggered Automation: ${command}`);
        const response = executeCommand(command);
        ws.send(response); // Send execution result back to frontend
    });

    ws.on("close", () => {
        console.log("❌ AI Automation Engine Disconnected.");
    });
});

// Keep daemon running
console.log("✅ AI-Powered Universal Automation Layer is running...");
setInterval(() => console.log("✅ Listening for AI automation triggers..."), 5000);