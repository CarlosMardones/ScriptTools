#!/bin/bash

# Actualiza los repositorios y paquetes del sistema
echo "Actualizando el sistema..."
sudo apt update && sudo apt upgrade -y

# Instalación de Visual Studio Code
echo "Instalando Visual Studio Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/vscode.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/vscode.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt update
sudo apt install -y code

# Instalación de PyCharm (Community Edition)
echo "Instalando PyCharm..."
sudo snap install pycharm-community --classic

# Instalación de GIMP
echo "Instalando GIMP..."
sudo apt install -y gimp

echo "✅ Instalación completada con éxito."
