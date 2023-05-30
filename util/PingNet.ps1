<#

CONNECTIVA REDES DE COMPUTADORES LTDA
(35)3822-4271 / (35)99169-1920
suporte@connectivaredes.com

ping-net - Script para monitoramento de link de Internet - v.: 0.2

#>

$ip = "8.8.8.8"
$logFile = "pingnet.log"
$interval = 2

$header1 = "CONNECTIVA REDES DE COMPUTADORES LTDA"
$header2 = "-------------------------------------"
$header3 = "Internet link monitor. . . "

Add-Content -Path $logFile -Value $header1
Write-Host $header1

Add-Content -Path $logFile -Value $header2
Write-Host $header2

Add-Content -Path $logFile -Value $header3
Write-Host "$header3 ($interval sec)"


while ($true) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $pingResult = Test-Connection -ComputerName $ip -Count 1 -Quiet
		
    if (-Not $pingResult) {
		$output = "$timestamp - Internet Status: DOWN"
		Add-Content -Path $logFile -Value $output
		Write-Host $output
	}

    Start-Sleep -Seconds $interval
}
