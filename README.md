# Scripts de Configuración de Herramientas de Desarrollo

Este repositorio contiene dos scripts principales para gestionar configuraciones de herramientas de desarrollo de manera eficiente y organizada.

## 📁 Scripts Disponibles

### 1. `push_config.sh` - Aplicar Configuraciones
**Propósito**: Aplica las configuraciones del repositorio a tu sistema local.

**Funcionalidades**:
- ✅ Instala y configura Vim con Vim-Plug
- ✅ Configura Neovim para Linux y Windows
- ✅ Aplica configuraciones de Tmux
- ✅ Configura Bash (.bashrc y .bash_aliases)
- ✅ Aplica configuraciones de WezTerm
- ✅ Configura PowerShell
- ✅ Aplica configuraciones de Fish
- ✅ Configura IntelJ IDEA
- ✅ Aplica configuraciones de Cursor (settings.json y keybindings.json)
- ✅ Opción para resetear configuración de Neovim

### 2. `pull_config.sh` - Actualizar Repositorio
**Propósito**: Actualiza los archivos del repositorio con las configuraciones locales modificadas.

**Funcionalidades**:
- ✅ Actualiza .vimrc desde configuración local
- ✅ Actualiza init.vim de Neovim (Linux y Windows)
- ✅ Actualiza .tmux.conf
- ✅ Actualiza archivos de Bash (.bashrc y .bash_aliases)
- ✅ Actualiza .wezterm.lua
- ✅ Actualiza perfil de PowerShell
- ✅ Actualiza conf.fish
- ✅ Actualiza .ideavimrc de IntelJ
- ✅ Actualiza configuración de Cursor (settings.json y keybindings.json)

## 🚀 Características

### ✨ Mejoras Visuales
- **Colores**: Mensajes con códigos de color para mejor legibilidad
- **Símbolos**: Uso de ✓ y ✗ para indicar éxito/error
- **Menú estructurado**: Interfaz clara y fácil de usar

### 🔧 Funcionalidades Técnicas
- **Validación robusta**: Verificación de archivos y directorios
- **Manejo de errores**: Mensajes informativos y manejo graceful de fallos
- **Funciones auxiliares**: Código reutilizable y mantenible
- **Compatibilidad**: Soporte para Linux y Windows (WSL)

### 🛡️ Seguridad y Robustez
- **Validación de entrada**: Verificación de nombres de usuario
- **Creación de directorios**: Creación automática de directorios necesarios
- **Verificación de dependencias**: Comprobación de herramientas requeridas

## 📋 Requisitos

### Para Linux:
- Bash
- curl (para descargar Vim-Plug)
- Acceso a directorios de configuración

### Para Windows (WSL):
- WSL2 configurado
- PowerShell (para Neovim Windows)
- Acceso a directorios de Windows

## 🎯 Uso

### Aplicar Configuraciones (push_config.sh)
```bash
./push_config.sh
```

### Actualizar Repositorio (pull_config.sh)
```bash
./pull_config.sh
```

## 🔄 Flujo de Trabajo Recomendado

1. **Configuración inicial**: Usa `push_config.sh` para aplicar configuraciones base
2. **Desarrollo**: Modifica configuraciones según tus necesidades
3. **Actualización**: Usa `pull_config.sh` para sincronizar cambios al repositorio
4. **Compartir**: Commit y push de los cambios al repositorio
5. **Repetir**: El ciclo continúa según sea necesario

## 📝 Estructura del Repositorio

```
vimrc/
├── .vimrc                    # Configuración de Vim
├── init.vim                  # Configuración de Neovim
├── .tmux.conf               # Configuración de Tmux
├── .bashrc                  # Configuración de Bash
├── .bash_aliases            # Alias de Bash
├── .wezterm.lua             # Configuración de WezTerm
├── Microsoft.PowerShell_profile.ps1  # Perfil de PowerShell
├── conf.fish                # Configuración de Fish
├── .ideavimrc               # Configuración de IntelJ IDEA
├── cursor_settings.json     # Configuración de Cursor (settings)
├── cursor_keybindings.json # Configuración de Cursor (keybindings)
├── push_config.sh           # Script para aplicar configuraciones
├── pull_config.sh           # Script para actualizar repositorio
└── README.md                # Este archivo
```

## 🎨 Personalización

Ambos scripts están diseñados para ser fácilmente personalizables:

- **Agregar nuevas herramientas**: Simplemente crea nuevas funciones siguiendo el patrón existente
- **Modificar colores**: Cambia las variables de color al inicio de cada script
- **Agregar validaciones**: Extiende las funciones de validación según necesidades

## 🤝 Contribuciones

Las mejoras y sugerencias son bienvenidas. Por favor:

1. Mantén la consistencia con el estilo de código existente
2. Prueba los cambios antes de hacer commit
3. Documenta nuevas funcionalidades

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Ver archivo LICENSE para más detalles.

---

**Autor**: Uzziel Puyol
**Versión**: 1.0
**Última actualización**: agosto2025
