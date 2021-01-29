$scriptPath = $PSScriptRoot
$oldPwd = $PWD
$outputPath = "$scriptPath\output"
$htmlExporterPath = "$scriptPath\GOG-Galaxy-HTML5-exporter"
$pythonExportScriptPath = "$scriptPath\GOG-Galaxy-Export-Script"
Write-Host "Installing python dependencies."
python -m pip install --upgrade pip
pip install Unidecode
pip install natsort

Write-Host "Extracting library."
Set-Location $pythonExportScriptPath
& python .\galaxy_library_export.py -a -o "$outputPath\gogExport.csv"

Set-Location $htmlExporterPath
Write-Host "Exporting html-representation of library."
& python .\csv_parser.py  -i "$outputPath\gogExport.csv" -o "$outputPath\gogExport.html" -d "	" --html5 --image-list

if (Test-Path "$htmlExporterPath\imagelist.txt") {
    $webClient = New-Object System.Net.WebClient
    $fileNamePattern = '^.*\/(.+?)(?:\?.*=.*$|$)'
    Write-Host "Downloading image files to '$htmlExporterPath\images\'."
    foreach ($imageFile in (Get-Content "$htmlExporterPath\imagelist.txt")) {
        $imageDownloadPath = ("$htmlExporterPath\images\" + ("$imageFile" -replace "$fileNamePattern", '$1'))
        if (!(Test-Path "$imageDownloadPath")) {
            $webClient.DownloadFile("$imageFile", "$imageDownloadPath")
        }
    }
}

Write-Host "Moving html representation to '$outputPath'."
Copy-Item $htmlExporterPath\* -Include ("assets", "images", "templates") -Recurse -Destination $outputPath -Force

Write-Host "Finishing touches."
$html = Get-Content $outputPath\gogExport.html
$html = $html.Replace('<header id="controls">', '<header id="controls" class="visible">')
Set-Content $outputPath\gogExport.html $html
$js = Get-Content $outputPath\templates\script.js
$js = $js.Replace("overlay.style.cursor = 'none';", "overlay.style.cursor = 'pointer';")
Set-Content $outputPath\templates\script.js $js

Set-Location $oldPwd