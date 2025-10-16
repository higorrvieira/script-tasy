# O script irá automatizar o login no sistema hospitalar Tasy
# Ele irá executar sozinho todas as vezes que o computador for inicializado, abrindo o chrome em modo tela cheia, preenchendo o login e senha
# Script totalmente leve, usando poucos recursos do computador

$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"

Start-Process $chromePath "--kiosk https://tasyausta.omnisaude.co/#/login"
Start-Sleep -Seconds 7

$chrome = Get-Process | Where-Object { $_.MainWindowTitle -like "*Omnisaude*" }
if ($chrome) {
    # Usa user32.dll para forçar o foco na janela do Chrome
    Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class Win32 {
        [DllImport("user32.dll")]
        public static extern bool SetForegroundWindow(IntPtr hWnd);
    }
"@
    [void] [Win32]::SetForegroundWindow($chrome.MainWindowHandle)
}

Start-Sleep -Seconds 8

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait("teste") # substituir o usuário teste para o user real
Start-Sleep -Milliseconds 300
[System.Windows.Forms.SendKeys]::SendWait("{TAB}")
Start-Sleep -Milliseconds 300
[System.Windows.Forms.SendKeys]::SendWait("teste") # utilizar a senha real que tenha permissão de acesso ao Tasy
Start-Sleep -Milliseconds 300
[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")

