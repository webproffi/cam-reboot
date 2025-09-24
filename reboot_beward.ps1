$ip = "свой ip камеры"
$login = "свой логин"
$password = "свой пароль"

$pair = "${login}:${password}"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$encodedCreds = [System.Convert]::ToBase64String($bytes)

$headers = @{
    Authorization = "Basic $encodedCreds"
    "User-Agent"  = "Mozilla/5.0"
}

$rebootUrl = "http://$ip/cgi-bin/admin/restart.cgi?button=%D0%9F%D0%B5%D1%80%D0%B5%D0%B7%D0%B0%D0%B3%D1%80%D1%83%D0%B7%D0%BA%D0%B0"

Write-Host "Отправка команды перезагрузки на BD4685..."

try {
    $response = Invoke-WebRequest -Uri $rebootUrl -Headers $headers -UseBasicParsing -TimeoutSec 10
    Write-Host "Успех: камера ответила статусом $($response.StatusCode)"
} catch {
    if ($_.Exception.Response.StatusCode -eq 401) {
        Write-Host "Ошибка 401: неверный логин/пароль."
    } elseif ($_.Exception.Message -like "*timeout*" -or $_.Exception.Message -like "*connection closed*") {
        Write-Host "Камера начала перезагружаться."
    } else {
        Write-Host "Ошибка: $($_.Exception.Message)"
    }
}