#!/bin/bash
echo "=== Instalador de BOX1.0 ==="

# Verificar permisos de root
if [[ $EUID -ne 0 ]]; then
    echo "Error: Este script debe ejecutarse como root o con sudo."
    exit 1
fi

# Directorio base del script
BASE_DIR=$(dirname "$0")

# Verificar la existencia de los directorios
if [[ ! -d "$BASE_DIR/bin" ]] || [[ ! -d "$BASE_DIR/config" ]]; then
    echo "Error: No se encontraron los directorios 'bin' o 'config'. Verifica la estructura del proyecto."
    exit 1
fi

# Crear directorio en /opt
echo "Creando directorio /opt/box1.0..."
sudo mkdir -p /opt/box1.0

# Copiar archivos
echo "Copiando archivos a /opt/box1.0..."
sudo cp -r "$BASE_DIR/bin" "$BASE_DIR/config" /opt/box1.0/

# Crear enlace simbólico
echo "Creando enlace simbólico en /usr/local/bin..."
sudo ln -sf /opt/box1.0/bin/box /usr/local/bin/box

# Confirmación de instalación
echo "Instalación completada con éxito. Usa 'box' para iniciar BOX1.0."
