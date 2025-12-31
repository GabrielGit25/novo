# Email Spam PICDIRECT.NET v1.0 - DOMÍNIO PRÓPRIO
param(
    [string]$SmtpServer = "mail.picdirect.net",
    [int]$Port = 587,
    [string]$User = "ngioczkwt@picdirect.net",
    [string]$Pass = "SUA_SENHA_AQUI",
    [string]$To = "testesonlineonline321",
    [int]$Count = 5
)

Write-Host "📧 PICDIRECT.NET SPAMMER v1.0" -ForegroundColor Red
Write-Host "👤 User: $User" -ForegroundColor Yellow
Write-Host "📧 Para: $To" -ForegroundColor Cyan

$Cred = New-Object System.Management.Automation.PSCredential($User, (ConvertTo-SecureString $Pass -AsPlainText -Force))

for($i=1; $i -le $Count; $i++) {
    $Assunto = "Teste PicDirect #$i - $(Get-Date -Format 'HH:mm:ss')"
    $Corpo = "<h2>Email $i de $Count</h2><p>Domínio: picdirect.net<br>Horário: $(Get-Date)</p>"
    
    try {
        Send-MailMessage -To $To -From $User -Subject $Assunto -Body $Corpo -SmtpServer $SmtpServer -Port $Port -UseSsl -Credential $Cred -BodyAsHtml -ErrorAction Stop
        Write-Host "✅ [$i/$Count] ENVIADO!" -ForegroundColor Green
    } catch {
        Write-Host "❌ [$i/$Count] ERRO: $($_.Exception.Message.Split(':')[0])" -ForegroundColor Red
    }
    
    if($i -lt $Count) { Start-Sleep -Seconds 3 }
}

Write-Host "🎉 $Count EMAILS FINALIZADOS!" -ForegroundColor Magenta
Write-Host "📋 Logs: notepad ~\email-picdirect.log" -ForegroundColor Yellow
