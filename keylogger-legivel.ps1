# Keylogger LEGÍVEL v3.0 - SEM Add-Type! 100% Nativo
param($LogPath="$env:USERPROFILE\AppData\Local\keys-readable.log")

# Cria pasta
New-Item -ItemType Directory -Force -Path (Split-Path $LogPath) | Out-Null

Write-Host "🎹 KEYLOGGER v3.0 ATIVO (SEM Add-Type)!" -ForegroundColor Red
Write-Host "📝 Log: $LogPath" -ForegroundColor Yellow
Write-Host "✨ Digite NO POWERShell (Ctrl+C parar)" -ForegroundColor Green

$buffer = ""

try {
    while($true) {
        if ([Console]::KeyAvailable) {
            $key = [Console]::ReadKey($true)
            $char = $key.KeyChar
            
            if ($char -match '[a-zA-Z0-9\s\.\-,;:/]') {
                $buffer += $char.ToString()
                Write-Host "[$char]" -ForegroundColor Cyan -NoNewline
                
                if ($key.Key -eq 'Enter' -or $buffer.Length -ge 10) {
                    if ($buffer.Trim()) {
                        "$(Get-Date -Format 'HH:mm:ss') → $buffer" | Out-File $LogPath -Append
                        Write-Host "`n📝 SALVO: $buffer" -ForegroundColor Green
                    }
                    $buffer = ""
                }
            }
        }
        Start-Sleep -Milliseconds 50
    }
} catch {
    Write-Host "`n🛑 PARADO!" -ForegroundColor Yellow
}
