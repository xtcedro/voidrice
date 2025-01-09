#!/bin/bash

# Define repository and project directory
REPO_URL="git@github.com:xtcedro/roofing-company-app.git"
PROJECT_NAME="roofing-company-app"

# Clone the repository
echo "Cloning repository from $REPO_URL..."
if git clone $REPO_URL; then
    echo "Repository cloned successfully!"
else
    echo "Failed to clone repository. Please check the URL or your SSH key configuration."
    exit 1
fi

# Navigate into the cloned repository
cd $PROJECT_NAME || exit

# Create subdirectories
echo "Setting up project structure..."
mkdir -p {config,controllers,models,routes,public/assets/{css,images,js}}

# Create main files
touch server.js .env README.md package.json

# Create config directory files
touch config/db.js

# Create controllers
touch controllers/{userController.js,appointmentController.js}

# Create models
touch models/{userModel.js,appointmentModel.js}

# Create routes
touch routes/{userRoutes.js,appointmentRoutes.js}

# Create public directory files
touch public/{index.html,login.html,signup.html,forgotpassword.html,appointments.html,view-appointments.html}

# Create assets files
touch public/assets/css/style.css
touch public/assets/js/{signup.js,login.js,forgotpassword.js,appointments.js,view-appointments.js}

# Finish
echo "Project structure created successfully in the cloned repository!"
