const WebSocket = require("ws");
const readline = require("readline");

// Create a readline interface for CLI input
const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

// Connect to AI automation server
const ws = new WebSocket("ws://localhost:8080");

ws.on("open", () => {
    console.log("📡 Connected to AI Automation Engine.");
    promptCommand();
});

// Prompt user for commands
function promptCommand() {
    rl.question("🔹 Enter command for AI Automation Engine: ", (command) => {
        if (command.toLowerCase() === "exit") {
            console.log("🚪 Exiting CLI...");
            ws.close();
            rl.close();
            return;
        }
        ws.send(command);
        promptCommand();
    });
}

// Log server responses
ws.on("message", (message) => {
    console.log("💡 Server Response:", message.toString());
});

// Handle connection close
ws.on("close", () => {
    console.log("🔌 Disconnected from AI Automation Engine.");
    rl.close();
});

// Handle errors
ws.on("error", (error) => {
    console.error("❌ WebSocket Error:", error.message);
    rl.close();
});