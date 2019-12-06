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
    $normalisedMonths = 
        foreach($month in $newMoons){
            normaliseDateTime $month 
        }
    if($normalisedMonths[0] -ne $yearStart)
    {
        $normalisedMonths = @($yearStart) + $normalisedMonths 
    }
    $i = 0
    foreach($month in $normalisedMonths){
            if ($i -ne $normalisedMonths.Length - 1 ){
                $end = $normalisedMonths[($i + 1)]
            }
            else{
                $end = $yearStart.AddYears(1)
            }
            $days = $end.Subtract($month).days
            $i ++
            @{Date = $month.Date.ToString('s'); Days = $days}
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

function CreateLunarSolarCalendar(){
    $years = Get-ChildItem './api/new-moon-data/' -Recurse -File 
    $years | 
    ForEach-Object {
        $file = ($_.FullName -replace "new-moon-data", "lunar-solar-calendar" );
        $year = $_.Directory.Name;
        $newMoons = readJson -file $_;
            
        createYear -newMoons $newMoons -year $year | 
           ConvertTo-Json -Compress | 
           Out-File $file -NoNewline
    }
}

CreateLunarSolarCalendar