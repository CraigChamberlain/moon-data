$path = "./index.json"

@{ years = 1700..2082} | 
    ConvertTo-Json -Compress | 
    Out-File $path

Get-ChildItem "./api" -Directory |
    ForEach-Object {
        Copy-Item $path $_
    }

Remove-Item $path