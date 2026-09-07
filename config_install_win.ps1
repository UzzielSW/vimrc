# ==============================================================================
# Script de Instalación Automatizada de Paquetes con Winget
# Autor: Brayan Puyol
# ==============================================================================

# ==============================================================================
# 1. LISTA DE PAQUETES
# ==============================================================================
$paquetes = @(
    @{
        nombre      = "Graphviz"
        id          = "Graphviz.Graphviz"
        descripcion = "Software para visualización de gráficos"
        envPath     = "C:\Program Files\Graphviz\bin"
    },
    @{
        nombre      = "Pandoc"
        id          = "JohnMacFarlane.Pandoc"
        descripcion = "Conversor universal de documentos"
        envPath     = "$env:LocalAppData\Pandoc"
    },
    @{
        nombre      = "CMake"
        id          = "Kitware.CMake"
        descripcion = "Sistema de construcción multiplataforma"
        envPath     = $null
    },
    @{
        nombre      = "fzf"
        id          = "junegunn.fzf"
        descripcion = "Buscador difuso para terminal"
        envPath     = $null
    },
    @{
        nombre      = "delta"
        id          = "dandavison.delta"
        descripcion = "Visor de diferencias para Git"
        envPath     = $null
    },
    @{
        nombre      = "Yazi"
        id          = "sxyazi.yazi"
        descripcion = "Terminal file manager"
        envPath     = $null
    },
    @{
        nombre      = "pnpm"
        id          = "pnpm.pnpm"
        descripcion = "Gestor de paquetes rápido para Node.js"
        envPath     = $null
    },
    @{
        nombre      = "Lazygit"
        id          = "JesseDuffield.lazygit"
        descripcion = "Cliente TUI para Git"
        envPath     = $null
    },
    @{
        nombre      = "FNM"
        id          = "Schniz.fnm"
        descripcion = "Fast Node Manager"
        envPath     = $null
    }
)

# ==============================================================================
# 2. FUNCIONES AUXILIARES
# ==============================================================================

function Add-PathToUserEnvironment {
    param (
        [Parameter(Mandatory=$true)]
        [string]$PathToAdd
    )

    if (Test-Path $PathToAdd) {
        $currentPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)
        $pathList = $currentPath -split ';'

        if ($pathList -notcontains $PathToAdd) {
            Write-Host " [+] Agregando '$PathToAdd' al PATH del usuario..." -ForegroundColor Yellow
            $newPath = "$currentPath;$PathToAdd"
            [Environment]::SetEnvironmentVariable("Path", $newPath, [EnvironmentVariableTarget]::User)
            $env:Path += ";$PathToAdd"
            Write-Host " [✔] PATH actualizado con éxito." -ForegroundColor Green
        } else {
            Write-Host " [i] La ruta '$PathToAdd' ya existe en el PATH." -ForegroundColor Gray
        }
    } else {
        Write-Host " [!] La ruta '$PathToAdd' aún no existe en el disco." -ForegroundColor DarkYellow
    }
}

function Install-WingetPackage {
    param (
        [Parameter(Mandatory=$true)]
        [hashtable]$Paquete
    )

    Write-Host "`n==================================================" -ForegroundColor Cyan
    Write-Host "Procesando: $($Paquete.nombre)" -ForegroundColor Yellow
    Write-Host "Descripción: $($Paquete.descripcion)" -ForegroundColor Gray
    Write-Host "ID Paquete:  $($Paquete.id)" -ForegroundColor DarkGray
    Write-Host "=================================================="

    $checkInstalled = winget list --id $Paquete.id -e 2>$null
    if ($checkInstalled -match $Paquete.id) {
        Write-Host " [✔] '$($Paquete.nombre)' ya está instalado. Omitiendo..." -ForegroundColor Green
    } else {
        Write-Host " [➜] Instalando '$($Paquete.nombre)'..." -ForegroundColor DarkCyan

        $installResult = winget install --id $Paquete.id -e `
            --accept-package-agreements `
            --accept-source-agreements `
            --silent `
            --disable-interactivity

        if ($LASTEXITCODE -eq 0) {
            Write-Host " [✔] '$($Paquete.nombre)' se instaló correctamente." -ForegroundColor Green
        } else {
            Write-Host " [✖] Ocurrió un error con '$($Paquete.nombre)'. Código: $LASTEXITCODE" -ForegroundColor Red
        }
    }

    if (-not [string]::IsNullOrEmpty($Paquete.envPath)) {
        Add-PathToUserEnvironment -PathToAdd $Paquete.envPath
    }
}

function Install-PSFzf {
    Write-Host "`n==================================================" -ForegroundColor Cyan
    Write-Host "Procesando: PSFzf (PowerShell Module)" -ForegroundColor Yellow
    Write-Host "=================================================="

    $modulo = Get-Module -Name PSFzf -ListAvailable -ErrorAction SilentlyContinue
    if ($modulo) {
        Write-Host " [✔] PSFzf ya está instalado." -ForegroundColor Green
    } else {
        Write-Host " [➜] Instalando PSFzf..." -ForegroundColor DarkCyan
        try {
            Install-Module PSFzf -Scope CurrentUser -Force -AllowClobber
            Write-Host " [✔] PSFzf instalado correctamente." -ForegroundColor Green
        } catch {
            Write-Host " [✖] Error instalando PSFzf: $_" -ForegroundColor Red
        }
    }
}

function Install-FnmWithNode {
    Write-Host "`n==================================================" -ForegroundColor Cyan
    Write-Host "Configurando FNM y Node.js" -ForegroundColor Yellow
    Write-Host "=================================================="

    $checkInstalled = winget list --id Schniz.fnm -e 2>$null
    if ($checkInstalled -match "Schniz.fnm") {
        Write-Host " [✔] FNM ya está instalado." -ForegroundColor Green
    } else {
        Write-Host " [➜] Instalando FNM..." -ForegroundColor DarkCyan
        winget install --id Schniz.fnm -e --accept-package-agreements --accept-source-agreements --silent --disable-interactivity
        if ($LASTEXITCODE -eq 0) {
            Write-Host " [✔] FNM instalado correctamente." -ForegroundColor Green
        } else {
            Write-Host " [✖] Error instalando FNM. Código: $LASTEXITCODE" -ForegroundColor Red
            return
        }
    }

    $fnmPath = "$env:LOCALAPPDATA\fnm"
    if (Test-Path "$fnmPath\fnm.exe") {
        $env:Path += ";$fnmPath"
    }

    if (Get-Command fnm -ErrorAction SilentlyContinue) {
        Write-Host " [➜] Instalando Node.js LTS con FNM..." -ForegroundColor DarkCyan
        fnm install lts
        if ($LASTEXITCODE -eq 0) {
            Write-Host " [✔] Node.js LTS instalado." -ForegroundColor Green
            $nodeVersion = fnm list 2>$null | Select-Object -Last 1
            if ($nodeVersion -match '(\d+)') {
                $versionDefault = $matches[1]
                fnm default $versionDefault
                Write-Host " [✔] FNM default establecido a $versionDefault." -ForegroundColor Green
            }
        } else {
            Write-Host " [✖] Error instalando Node.js LTS." -ForegroundColor Red
        }
    } else {
        Write-Host " [✖] FNM no encontrado en PATH. Instálalo manualmente o reinicia la terminal." -ForegroundColor Red
    }
}

function Configure-GitDelta {
    Write-Host "`n==================================================" -ForegroundColor Cyan
    Write-Host "Configurando Git con Delta" -ForegroundColor Yellow
    Write-Host "=================================================="

    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Host " [✖] Git no está instalado. Omitiendo configuración de delta." -ForegroundColor Red
        return
    }

    git config --global core.pager "delta"
    git config --global interactive.singlekey true
    git config --global delta.navigate true
    git config --global delta.light false
    git config --global delta.line-numbers true
    git config --global delta.side-by-side false

    Write-Host " [✔] Git configurado con delta correctamente." -ForegroundColor Green
}

function Install-Scoop {
    Write-Host "`n==================================================" -ForegroundColor Cyan
    Write-Host "Verificando Scoop (gestor de paquetes)" -ForegroundColor Yellow
    Write-Host "=================================================="

    if (Get-Command scoop -ErrorAction SilentlyContinue) {
        Write-Host " [✔] Scoop ya está instalado." -ForegroundColor Green
    } else {
        Write-Host " [➜] Instalando Scoop..." -ForegroundColor DarkCyan
        try {
            Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
            Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
            Write-Host " [✔] Scoop instalado correctamente." -ForegroundColor Green
        } catch {
            Write-Host " [✖] Error instalando Scoop: $_" -ForegroundColor Red
            return
        }
    }
}

function Install-ScoopPackages {
    Write-Host "`n==================================================" -ForegroundColor Cyan
    Write-Host "Instalando paquetes con Scoop" -ForegroundColor Yellow
    Write-Host "=================================================="

    if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
        Write-Host " [✖] Scoop no está disponible. Omitiendo instalaciones." -ForegroundColor Red
        return
    }

    # Añadir bucket "versions" si no existe (necesario para Python 3.12)
    $buckets = scoop bucket list 2>$null
    if ($buckets -notmatch "versions") {
        Write-Host " [➜] Añadiendo bucket 'versions'..." -ForegroundColor DarkCyan
        scoop bucket add versions
        if ($LASTEXITCODE -eq 0) {
            Write-Host " [✔] Bucket 'versions' añadido correctamente." -ForegroundColor Green
        } else {
            Write-Host " [✖] Error añadiendo bucket 'versions'. Código: $LASTEXITCODE" -ForegroundColor Red
        }
    } else {
        Write-Host " [✔] Bucket 'versions' ya existe." -ForegroundColor Green
    }

    $scoopPackages = @(
        @{nombre="sd";          id="main/sd";          descripcion="Intercambio de búsqueda y reemplazo"},
        @{nombre="fd";          id="main/fd";          descripcion="Alternativa rápida a find"},
        @{nombre="ripgrep";     id="main/ripgrep";     descripcion="Búsqueda rápida en archivos"},
        @{nombre="unzip";       id="main/unzip";       descripcion="Descompresión de archivos"},
        @{nombre="tree-sitter"; id="main/tree-sitter"; descripcion="Parser incremental para grammáticas"},
        @{nombre="make";        id="main/make";        descripcion="Herramienta de construcción"},
        @{nombre="mingw";       id="main/mingw";       descripcion="Compilador GCC para Windows"},
        @{nombre="wget";        id="main/wget";        descripcion="Descarga de archivos desde la terminal"},
        @{nombre="gzip";        id="main/gzip";        descripcion="Compresión de archivos"},
        @{nombre="python312";   id="versions/python312"; descripcion="Python 3.12"}
    )

    foreach ($pkg in $scoopPackages) {
        Write-Host "`n--- $($pkg.nombre) ---" -ForegroundColor Yellow
        Write-Host "ID: $($pkg.id) | $($pkg.descripcion)" -ForegroundColor DarkGray

        $checkInstalled = scoop list $pkg.nombre 2>$null
        if ($checkInstalled -match $pkg.nombre) {
            Write-Host " [✔] '$($pkg.nombre)' ya está instalado. Omitiendo..." -ForegroundColor Green
        } else {
            Write-Host " [➜] Instalando '$($pkg.nombre)'..." -ForegroundColor DarkCyan
            scoop install $pkg.id
            if ($LASTEXITCODE -eq 0) {
                Write-Host " [✔] '$($pkg.nombre)' se instaló correctamente." -ForegroundColor Green
            } else {
                Write-Host " [✖] Error instalando '$($pkg.nombre)'. Código: $LASTEXITCODE" -ForegroundColor Red
            }
        }
    }
}

function Install-NpmGlobalPackages {
    Write-Host "`n==================================================" -ForegroundColor Cyan
    Write-Host "Instalando paquetes globales con npm" -ForegroundColor Yellow
    Write-Host "=================================================="

    if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
        Write-Host " [✖] npm no está disponible. Omitiendo instalaciones." -ForegroundColor Red
        return
    }

    $npmPackages = @(
        @{nombre="trash-cli"; descripcion="Mover archivos a la papelera desde CLI"},
        @{nombre="neovim";    descripcion="Neovim para integraciones LSP"}
    )

    foreach ($pkg in $npmPackages) {
        Write-Host "`n--- $($pkg.nombre) ---" -ForegroundColor Yellow
        Write-Host "$($pkg.descripcion)" -ForegroundColor DarkGray

        $checkInstalled = npm list -g $pkg.nombre 2>$null
        if ($checkInstalled -match $pkg.nombre) {
            Write-Host " [✔] '$($pkg.nombre)' ya está instalado. Omitiendo..." -ForegroundColor Green
        } else {
            Write-Host " [➜] Instalando '$($pkg.nombre)'..." -ForegroundColor DarkCyan
            npm install -g $pkg.nombre
            if ($LASTEXITCODE -eq 0) {
                Write-Host " [✔] '$($pkg.nombre)' se instaló correctamente." -ForegroundColor Green
            } else {
                Write-Host " [✖] Error instalando '$($pkg.nombre)'. Código: $LASTEXITCODE" -ForegroundColor Red
            }
        }
    }
}

function Install-Uv {
    Write-Host "`n==================================================" -ForegroundColor Cyan
    Write-Host "Instalando uv (gestor de herramientas Python)" -ForegroundColor Yellow
    Write-Host "=================================================="

    if (Get-Command uv -ErrorAction SilentlyContinue) {
        Write-Host " [✔] uv ya está instalado." -ForegroundColor Green
    } else {
        Write-Host " [➜] Instalando uv..." -ForegroundColor DarkCyan
        powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
        if (Get-Command uv -ErrorAction SilentlyContinue) {
            Write-Host " [✔] uv instalado correctamente." -ForegroundColor Green
        } else {
            Write-Host " [✖] Error instalando uv. Revisa manualmente o reinicia la terminal." -ForegroundColor Red
        }
    }

    if (Get-Command uv -ErrorAction SilentlyContinue) {
        Write-Host "`n--- djhtml ---" -ForegroundColor Yellow
        Write-Host "Formateador de templates Django/HTML" -ForegroundColor DarkGray

        $checkInstalled = uv tool list 2>$null
        if ($checkInstalled -match "djhtml") {
            Write-Host " [✔] 'djhtml' ya está instalado. Omitiendo..." -ForegroundColor Green
        } else {
            Write-Host " [➜] Instalando 'djhtml' con uv..." -ForegroundColor DarkCyan
            uv tool install djhtml
            if ($LASTEXITCODE -eq 0) {
                Write-Host " [✔] 'djhtml' se instaló correctamente." -ForegroundColor Green
            } else {
                Write-Host " [✖] Error instalando 'djhtml'. Código: $LASTEXITCODE" -ForegroundColor Red
            }
        }
    } else {
        Write-Host " [✖] uv no está disponible. Omitiendo instalación de djhtml." -ForegroundColor Red
    }
}

function Show-Summary {
    Write-Host "`n==================================================" -ForegroundColor Magenta
    Write-Host "         VERIFICACIÓN DE INSTALACIONES" -ForegroundColor Magenta
    Write-Host "==================================================" -ForegroundColor Magenta

    $tools = @(
        @{comando="fnm"; nombre="FNM"},
        @{comando="node"; nombre="Node.js"},
        @{comando="yazi"; nombre="Yazi"},
        @{comando="pnpm"; nombre="pnpm"},
        @{comando="cmake"; nombre="CMake"},
        @{comando="lazygit"; nombre="Lazygit"},
        @{comando="fzf"; nombre="fzf"},
        @{comando="delta"; nombre="delta"},
        @{comando="dot"; nombre="Graphviz (dot)"},
        @{comando="pandoc"; nombre="Pandoc"},
        @{comando="scoop"; nombre="Scoop"},
        @{comando="sd"; nombre="sd"},
        @{comando="fd"; nombre="fd"},
        @{comando="rg"; nombre="ripgrep"},
        @{comando="unzip"; nombre="unzip"},
        @{comando="tree-sitter"; nombre="tree-sitter"},
        @{comando="nvim"; nombre="Neovim"},
        @{comando="trash"; nombre="trash-cli"},
        @{comando="make"; nombre="make"},
        @{comando="gcc"; nombre="mingw (gcc)"},
        @{comando="wget"; nombre="wget"},
        @{comando="gzip"; nombre="gzip"},
        @{comando="python"; nombre="python312"},
        @{comando="uv"; nombre="uv"},
        @{comando="djhtml"; nombre="djhtml"}
    )

    $allOk = $true
    foreach ($tool in $tools) {
        $cmd = $tool.comando
        if (Get-Command $cmd -ErrorAction SilentlyContinue) {
            Write-Host " [✔] $($tool.nombre) - OK" -ForegroundColor Green
        } else {
            Write-Host " [✖] $($tool.nombre) - No encontrado" -ForegroundColor Red
            $allOk = $false
        }
    }

    if (Get-Module -Name PSFzf -ListAvailable -ErrorAction SilentlyContinue) {
        Write-Host " [✔] PSFzf - OK" -ForegroundColor Green
    } else {
        Write-Host " [✖] PSFzf - No encontrado" -ForegroundColor Red
        $allOk = $false
    }

    Write-Host "`n==================================================" -ForegroundColor Green
    if ($allOk) {
        Write-Host " [✔] Todas las herramientas instaladas correctamente." -ForegroundColor Green
    } else {
        Write-Host " [⚠] Algunas herramientas no se encontraron. Revisa manualmente." -ForegroundColor Yellow
    }
    Write-Host "==================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Presiona cualquier tecla para salir..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# ==============================================================================
# 3. EJECUCIÓN
# ==============================================================================
Clear-Host
Write-Host "==================================================" -ForegroundColor Magenta
Write-Host "  INICIANDO INSTALACIÓN AUTOMÁTICA DE PAQUETES" -ForegroundColor Magenta
Write-Host "==================================================" -ForegroundColor Magenta

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Error "Winget no se encuentra instalado en este sistema."
    exit 1
}

foreach ($pkg in $paquetes) {
    Install-WingetPackage -Paquete $pkg
}

Install-FnmWithNode
Install-PSFzf
Configure-GitDelta
Install-Scoop
Install-ScoopPackages
Install-NpmGlobalPackages
Install-Uv

Show-Summary
