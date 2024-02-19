# 
# Sysmon Control Center v1.0 - 6-05-22 - Tako Zandink
# 

# variabelen zetten
# klantnaam voor gebruik in console output
$klantnaam = "Circulus"
# UNC pad van de gedeelde bestandsmap op het netwerk
$configpath = "\\cba-fs01\sysmon$"
# bestandsnaam van de config file
$configfile = "ModularDefault.xml"
# locatie van de bestandsmap op alle servers in servers.txt waar sysmon wordt geplaatst (als de map niet bestaat, wordt deze aangemaakt)
$destFolder = "C:\Install"
# disk van de bestandsmap hierboven
$destdrive = "C:"
# bestandsmapnaam van de map hierboven
$destname = "Install"
# locatie en bestandsnaam van de map met het .txt bestand dat de hostnames van de uit te voeren servers bevat.
$serverfile = "C:\Scripts\SysmonControlCenter\servers.txt"

cls

# huidige inhoud van servers.txt weergeven
write-host "Zorg er voor dat je [servers.txt] gevuld hebt met de juiste hostnames."
write-host ""
Get-Content $serverfile
write-host ""
# inloggegevens opvragen. (Domain Admin, of in ieder geval schrijfrechten op de map waar sysmon wordt geplaatst en rechten om sysmon remote uite te voeren)
write-host "Geef $klantnaam Domain Admin credentials"
$cred = get-credential

# keuze menu weergeven 
write-host ""
write-host "*********************************************************"
write-host "[1] Installeer Sysmon op servers in servers.txt"
write-host "[2] Config file opnieuw inlezen op servers in servers.txt"
write-host "[3] Zet permissies voor Sysmon op servers in servers.txt"
write-host "*********************************************************"
write-host ""
# keuze in een variabele plaatsen
$keuze = read-host "Maak een keuze"

# Lees je servers in.
$servers= Get-Content $serverfile

# keuze routine
switch ($keuze) {

    1 { 
        # keuze 1: sysmon uitrollen

        # Weet je het zeker?
        $choice = read-host "Wil je Sysmon uitrollen naar alle servers in [servers.txt]? [J/N]"
        if ($choice -ne "J" -or $choice -ne "j") { 
            write-host "Uitrol niet gestart. Cancel"
            exit
        }
        # Voor elke server in servers.txt een remote sessie opbouwen 
        foreach ($server in $servers) {

            $Session = New-PSSession -ComputerName $server -Credential $cred
            
            # controleren of de destination map al bestaat op de server
            if (Invoke-Command -Session $session -ScriptBlock {Test-Path -path $args[0]} -ArgumentList $destFolder) {
            # Zo nee, dan aanmaken.
            } else {
                Invoke-command -Session $session -ScriptBlock {New-Item -path $Using:destdrive\$Using:destname -ItemType "directory"}
            }
            
            # de config file van het UNC path op het netwerk kopieren naar de server    
            Copy-Item "$configpath\$configfile" -ToSession $Session -Destination $destFolder
            # sysmon64.exe en eula.txt kopieren naar de server
            Copy-Item "$configpath\sysmon64.exe" -ToSession $Session -Destination $destFolder
            Copy-Item "$configpath\eula.txt" -ToSession $Session -Destination $destFolder

            # Sysmon64.exe -i met de config remote uitvoeren op de server
            Invoke-Command -Session $session -ScriptBlock {
                cmd.exe /C "$using:destfolder\Sysmon64.exe" -i $using:destfolder\$using:configfile -accepteula
                # Voor security redenen de configfile weer verwijderen van de server.
                Remove-item "$using:destfolder\$using:configfile" -force
            }
        
        

        }
    } 

    2 {
        # Keuze 2: config laden

        # Weet je het zeker?
        $choice = read-host "Wil je de config van Sysmon opnieuw laden voor alle servers in [servers.txt]? [J/N]"
        if ($choice -ne "J" -or $choice -ne "j") { 
            write-host "Opnieuw laden niet gestart. Cancel"
            exit
        }
        
        # Voor elke server in servers.txt een remote sessie opbouwen    
        foreach ($server in $servers) { 
            $Session = New-PSSession -ComputerName $server -Credential $cred
            # de config file van het UNC path op het netwerk kopieren naar de server
            Copy-Item "$configpath\$configfile" -ToSession $Session -Destination $destFolder
            # Sysmon64.exe -c met de nieuwe configfile remote uitvoeren op de server
            Invoke-Command -Session $session -ScriptBlock {
                cmd.exe /C "$using:destfolder\Sysmon64.exe" -c $using:destfolder\$using:configfile 
                # Voor security redenen de configfile weer verwijderen van de server.
                Remove-item "$using:destfolder\$using:configfile" -force
            }
        }
    }

    3 {
        # Keuze 3: Permissies zetten
        
        # Weet je het zeker?
        $choice = read-host "Wil je de wevtutil permissies zetten voor alle servers in [servers.txt]? [J/N]"
        if ($choice -ne "J" -or $choice -ne "j") { 
            write-host "Opnieuw laden niet gestart. Cancel"
            exit
        } 
        # Voor elke server in servers.txt een remote sessie opbouwen    
        foreach ($server in $servers) { 
            $Session = New-PSSession -ComputerName $server -Credential $cred
            # wevtutil sl met de rechten remote uitvoeren op de server
            Invoke-Command -Session $session -ScriptBlock {
                cmd.exe /C "wevtutil sl Microsoft-Windows-Sysmon/Operational /ca:O:BAG:SYD:(A;;0xf0007;;;SY)(A;;0x7;;;BA)(A;;0x1;;;BO)(A;;0x1;;;SO)(A;;0x1;;;S-1-5-32-573)(A;;0x1;;;S-1-5-20)"
            }
        }
    }

}