#!/bin/bash

#Crear entorno virtual y carpeta del proyecto
mkdir -p ~/myweb
cd ~/myweb
python3 -m venv venv
source venv/bin/activate

# Configurar permisos
sudo chown -R $USER:www-data ~/myweb
sudo chmod -R 755 ~/myweb

echo "Entorno listo. Ahora crearemos la aplicación."
