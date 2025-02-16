const WebSocket = require("ws");

// Connect to AI automation server
const ws = new WebSocket("ws://localhost:8080");

// When connected, send an automation command
ws.on("open", () => {
    console.log("📡 Connected to AI Automation Engine.");

    // Send a system command (example: update-system)
    ws.send("update-system"); 

    // Close the connection after sending the command
    setTimeout(() => ws.close(), 2000);
});

// Log server responses
ws.on("message", (message) => {
    console.log("💡 Server Response:", message.toString());
});

// Handle errors
ws.on("error", (error) => {
    console.error("❌ WebSocket Error:", error.message);
});