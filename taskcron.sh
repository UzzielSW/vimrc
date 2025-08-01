#!/bin/bash

# Script para configurar tarea cron que ejecute pull_config.sh todos los días a las 10 PM

echo "Configurando tarea cron para actualizar configuraciones..."

# Obtener la ruta absoluta del directorio actual
RUTA_REPOSITORIO=$(pwd)
RUTA_SCRIPT="$RUTA_REPOSITORIO/pull_config.sh"

echo "Ruta del repositorio: $RUTA_REPOSITORIO"
echo "Ruta del script: $RUTA_SCRIPT"

# Verificar que el script existe
if [ ! -f "$RUTA_SCRIPT" ]; then
    echo "Error: No se encontró el script pull_config.sh en $RUTA_SCRIPT"
    exit 1
fi

# Hacer el script ejecutable
chmod +x "$RUTA_SCRIPT"

# Crear la entrada cron (todos los días a las 10 PM)
CRON_ENTRY="0 22 * * * $RUTA_SCRIPT"

echo "Configurando cron job: $CRON_ENTRY"

# Agregar la tarea al crontab del usuario actual
(crontab -l 2>/dev/null; echo "$CRON_ENTRY") | crontab -

echo "✓ Tarea cron configurada exitosamente!"
echo "El script pull_config.sh se ejecutará todos los días a las 10:00 PM"
echo ""
echo "Para ver las tareas cron actuales, ejecuta: crontab -l"
echo "Para editar las tareas cron, ejecuta: crontab -e"
echo "Para eliminar todas las tareas cron, ejecuta: crontab -r"