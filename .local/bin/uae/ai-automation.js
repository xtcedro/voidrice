import { execSync } from "child_process";
import os from "os";
import fs from "fs";
import readlineSync from "readline-sync";
import WebSocket, { WebSocketServer } from "ws";

// Detect OS
const platform = os.platform(); // 'win32', 'linux', 'darwin'

// AI Execution Rules (HOPS integration placeholder)
const safeCommands = ["clear-cache", "update-system", "optimize-system", "deploy-app", "restart-services"];

// Function to execute safe commands
const executeCommand = (command) => {
    if (!safeCommands.includes(command)) {
        console.log(`❌ Command "${command}" is not allowed.`);
        return;
    }
    
    console.log(`🚀 Executing AI Automation: ${command}`);

    try {
        if (command === "clear-cache") {
            if (platform === "linux" || platform === "darwin") execSync("sudo sync && sudo purge", { stdio: "inherit" });
            if (platform === "win32") execSync("powershell.exe Clear-DnsClientCache", { stdio: "inherit" });
        } 
        else if (command === "update-system") {
            if (platform === "linux") execSync("sudo apt update && sudo apt upgrade -y", { stdio: "inherit" });
            if (platform === "darwin") execSync("softwareupdate -ia", { stdio: "inherit" });
            if (platform === "win32") execSync("powershell.exe Install-Module PSWindowsUpdate -Force", { stdio: "inherit" });
        } 
        else if (command === "optimize-system") {
            if (platform === "linux") execSync("sudo apt autoremove -y && sudo apt clean", { stdio: "inherit" });
            if (platform === "darwin") execSync("brew cleanup", { stdio: "inherit" });
            if (platform === "win32") execSync("powershell.exe Cleanmgr /sagerun:1", { stdio: "inherit" });
        }
        else if (command === "deploy-app") {
            execSync("git pull origin main && npm install && pm2 restart all", { stdio: "inherit" });
        }
        else if (command === "restart-services") {
            if (platform === "linux" || platform === "darwin") execSync("sudo systemctl restart nginx", { stdio: "inherit" });
            if (platform === "win32") execSync("powershell.exe Restart-Service W3SVC", { stdio: "inherit" });
        }
    } catch (error) {
        console.error(`❌ Error executing ${command}:`, error.message);
    }
};

// WebSocket Server for AI-Controlled Automation
const wss = new WebSocketServer({ port: 8080 });

wss.on("connection", (ws) => {
    console.log("✅ AI Automation Engine Connected.");

    ws.on("message", (message) => {
        const command = message.toString();
        console.log(`🔹 AI Triggered Automation: ${command}`);
        executeCommand(command);
    });
});

// Keep daemon running
console.log("✅ AI-Powered Universal Automation Layer is running...");
setInterval(() => console.log("✅ Listening for AI automation triggers..."), 5000);