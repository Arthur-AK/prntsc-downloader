# check www.prnt.sc/XX0000

New-Item -Path .\Archive -ItemType Directory
New-Item -Path .\pictures -ItemType Directory

# Change to pick where the script starts
[Collections.ArrayList]$L1 = @('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z')
[Collections.ArrayList]$L2 = @('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z')
# 1 and 0001 lead to different sites...
[int[]] $num1 = 0 .. 9
[int[]] $num2 = 0 .. 9
[int[]] $num3 = 0 .. 9
[int[]] $num4 = 0 .. 9

$done = @(Get-ChildItem -Path '.\Archive\*.zip' -Name)
$archive = $done.Count
$archivemin1 = $archive - 1
if($archive -eq 1){$L2.RemoveAt(0)}
if($archive -gt 1 -and $archive -lt 26){$L2.RemoveRange(0, $archivemin1)}

foreach($letter1 in $L1){
  foreach($letter2 in $L2){
    foreach($number1 in $num1){
      foreach($number2 in $num2){
        foreach($number3 in $num3){
          foreach($number4 in $num4){
            if(!(Get-Item -Path .\pictures\$Letter1$Letter2$number1$number2$number3$number4.png -ErrorAction Ignore)){
              $Content = $(Invoke-WebRequest -Uri www.prnt.sc/$Letter1$Letter2$number1$number2$number3$number4).Content
              try{
                $Content_Location = $Content.IndexOf('no-click screenshot-image')
              } catch {
                Write-Host "Cannot locate $Letter1$letter2$number1$number2$number3$number4. Moving to next file..."
                Copy-Item -Path .\nofile.png -Destination .\pictures\$Letter1$Letter2$number1$number2$number3$number4.png
              }
              $Content_Location2 = $Content.SubString($Content_Location,63)
              $Content_Location3 = $Content_Location2.IndexOf('http')
              try{
                $Content_Final = $Content_Location2.SubString($Content_Location3)
              } catch {
                Write-Host "Cannot locate $Letter1$letter2$number1$number2$number3$number4. Moving to next file..."
                Copy-Item -Path .\nofile.png -Destination .\pictures\$Letter1$Letter2$number1$number2$number3$number4.png
              }
              "$Letter1$Letter2$number1$number2$number3$number4 --- $Content_Final" | Out-File -FilePath .\Archive\$letter1$letter2.log -Append
              try{
                Invoke-WebRequest $Content_Final -OutFile .\pictures\$Letter1$Letter2$number1$number2$number3$number4.png -ErrorAction SilentlyContinue
              }catch{
                Write-Host "Cannot locate $Letter1$letter2$number1$number2$number3$number4. Moving to next file..."
                Copy-Item -Path .\nofile.png -Destination .\pictures\$Letter1$Letter2$number1$number2$number3$number4.png #Makes restarting the script a lot quicker
              }
              Write-Host "Finished with $Letter1$letter2$number1$number2$number3$number4"
            }else{
              Write-Host "$Letter1$Letter2$number1$number2$number3$number4.png already exists..."
            }
          }
        }
      }
    }
    Compress-Archive -Path .\pictures\*.png -DestinationPath .\Archive\$letter1$letter2.zip
  }
  Compress-Archive -Path .\Archive\a*.zip -DestinationPath .\Archive\A.zip
}
