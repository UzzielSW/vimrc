# Asegúrate de usar la versión más reciente y de configurar las predicciones eficientemente
Set-PSReadLineOption -PredictionSource History
# Set-PSReadLineOption -PredictionViewStyle ListView

# Configuracion para fnm (gestor versiones node)
fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression

# Configuracion para mise (gestor versiones node, python, java, entre otros.)
(&mise activate pwsh) | Out-String | Invoke-Expression

# Alias para ejecutar la version actual de python
function py { uv run python @args }
function python { uv run python @args }

# Alias para ls
Set-Alias -Name l -Value Get-ChildItem

# alias para "clear" 
Set-Alias -Name c -Value Clear-Host

# Función para cerrar la ventana de PowerShell
function Close-PowerShellWindow {
  Stop-Process -Name pwsh
}

# moverme a ubicacion de trabajo
function d { Set-Location "$env:OneDrive\Documentos" }
function ob { Set-Location "$env:OneDrive\Documentos\Obsidian UzzielSW" }
function vi { Set-Location "$HOME\Videos" }
function p { Set-Location "C:\PROYECTOS" }

Set-Alias -Name q -Value Close-PowerShellWindow
Set-Alias -Name v -Value nvim

function Connect-Oracle {
    Write-Host "=== Menú de Conexión a Oracle ==="
    Write-Host "1. Conectar como SYS (sysdba)"
    Write-Host "2. Conectar como SYSTEM"
    Write-Host "3. Conectar como un usuario personalizado"
    Write-Host "4. Conectar como un usuario de ORCLPDB"
    Write-Host "5. sqldeveloper"
    Write-Host "6. Salir"
    Write-Host "================================"

    $option = Read-Host "Selecciona una opción (1-5)"

    switch ($option) {
        "1" {
            Write-Host "Conectando como SYS (sysdba)..."
            sqlplus / as sysdba
        }
        "2" {
            $password = Read-Host "Ingresa la contraseña para SYSTEM" -AsSecureString
            $passwordPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
            Write-Host "Conectando como SYSTEM..."
            sqlplus system/$passwordPlain@orcl
        }
        "3" {
            $username = Read-Host "Ingresa el nombre de usuario"
            $password = Read-Host "Ingresa la contraseña" -AsSecureString
            $passwordPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
            Write-Host "Conectando como $username..."
            sqlplus $username/$passwordPlain@orcl
        }
        "4" {
            $username = Read-Host "Ingresa el nombre de usuario"
            $password = Read-Host "Ingresa la contraseña" -AsSecureString
            $passwordPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
            Write-Host "Conectando como $username..."
            sqlplus $username/$passwordPlain@orclpdb
        }
				"5" {
					start c:\\Users\USUARIO\Downloads\sqldeveloper\sqldeveloper.exe
				}	
        default {
            # Write-Host "Opción no válida. Por favor, selecciona 1, 2, 3 o 4."
            # Connect-Oracle
						c
            return
        }
    }
}

# Agregar un alias para ejecutar el menú fácilmente
Set-Alias -Name ora -Value Connect-Oracle


# Validar si Oh My Posh está instalado, si no, instalarlo
if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    Write-Host "Oh My Posh no está instalado. Instalando..."
    winget install JanDeDobbeleer.OhMyPosh --source winget
    Write-Host "Oh My Posh instalado correctamente. Por favor, reinicia PowerShell."
} else {

# 1. Definimos la ruta del tema directamente o mediante la variable de Oh-My-Posh
	# $theme = "$env:LOCALAPPDATA\Programs\oh-my-posh\themes\atomicBit.omp.json"
	# $theme = "$env:LOCALAPPDATA\Programs\oh-my-posh\themes\cloud-context.omp.json"
	$theme = "$env:LOCALAPPDATA\Programs\oh-my-posh\themes\slimfat.omp.json"

# 2. Archivo de caché único para este tema
	# $ompCache = "$env:TEMP\omp-init-atomicBit.ps1"
	# $ompCache = "$env:TEMP\omp-init-cloud-context.ps1"
	$ompCache = "$env:TEMP\omp-init-slimfat.ps1"

# 3. Si no existe la caché, la genera con codificación UTF8 para evitar errores
	if (-not (Test-Path $ompCache)) {
			oh-my-posh init pwsh --config $theme | Out-File $ompCache -Encoding utf8
	}

# 4. Importa la caché
	. $ompCache
}

# # (Opcional) Cambia la vista del historial a lista desplegable cuando presionas la flecha hacia arriba
# Set-PSReadLineOption -PredictionViewStyle ListView

# Cargar el módulo PSFzf
Import-Module PSFzf
# Presionar 'Alt + c' abre la lista de subcarpetas para entrar directamente
#
# Lista de carpetas a ignorar
$excludes = '--exclude .git --exclude node_modules --exclude .venv --exclude dist --exclude build --exclude target'

# Configuración usando fd
$env:FZF_DEFAULT_COMMAND = "fd --type f --hidden $excludes"
$env:FZF_ALT_C_COMMAND = "fd --type d --hidden $excludes"

# Si usas el módulo PSFzf, también puedes pasarle las opciones globales
Set-PsFzfOption -DefaultOptions $excludes

# ============================================
# CONFIGURA TUS SERVIDORES AQUÍ
# ============================================
$Global:MisServidores = @(
		@{ Numero = 1; Nombre = "🌐 Producción Web"; Host = "prod-web01.company.com"; User = "admin"; Port = 22; Descripcion = "Servidor principal web" },
		@{ Numero = 2; Nombre = "🗄️  Base de Datos"; Host = "db-server.local"; User = "postgres"; Port = 22; Descripcion = "PostgreSQL principal" },
		@{ Numero = 3; Nombre = "🧪 Desarrollo"; Host = "10.0.200.32"; User = "brayan.puyol"; Port = 22; Descripcion = "Entorno de pruebas" },
		@{ Numero = 4; Nombre = "☁️  AWS EC2"; Host = "ec2-54-123-456-789.compute.amazonaws.com"; User = "ubuntu"; Port = 22; Key = "~/.ssh/aws_key.pem"; Descripcion = "Instancia AWS" },
		@{ Numero = 5; Nombre = "🐳 Docker Host"; Host = "docker.local"; User = "root"; Port = 22; Descripcion = "Servidor de contenedores" },
		@{ Numero = 6; Nombre = "🔧 Bastión/Jump"; Host = "bastion.company.com"; User = "jumpuser"; Port = 22; Descripcion = "Acceso a red interna" }
)

function sshc {
		[CmdletBinding()]
		param(
				[int]$Numero
		)

		# Si no se proporciona número, mostrar menú
		if (-not $Numero) {
				Clear-Host
				Write-Host "`n╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
				Write-Host "║                    🔌 CONEXIÓN SSH                         ║" -ForegroundColor Cyan
				Write-Host "╠════════════════════════════════════════════════════════════╣" -ForegroundColor Cyan
				
				foreach ($srv in $Global:MisServidores | Sort-Object Numero) {
						$color = if ($srv.Numero % 2 -eq 0) { "White" } else { "Gray" }
						Write-Host "║  [$($srv.Numero)] " -ForegroundColor Yellow -NoNewline
						Write-Host "$($srv.Nombre.PadRight(20)) " -ForegroundColor $color -NoNewline
						Write-Host "→ $($srv.User)@$($srv.Host):$($srv.Port)".PadRight(35) -ForegroundColor DarkCyan -NoNewline
						Write-Host "║" -ForegroundColor Cyan
						Write-Host "║      $($srv.Descripcion)".PadRight(58) -ForegroundColor DarkGray -NoNewline
						Write-Host "║" -ForegroundColor Cyan
				}
				
				Write-Host "║                                                            ║" -ForegroundColor Cyan
				Write-Host "║  [0] ❌ Cancelar / Salir                                   ║" -ForegroundColor Red
				Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
				
				do {
						Write-Host "`nSelecciona un número: " -ForegroundColor Yellow -NoNewline
						$opcion = Read-Host  # ← CAMBIO: Usar $opcion en lugar de $input
						
						if ($opcion -eq "0") {
								Write-Host "❌ Cancelado." -ForegroundColor Red
								return
						}
						
						# Validar que sea un número
						if ($opcion -notmatch '^\d+$') {
								Write-Host "⚠️  Por favor ingresa solo números." -ForegroundColor Red
								continue
						}
						
						$seleccion = $Global:MisServidores | Where-Object { $_.Numero -eq [int]$opcion }
						
						if (-not $seleccion) {
								Write-Host "⚠️  Opción inválida. Intenta de nuevo." -ForegroundColor Red
						}
				} while (-not $seleccion)
		} else {
				$seleccion = $Global:MisServidores | Where-Object { $_.Numero -eq $Numero }
				if (-not $seleccion) {
						Write-Host "❌ Error: No existe servidor con número $Numero" -ForegroundColor Red
						return
				}
		}

		# Construir comando SSH
		$sshArgs = @()
		
		if ($seleccion.Port -and $seleccion.Port -ne 22) {
				$sshArgs += "-p"
				$sshArgs += $seleccion.Port
		}
		
		if ($seleccion.Key) {
				$keyPath = $ExecutionContext.InvokeCommand.ExpandString($seleccion.Key)
				$sshArgs += "-i"
				$sshArgs += $keyPath
		}
		
		$sshArgs += "$($seleccion.User)@$($seleccion.Host)"

		# Mostrar resumen
		Write-Host "`n🔌 Conectando a..." -ForegroundColor Green
		Write-Host "   Servidor:  $($seleccion.Nombre)" -ForegroundColor White
		Write-Host "   Comando:   ssh $($sshArgs -join ' ')" -ForegroundColor DarkGray
		Write-Host ""

		# Ejecutar conexión
		ssh @sshArgs
		
		# Mensaje al regresar
		Write-Host "`n👋 Desconectado de $($seleccion.Nombre)" -ForegroundColor Yellow
}

Set-Alias -Name s -Value sshc
