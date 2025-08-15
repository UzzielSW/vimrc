# Script para automatizar la instalación de paquetes principales con Chocolatey
# Autor: Uzziel Puyol
# Fecha: agosto2025

Write-Host "========================================" -ForegroundColor Green
Write-Host "  INSTALADOR AUTOMÁTICO DE CHOCOLATEY  " -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Verificar si Chocolatey está instalado
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Chocolatey no está instalado. Instalando Chocolatey primero..." -ForegroundColor Red
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    
    if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Host "❌ Error: No se pudo instalar Chocolatey. Saliendo..." -ForegroundColor Red
        exit 1
    }
    Write-Host "✅ Chocolatey instalado correctamente" -ForegroundColor Green
} else {
    Write-Host "✅ Chocolatey ya está instalado" -ForegroundColor Green
}

Write-Host ""
Write-Host "🚀 Iniciando instalación de paquetes principales..." -ForegroundColor Yellow
Write-Host ""

# Lista de paquetes principales a instalar
$paquetes = @(
    @{nombre="graphviz"; descripcion="Software para visualización de gráficos"},
    @{nombre="pandoc"; descripcion="Conversor universal de documentos"},
    @{nombre="plantuml"; descripcion="Herramienta para crear diagramas UML"},
    @{nombre="ripgrep"; descripcion="Herramienta de búsqueda rápida en archivos"},
)

# Contador para mostrar progreso
$contador = 1
$total = $paquetes.Count

foreach ($paquete in $paquetes) {
    Write-Host "[$contador/$total] Instalando $($paquete.descripcion)..." -ForegroundColor Cyan
    
    try {
        # Instalar el paquete
        choco install $paquete.nombre -y --no-progress
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "    ✅ $($paquete.nombre) instalado correctamente" -ForegroundColor Green
        } else {
            Write-Host "    ⚠️  $($paquete.nombre) ya está instalado o hubo un problema menor" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "    ❌ Error instalando $($paquete.nombre): $($_.Exception.Message)" -ForegroundColor Red
    }
    
    $contador++
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Green
Write-Host "           INSTALACIÓN COMPLETA         " -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Mostrar resumen de paquetes instalados
Write-Host "📋 Resumen de paquetes instalados:" -ForegroundColor Magenta
choco list --local-only | Where-Object { $_ -match "^(graphviz|pandoc|plantuml|ripgrep)" }

Write-Host ""
Write-Host "🎉 ¡Script completado!" -ForegroundColor Green
Write-Host "💡 Tip: Es posible que necesites reiniciar tu terminal para usar algunos comandos." -ForegroundColor Yellow

# Pausa para que el usuario pueda ver los resultados
Write-Host ""
Write-Host "Presiona cualquier tecla para salir..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")