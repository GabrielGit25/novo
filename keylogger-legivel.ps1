# Keylogger LEGÍVEL v3.0 - PURO NATIVO (sem Add-Type!)
param($LogPath="$env:USERPROFILE\AppData\Local\keys-readable.log")

# Pasta usuário
New-Item -ItemType Directory -Force -Path (Split-Path $LogPath) | Out-Null

Write-Host "🎹 KEYLOGGER v3.0 NATIVO ATIVO!" -ForegroundColor Red -BackgroundColor Black
Write-Host "📝 Log: $LogPath" -ForegroundColor Yellow
Write-Host "✨ Digite ALGO (Ctrl+C parar)" -ForegroundColor Green

$buffer = ""

try {
    while($true) {
        # Lê stdin (teclado) linha por linha
        if ([Console]::KeyAvailable) {
            $key = [Console]::ReadKey($true)
            $char = $key.KeyChar
            
            # Ignora teclas especiais
            if ($char -ne [char]0 -and $char -match '[a-zA-Z0-9\s\.\-,;:/]') {
                $buffer += $char.ToString().ToLower()
                Write-Host "Tecla: $char" -ForegroundColor Cyan -NoNewline
                
                # Salva em 8+ chars ou Enter
                if ($buffer.Length -ge 8 -or $key.Key -eq 'Enter') {
                    if ($buffer.Trim()) {
                        "$(Get-Date -Format 'HH:mm:ss') → $buffer" | Out-File $LogPath -Append -Encoding UTF8
                        Write-Host "`n📝 SALVO: $buffer" -ForegroundColor Green
                    }
                    $buffer = ""
                }
            }
        }
        Start-Sleep -Milliseconds 50
    }
} catch {
    Write-Host "`n🛑 PARADO (Ctrl+C)" -ForegroundColor Yellow
}
