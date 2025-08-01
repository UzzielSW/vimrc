# Alias para ls
Set-Alias -Name l -Value Get-ChildItem
# alias para "clear" 
Set-Alias -Name c -Value Clear-Host
# Función para cerrar la ventana de PowerShell
function Close-PowerShellWindow {
  Stop-Process -Name pwsh
}

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


# TODO: Para el script debo imprimir el comando que debo usar para instalar oh-my-posh
# winget install JanDeDobbeleer.OhMyPosh -s winget

# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\kushal.omp.json" | Invoke-Expression
# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\sonicboom_dark.omp.json" | Invoke-Expression
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\atomicBit.omp.json" | Invoke-Expression
