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
        $month = $months[$i]
        if ($i -ne $months.Count - 1){ ## Not the last month of year
            $Phases =  
                $PhaseData | Where-Object {$_.Date -ge $month.Date -and $_.Date -lt $months[$i+1].Date}
            if ($i -eq 0 -and (normaliseDateTime($PhaseData[0].Date)) -ne  $months[0].Date ){ # First Month of Year & Date new moon not first day of year
                
                $Phases =  
                         @(New-Object PSObject -Property @{ Date = $month.Date; Phase = -1}) + $Phases
                }
        }
        else {  # Last month of year
            $Phases =   
                $PhaseData | Where-Object {$_.Date -ge $month.Date}
        }
    
        $props = 
            @{
                Month = $i; 
                Phases = $Phases; 
                Days = $month.Days; 
                Date = $month.Date;
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

function CreateLunarSolarCalendarDetailedExtra(){
    $years = Get-ChildItem './api/lunar-solar-calendar-detailed/' -Recurse -File -Depth 1 
    $years |  
    ForEach-Object {
        $Months = readJson -file $_;  
        $file = $_.FullName;
        $ExtMonths =    
            for($o = 0; $o -lt $Months.Count; $o++) {
                $Phases = $Months[$o].Phases
                $ExtPhases = @()
                for ($i = 0; $i -lt $Phases.Count; $i++) {
                        $FirstDay = normaliseDateTime $Phases[$i].Date    

                        if ($i -ne $Phases.Count - 1){
                           $nextPhase = normaliseDateTime -date $Phases[$i + 1].Date
                             
                        }
                        elseif($o -ne $Months.Count - 1) {
                            $nextPhase = normaliseDateTime $Months[$o + 1].Phases[0].Date
                        }
                        else{

                            $nextPhase = normaliseDateTime $Months[0].Phases[0].Date.AddYears(1)
                        }
                        $days = $nextPhase.Subtract($FirstDay).Days
                        $lastDay = $nextPhase.AddDays(-1)
                        $ExtPhases +=
                            New-Object PSObject -Property @{ Days = $days; LastDay = $lastDay; FirstDay = $FirstDay; Phase =  $Phases[$i].Phase; DateTime = $Phases[$i].Date}
                }
                New-Object PSObject -Property @{ Month = $Months[$o].Month ; Phases = $ExtPhases; Days = $Months[$o].Days; FirstDay = $Months[$o].Date} 
            }

        $ExtMonths | ConvertTo-Json -Compress -Depth 3 | Out-File $file -NoNewline
        $i = 0
        foreach($Month in $ExtMonths) {
            $Name = $file -replace "index.json", "$i/index.json"
            $Month |
            ConvertTo-Json -Compress | 
            Out-File $Name -NoNewline
            $i ++
        } 
    }
}

Get-ChildItem './api/lunar-solar-calendar-detailed/' -Recurse -File -Depth 1 | 
    #Select-Object -First 1 |
    ForEach-Object { readJson -file $_;} |
    ForEach-Object { $_ | Where-Object {$_.Phases.Count -gt 4}}