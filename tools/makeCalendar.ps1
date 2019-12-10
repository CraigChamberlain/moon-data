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

function CreateLunarSolarCalendarSingleMonths(){
    $years = Get-ChildItem './api/lunar-solar-calendar/' -Recurse -File -Depth 1   
    $years | 
    ForEach-Object {
        $file = $_.FullName;
        $Months = readJson -file $_;
        $i = 0
        foreach($Month in $Months) {
            $Name = $file -replace "index.json", "$i/index.json"
            mkdir  ($Name -replace "index.json", "") 
            $Month | 
            ConvertTo-Json -Compress | 
            Out-File $Name -NoNewline
            $i ++
        }    

    }
}

function AttachPhases($months){
    $Year = $months[0].Date.Year
    $PhaseData = Get-ChildItem "./api/moon-phase-data/$Year" -Recurse -File | Get-Content | ConvertFrom-Json
 
    for ($i = 0; $i -lt $months.Count; $i++) {
        if ($i -ne $months.Count - 1){
            $Phases =  
                $PhaseData | Where-Object {$_.Date -ge $months[$i].Date -and $_.Date -lt $months[$i+1].Date}
            if ($i -eq 0 -and $PhaseData[0].Date -ne  $months[$i+1].Date ){
                
                $Phases =  
                         @(New-Object PSObject -Property @{ Date = $months[$i].Date; Phase = -1}) + $Phases
                }
        }
        else {
            $Phases =  
                $PhaseData | Where-Object {$_.Date -ge $months[$i].Date}
        }
    
        $props = 
            @{
                Month = $i; 
                Phases = $Phases; 
                Days = $months[$i].Days; 
                Date = $months[$i].Date;
            }

        New-Object PSObject -Property $props

    }
    

} 

function CreateLunarSolarCalendarDetailed(){
    $years = Get-ChildItem './api/lunar-solar-calendar/' -Recurse -File -Depth 1
    $years | 
    ForEach-Object {
        $Months = readJson -file $_;  
        $file = ($_.FullName -replace "lunar-solar-calendar", "lunar-solar-calendar-detailed" );
        $Phases = AttachPhases -months $Months
        mkdir  ($file -replace "index.json", "")
        $Phases | ConvertTo-Json -Compress -Depth 3 | Out-File $file -NoNewline
        $i = 0
        foreach($Month in $Phases) {
            $Name = $file -replace "index.json", "$i/index.json"
            mkdir  ($Name -replace "index.json", "") 
            $Month |
            ConvertTo-Json -Compress | 
            Out-File $Name -NoNewline
            $i ++
        } 
    }
}