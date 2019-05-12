$date = Get-Date
$commit_info = [string]($date.Year) + '/' + $date.Month + '/' + $date.Day +' '+ $date.Hour + ':'+ $date.Minute
$commit_info += ' by '+$hostname
'Commit Info: '+$commit_info | Write-Host -ForegroundColor Green
$time1 = Get-Uptime
'===============================================' |Write-Host -ForegroundColor Green
git add .
git commit -m $commit_info
git push origin master
'Post Commit'
'===============================================' |Write-Host -ForegroundColor Green
$datenow = Get-Date
$second = ($datenow.Hour-$date.Hour)*3600 + ($datenow.Minute - $date.Minute)*60 + ($datenow.Second - $date.Second)
'Complete Commit, Cost Seconds: '+$second+'s' |Write-Host -ForegroundColor Green
