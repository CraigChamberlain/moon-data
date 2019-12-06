function readJson($file){
    
    $file | Get-Content | ConvertFrom-Json

}

function cleanJson($file){
    
    $content = $file | Get-Content | ConvertFrom-Json
    $content | Where-Object {$_.Phase -eq 0 }
}

function normaliseDateTime($date){
    Get-Date (""+$date.Year+"/"+$date.Month+"/"+$date.Day)
}

function createYear($newMoons, $year){
    $yearStart = Get-Date "$year/1/1"
    $months = @($yearStart) + $newMoons
    $normalisedMonths = 
        foreach($month in $months){
            normaliseDateTime $month 
        }
    $i = 0
    foreach($month in $normalisedMonths){
            if ($i -ne $normalisedMonths.Length){
                $end = $normalisedMonths[($i + 1)].AddDays(-1)
            }
            else{
                $end = $yearStart.AddYears(1).AddDays(-1)
            }
            $i ++
            $month, $end.Subtract($month).days
        }
    
}

function CreateNewMoonJson(){
    $years = Get-ChildItem './api/moon-phase-data/' -Recurse -File 
    $years | 
    ForEach-Object {
        $file = ($_.FullName -replace "moon-phase-data", "new-moon-data");
        cleanJson -file $_  | 
            ForEach-Object {$_.Date.ToString('s') }  | 
            ConvertTo-Json -Compress | 
            Out-File $file
    }
}