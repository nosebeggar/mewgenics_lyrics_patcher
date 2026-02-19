$musicRoot = Join-Path $PSScriptRoot "Output\audio\music"
$exceptionFile = Join-Path $PSScriptRoot "exceptions.txt"

$exceptions = Get-Content $exceptionFile |
    ForEach-Object { $_.Trim() } |
    Where-Object { $_ -ne "" }

Get-ChildItem -Path $musicRoot -Directory | ForEach-Object {
    $folder = $_.FullName
    $folderName = $_.Name

    if ($exceptions -contains $folderName) {
        Write-Host "Skipped folder (exception): $folderName"
        return
    }

    Get-ChildItem -Path $folder -Filter "*.ogg" | ForEach-Object {
        $bossFile = $_.FullName

        if ($_.Name -like "*_boss*") {
            Write-Host "Processing: $($_.Name)"

            # Replace everything from _boss to the extension with _battle.ogg
            $battleFile = $_.FullName -replace "_boss.*\.ogg$", "_battle.ogg"

            if (Test-Path $battleFile) {
                Copy-Item -Path $battleFile -Destination $bossFile -Force
                Write-Host "Replaced $($_.Name) with $(Split-Path $battleFile -Leaf)"
            } else {
                Write-Host "Battle file not found for $($_.Name)"
            }
        }
    }
}
