# Set Variables
$configfile = get-content ".\config\localconfig.ini"
# Folder on the remote server to install sysmon
$confset = "No"
$usernset = "No"
$passwdSet = "No"
$remoteSet = "No"

 


# checks for execution
$global:servercheck = "No"
$global:usercheck = "No"
$global:passwdcheck = "No"
$global:configcheck = "No"
$global:remotecheck = "No"

foreach ($config in $configfile) {
    if ($config.Substring(0,5) -eq "[PTH]") {$Install_Path = $config.substring(5,$config.length-5)}
    if ($config.Substring(0,5) -eq "[DBG]") {
        $Debug = $config.substring(5,$config.length-5)
        if ($debug -eq "Yes" -or $debug -eq "yes" -or $debug -eq "YES") { start-transcript "$Install_Path\log\debug.log"}
    }
}

$nl = "`r`n"

# Definieer MainGUI
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

$FormFont = New-Object System.Drawing.Font("Tahoma",10,[System.Drawing.FontStyle]::Regular)
$FormIcon = New-Object system.drawing.icon ("$Install_Path\media\ico.ico")

$file_form = [system.drawing.image]::FromFile("$Install_Path\media\BG_SCC.jpg")

[System.Windows.Forms.Application]::EnableVisualStyles();
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text = "Syslog Control Center"
$main_form.width = 1060
$main_form.Height = 670
$main_form.AutoSize = $false
$main_form.AutoSizeMode = "GrowAndShrink"
$main_form.BackColor = "Black"
$main_form.Font = $FormFont
$main_form.Icon = $FormIcon
$main_form.Minimizebox = $false
$main_form.Maximizebox = $false
$main_form.Opacity = 100
$main_form.BackgroundImage = $file_form
$main_form.BackgroundImageLayout = "None"

# Yes/ No Form
$file_secform = [system.drawing.image]::FromFile("$Install_Path\media\BG_YesNo.png")
[System.Windows.Forms.Application]::EnableVisualStyles();
$sec_form = New-Object System.Windows.Forms.Form
$sec_form.Text = "Are you sure?"
$sec_form.width = 330
$sec_form.Height = 220
$sec_form.AutoSize = $false
$sec_form.AutoSizeMode = "GrowAndShrink"
$sec_form.BackColor = "Black"
$sec_form.Font = $FormFont
$sec_form.Icon = $FormIcon
$sec_form.Minimizebox = $false
$sec_form.Maximizebox = $false
$sec_form.Opacity = 100
$sec_form.BackgroundImage = $file_secform
$sec_form.BackgroundImageLayout = "None"

# sSure Label
$LblsSure = New-Object System.Windows.Forms.Label
$LblsSure.AutoSize = $true
$LblsSure.ForeColor = "White"
$LblsSure.Location = New-Object System.Drawing.Size(40,30)
$LblsSure.BackColor = [System.Drawing.Color]::FromName("Transparent")
#$lblsSure.BackColor = "Black"
$LblsSure.Font = New-Object System.Drawing.Font("Tahoma",10,[System.Drawing.FontStyle]::Regular)

# sYES PictureBox
$file_sYES = (get-item "$Install_Path\media\yes_on.png")
$img_sYES = [System.Drawing.Image]::Fromfile($file_sYES);
$fileHVR_sYES = (get-item "$Install_Path\media\yes_off.png")
$imgHVR_sYES = [System.Drawing.Image]::Fromfile($fileHVR_sYES);
$pictureBoxsYES = new-object Windows.Forms.PictureBox
$pictureBoxsYES.Width =  $img_sYES.Size.Width;
$pictureBoxsYES.Height =  $img_sYES.Size.Height;
$pictureBoxsYES.Image = $img_sYES;
$pictureBoxsYES.Location = New-Object System.Drawing.Size(80,70)
$pictureBoxsYES.BackColor = [System.Drawing.Color]::FromName("Transparent")
$pictureBoxsYES.add_MouseEnter({
    #
})
$pictureBoxsYES.add_MouseLeave({
    $pictureBoxsYES.Image= $img_sYES;
})
$pictureBoxsYES.add_MouseHover({
    $pictureBoxsYES.Image= $imgHVR_sYES;
})
$pictureBoxsYES.Add_Click(
    { 
        $global:iamsure = "Yes"
        $sec_form.Close()
    }
)

# sNo PictureBox
$file_sNO = (get-item "$Install_Path\media\NO_on.png")
$img_sNO = [System.Drawing.Image]::Fromfile($file_sNO);
$fileHVR_sNO = (get-item "$Install_Path\media\NO_off.png")
$imgHVR_sNO = [System.Drawing.Image]::Fromfile($fileHVR_sNO);
$pictureBoxsNO = new-object Windows.Forms.PictureBox
$pictureBoxsNO.Width =  $img_sNO.Size.Width;
$pictureBoxsNO.Height =  $img_sNO.Size.Height;
$pictureBoxsNO.Image = $img_sNO;
$pictureBoxsNO.Location = New-Object System.Drawing.Size(180,70)
$pictureBoxsNO.BackColor = [System.Drawing.Color]::FromName("Transparent")
$pictureBoxsNO.add_MouseEnter({
    #
})
$pictureBoxsNO.add_MouseLeave({
    $pictureBoxsNO.Image= $img_sNO;
})
$pictureBoxsNO.add_MouseHover({
    $pictureBoxsNO.Image= $imgHVR_sNO;
})
$pictureBoxsNO.Add_Click(
    { 
        $global:iamsure = "No"
        $sec_form.Close()
    }
)

# Make Yes/No Form
$sec_form.Controls.Add($pictureBoxsYes)
$sec_form.Controls.Add($pictureBoxsNo)
$sec_form.Controls.Add($LblsSure)

# Warning Form
$file_thrdform = [system.drawing.image]::FromFile("$Install_Path\media\BG_YesNo.png")
[System.Windows.Forms.Application]::EnableVisualStyles();
$thrd_form = New-Object System.Windows.Forms.Form
$thrd_form.Text = "Warning!"
$thrd_form.width = 330
$thrd_form.Height = 220
$thrd_form.AutoSize = $false
$thrd_form.AutoSizeMode = "GrowAndShrink"
$thrd_form.BackColor = "Black"
$thrd_form.Font = $FormFont
$thrd_form.Icon = $FormIcon
$thrd_form.Minimizebox = $false
$thrd_form.Maximizebox = $false
$thrd_form.Opacity = 100
$thrd_form.BackgroundImage = $file_thrdform
$thrd_form.BackgroundImageLayout = "None"

# tWarn PictureBox
$file_tWarn = (get-item "$Install_Path\media\warning.png")
$img_tWarn = [System.Drawing.Image]::Fromfile($file_tWarn);
$pictureBoxtWarn =  new-object Windows.Forms.PictureBox
$pictureBoxtWarn.width = $img_tWarn.Size.Width;
$pictureBoxtWarn.height = $img_tWarn.Size.Height;
$pictureBoxtWarn.Image = $img_tWarn
$PictureBoxtWarn.BackColor = [System.Drawing.Color]::FromName("Transparent")
$pictureBoxtWarn.location = New-Object System.Drawing.Size(10,60)

# tWarn Label
$LblWarn = New-Object System.Windows.Forms.Label
$LblWarn.Text = "Settings not complete!"
$LblWarn.AutoSize = $true
$LblWarn.ForeColor = "White"
$LblWarn.Location = New-Object System.Drawing.Size(80,80)
$LblWarn.BackColor = [System.Drawing.Color]::FromName("Transparent")
$LblWarn.Font = New-Object System.Drawing.Font("Tahoma",10,[System.Drawing.FontStyle]::Bold)

# tWarnClose Picturebox
$file_tWarnClose = (get-item "$Install_Path\media\OK_on.png")
$img_tWarnClose = [System.Drawing.Image]::Fromfile($file_tWarnClose);
$fileHVR_tWarnClose = (get-item "$Install_Path\media\OK_off.png")
$imgHVR_tWarnClose = [System.Drawing.Image]::Fromfile($fileHVR_tWarnClose);
$pictureBoxtWarnClose = new-object Windows.Forms.PictureBox
$pictureBoxtWarnClose.Width =  $img_tWarnClose.Size.Width;
$pictureBoxtWarnClose.Height =  $img_tWarnClose.Size.Height;
$pictureBoxtWarnClose.Image = $img_tWarnClose;
$pictureBoxtWarnClose.Location = New-Object System.Drawing.Size(250,60)
$pictureBoxtWarnClose.BackColor = [System.Drawing.Color]::FromName("Transparent")
$pictureBoxtWarnClose.add_MouseLeave({
    $pictureBoxtWarnClose.Image= $img_tWarnClose;
})
$pictureBoxtWarnClose.add_MouseHover({
    $pictureBoxtWarnClose.Image= $imgHVR_tWarnClose;
})
$pictureBoxtWarnClose.Add_Click(
    { 
       $thrd_form.Close()
    }
)

# Make Warning Form
$thrd_form.Controls.Add($pictureBoxtWarn)
$thrd_form.Controls.Add($pictureBoxtWarnClose)
$thrd_form.Controls.Add($LblWarn)

# Logo PictureBox
$file_Logo = (get-item "$Install_Path\media\SCClogo.png")
$img_Logo = [System.Drawing.Image]::Fromfile($file_Logo);
$pictureBoxLogo =  new-object Windows.Forms.PictureBox
$pictureBoxLogo.width = $img_Logo.Size.Width;
$pictureBoxLogo.height = $img_Logo.Size.Height;
$pictureBoxLogo.Image = $img_Logo
$PictureBoxLogo.BackColor = [System.Drawing.Color]::FromName("Transparent")
$pictureBoxLogo.location = New-Object System.Drawing.Size(20,20)

# Output Label
$LblTooltip = New-Object System.Windows.Forms.Label
$LblTooltip.Text = ">.."
$LblTooltip.AutoSize = $true
$LblTooltip.ForeColor = "White"
$LblTooltip.Location = New-Object System.Drawing.Size(40,570)
$lblTooltip.BackColor = "Black"
$LblTooltip.Font = New-Object System.Drawing.Font("Tahoma",12,[System.Drawing.FontStyle]::Bold)

# Output Picturebox
$file_Output = (get-item "$Install_Path\media\output.png")
$img_Output = [System.Drawing.Image]::Fromfile($file_Output);
$pictureBoxOutput =  new-object Windows.Forms.PictureBox
$pictureBoxOutput.width = $img_Output.Size.Width;
$pictureBoxOutput.height = $img_Output.Size.Height;
$pictureBoxOutput.Image = $img_Output
$PictureBoxOutput.BackColor = [System.Drawing.Color]::FromName("Transparent")
$pictureBoxOutput.location = New-Object System.Drawing.Size(20,560)

# Servers TextBox
$textBoxServers = New-Object System.Windows.Forms.TextBox
$textBoxServers.Location = New-Object System.Drawing.Point(650,120)
$textBoxServers.Size = New-Object System.Drawing.Size(220,400)
$textBoxServers.Multiline = $true
$textBoxServers.ScrollBars = "Vertical"
$textBoxServers.ReadOnly=$true

# ServersTXT Picturebox
$file_ServersTxt = (get-item "$Install_Path\media\servers_on.png")
$img_ServersTxt = [System.Drawing.Image]::Fromfile($file_ServersTxt);
$fileHVR_ServersTxt = (get-item "$Install_Path\media\servers_off.png")
$imgHVR_ServersTxt = [System.Drawing.Image]::Fromfile($fileHVR_ServersTxt);
$pictureBoxServersTxt = new-object Windows.Forms.PictureBox
$pictureBoxServersTxt.Width =  $img_ServersTxt.Size.Width;
$pictureBoxServersTxt.Height =  $img_ServersTxt.Size.Height;
$pictureBoxServersTxt.Image = $img_ServersTxt;
$pictureBoxServersTxt.Location = New-Object System.Drawing.Size(570,120)
$pictureBoxServersTxt.BackColor = [System.Drawing.Color]::FromName("Transparent")
$pictureBoxServersTxt.add_MouseEnter({
    $LblToolTip.Text = "Open Servers.txt"
})
$pictureBoxServersTxt.add_MouseLeave({
    $LblToolTip.Text = ">.."
    $pictureBoxServersTxt.Image= $img_ServersTXT;
})
$pictureBoxServersTxt.add_MouseHover({
    $pictureBoxServersTxt.Image= $imgHVR_ServersTXT;
})
$pictureBoxServersTxt.Add_Click(
    { 
        notepad $Install_Path\config\servers.txt
        $inp = get-content "$Install_Path\config\servers.txt"
        $nrservers = $inp.count
        $Lblnrservers.Text = "servers: $nrservers"
        if ($nrservers -eq 0) {
            $Lblnrservers.ForeColor = "Red"
            $file_Vinksrvs = (get-item "$Install_Path\media\NoVink.png")
            $img_Vinksrvs = [System.Drawing.Image]::Fromfile($file_Vinksrvs);
            $pictureBoxVinksrvs.Image = $img_Vinksrvs
            $global:servercheck = "No"
        } else {
            $Lblnrservers.ForeColor = "White"
            $file_Vinksrvs = (get-item "$Install_Path\media\Vink.png")
            $img_Vinksrvs = [System.Drawing.Image]::Fromfile($file_Vinksrvs);
            $pictureBoxVinksrvs.Image = $img_Vinksrvs
            $global:servercheck = "Yes"
        }
        $TextBoxServers.Clear()
        foreach($i in $inp) {
            $TextBoxServers.AppendText($i)
            $TextBoxServers.AppendText($nl)
        }    
    }
)

# ServersRefresh Picturebox
$file_ServersRefresh = (get-item "$Install_Path\media\rfrsh_on.png")
$img_ServersRefresh = [System.Drawing.Image]::Fromfile($file_ServersRefresh);
$fileHVR_ServersRefresh = (get-item "$Install_Path\media\rfrsh_off.png")
$imgHVR_ServersRefresh = [System.Drawing.Image]::Fromfile($fileHVR_ServersRefresh);
$pictureBoxServersRefresh = new-object Windows.Forms.PictureBox
$pictureBoxServersRefresh.Width =  $img_ServersRefresh.Size.Width;
$pictureBoxServersRefresh.Height =  $img_ServersRefresh.Size.Height;
$pictureBoxServersRefresh.Image = $img_ServersRefresh;
$pictureBoxServersRefresh.Location = New-Object System.Drawing.Size(570,190)
$pictureBoxServersRefresh.BackColor = [System.Drawing.Color]::FromName("Transparent")
$pictureBoxServersRefresh.add_MouseEnter({
    $LblToolTip.Text = "Refresh servers from Servers.txt"
})
$pictureBoxServersRefresh.add_MouseLeave({
    $LblToolTip.Text = ">.."
    $pictureBoxServersRefresh.Image= $img_ServersRefresh;
})
$pictureBoxServersRefresh.add_MouseHover({
    $pictureBoxServersRefresh.Image= $imgHVR_ServersRefresh;
})
$pictureBoxServersRefresh.Add_Click(
    { 
        $inp = get-content "$Install_Path\config\servers.txt"
        $nrservers = $inp.count
        $Lblnrservers.Text = "servers: $nrservers"
        if ($nrservers -eq 0) {
            $Lblnrservers.ForeColor = "Red"
            $file_Vinksrvs = (get-item "$Install_Path\media\NoVink.png")
            $img_Vinksrvs = [System.Drawing.Image]::Fromfile($file_Vinksrvs);
            $pictureBoxVinksrvs.Image = $img_Vinksrvs
            $global:servercheck = "No"
        } else {
            $Lblnrservers.ForeColor = "White"
            $file_Vinksrvs = (get-item "$Install_Path\media\Vink.png")
            $img_Vinksrvs = [System.Drawing.Image]::Fromfile($file_Vinksrvs);
            $pictureBoxVinksrvs.Image = $img_Vinksrvs
            $global:servercheck = "Yes"
        }
        $TextBoxServers.Clear()
        foreach($i in $inp) {
            $TextBoxServers.AppendText($i)
            $TextBoxServers.AppendText($nl)
        }    
    }
)

# nrServers Label
$Lblnrservers = New-Object System.Windows.Forms.Label
$Lblnrservers.Text = "servers: $nrservers"
$Lblnrservers.AutoSize = $true
$Lblnrservers.ForeColor = "Red"
$Lblnrservers.Location = New-Object System.Drawing.Size(920,120)
$Lblnrservers.BackColor = [System.Drawing.Color]::FromName("Transparent")
$Lblnrservers.Font = New-Object System.Drawing.Font("Tahoma",10,[System.Drawing.FontStyle]::Regular)

# ConfSet Label
$LblConfSet = New-Object System.Windows.Forms.Label
$LblConfSet.Text = "config set: $ConfSet"
$LblConfSet.AutoSize = $true
$LblConfSet.ForeColor = "Red"
$LblConfSet.Location = New-Object System.Drawing.Size(920,140)
$LblConfSet.BackColor = [System.Drawing.Color]::FromName("Transparent")
$LblConfSet.Font = New-Object System.Drawing.Font("Tahoma",10,[System.Drawing.FontStyle]::Regular)

# UsernSet Label
$LblUsernSet = New-Object System.Windows.Forms.Label
$LblUsernSet.Text = "user set: $UsernSet"
$LblUsernSet.AutoSize = $true
$LblUsernSet.ForeColor = "Red"
$LblUsernSet.Location = New-Object System.Drawing.Size(920,160)
$LblUsernSet.BackColor = [System.Drawing.Color]::FromName("Transparent")
$LblUsernSet.Font = New-Object System.Drawing.Font("Tahoma",10,[System.Drawing.FontStyle]::Regular)

# passwdSet Label
$LblpasswdSet = New-Object System.Windows.Forms.Label
$LblpasswdSet.Text = "passwd set: $passwdSet"
$LblpasswdSet.AutoSize = $true
$LblpasswdSet.ForeColor = "Red"
$LblpasswdSet.Location = New-Object System.Drawing.Size(920,180)
$LblpasswdSet.BackColor = [System.Drawing.Color]::FromName("Transparent")
$LblpasswdSet.Font = New-Object System.Drawing.Font("Tahoma",10,[System.Drawing.FontStyle]::Regular)

# RemoteSet Label
$LblremoteSet = New-Object System.Windows.Forms.Label
$LblremoteSet.Text = "remote set: $remoteSet"
$LblremoteSet.AutoSize = $true
$LblremoteSet.ForeColor = "Red"
$LblremoteSet.Location = New-Object System.Drawing.Size(920,200)
$LblremoteSet.BackColor = [System.Drawing.Color]::FromName("Transparent")
$LblremoteSet.Font = New-Object System.Drawing.Font("Tahoma",10,[System.Drawing.FontStyle]::Regular)

# Vinksrvs Picturebox
$file_Vinksrvs = (get-item "$Install_Path\media\NoVink.png")
$img_Vinksrvs = [System.Drawing.Image]::Fromfile($file_Vinksrvs);
$pictureBoxVinksrvs =  new-object Windows.Forms.PictureBox
$pictureBoxVinksrvs.width = $img_Vinksrvs.Size.Width;
$pictureBoxVinksrvs.height = $img_Vinksrvs.Size.Height;
$pictureBoxVinksrvs.Image = $img_Vinksrvs
$PictureBoxVinksrvs.BackColor = [System.Drawing.Color]::FromName("Transparent")
$pictureBoxVinksrvs.location = New-Object System.Drawing.Size(900,120)

# Vinkcnfp Picturebox
$file_Vinkcnfp = (get-item "$Install_Path\media\NoVink.png")
$img_Vinkcnfp = [System.Drawing.Image]::Fromfile($file_Vinkcnfp);
$pictureBoxVinkcnfp =  new-object Windows.Forms.PictureBox
$pictureBoxVinkcnfp.width = $img_Vinkcnfp.Size.Width;
$pictureBoxVinkcnfp.height = $img_Vinkcnfp.Size.Height;
$pictureBoxVinkcnfp.Image = $img_Vinkcnfp
$PictureBoxVinkcnfp.BackColor = [System.Drawing.Color]::FromName("Transparent")
$pictureBoxVinkcnfp.location = New-Object System.Drawing.Size(900,140)

# Vinkuser Picturebox
$file_Vinkuser = (get-item "$Install_Path\media\NoVink.png")
$img_Vinkuser = [System.Drawing.Image]::Fromfile($file_Vinkuser);
$pictureBoxVinkuser =  new-object Windows.Forms.PictureBox
$pictureBoxVinkuser.width = $img_Vinkuser.Size.Width;
$pictureBoxVinkuser.height = $img_Vinkuser.Size.Height;
$pictureBoxVinkuser.Image = $img_Vinkuser
$PictureBoxVinkuser.BackColor = [System.Drawing.Color]::FromName("Transparent")
$pictureBoxVinkuser.location = New-Object System.Drawing.Size(900,160)

# Vinkpass Picturebox
$file_vinkpass = (get-item "$Install_Path\media\NoVink.png")
$img_vinkpass = [System.Drawing.Image]::Fromfile($file_vinkpass);
$pictureBoxvinkpass =  new-object Windows.Forms.PictureBox
$pictureBoxvinkpass.width = $img_vinkpass.Size.Width;
$pictureBoxvinkpass.height = $img_vinkpass.Size.Height;
$pictureBoxvinkpass.Image = $img_vinkpass
$PictureBoxvinkpass.BackColor = [System.Drawing.Color]::FromName("Transparent")
$pictureBoxvinkpass.location = New-Object System.Drawing.Size(900,180)

# Vinkremote Picturebox
$file_vinkremote = (get-item "$Install_Path\media\NoVink.png")
$img_vinkremote = [System.Drawing.Image]::Fromfile($file_vinkremote);
$pictureBoxvinkremote =  new-object Windows.Forms.PictureBox
$pictureBoxvinkremote.width = $img_vinkremote.Size.Width;
$pictureBoxvinkremote.height = $img_vinkremote.Size.Height;
$pictureBoxvinkremote.Image = $img_vinkremote
$PictureBoxvinkremote.BackColor = [System.Drawing.Color]::FromName("Transparent")
$pictureBoxvinkremote.location = New-Object System.Drawing.Size(900,200)

# EnterPath Textbox
$textBoxEnterPath = New-Object System.Windows.Forms.TextBox
$textBoxEnterPath.Location = New-Object System.Drawing.Point(120,120)
$textBoxEnterPath.Size = New-Object System.Drawing.Size(300,20)

# ConfigPath Picturebox
$file_ConfigPath = (get-item "$Install_Path\media\path_on.png")
$img_ConfigPath = [System.Drawing.Image]::Fromfile($file_ConfigPath);
$fileHVR_ConfigPath = (get-item "$Install_Path\media\path_off.png")
$imgHVR_ConfigPath = [System.Drawing.Image]::Fromfile($fileHVR_ConfigPath);
$pictureBoxConfigPath = new-object Windows.Forms.PictureBox
$pictureBoxConfigPath.Width =  $img_ConfigPath.Size.Width;
$pictureBoxConfigPath.Height =  $img_ConfigPath.Size.Height;
$pictureBoxConfigPath.Image = $img_ConfigPath;
$pictureBoxConfigPath.Location = New-Object System.Drawing.Size(50,120)
$pictureBoxConfigPath.BackColor = [System.Drawing.Color]::FromName("Transparent")
$pictureBoxConfigPath.add_MouseEnter({
    $LblToolTip.Text = "Set path of the Remote Syslog Configfile (example: \\fileserver\config\Default.xml) "
})
$pictureBoxConfigPath.add_MouseLeave({
    $LblToolTip.Text = ">.."
    $pictureBoxConfigPath.Image= $img_ConfigPath;
})
$pictureBoxConfigPath.add_MouseHover({
    $pictureBoxConfigPath.Image= $imgHVR_ConfigPath;
})
$pictureBoxConfigPath.Add_Click(
    { 
        $global:configpath = $textBoxEnterPath.Text
        if ($global:configpath -eq "") {
                $LblConfSet.Text = "config set: No"
                $LblConfSet.ForeColor = "Red"
                $file_Vinkcnfp = (get-item "$Install_Path\media\NoVink.png")
                $img_Vinkcnfp = [System.Drawing.Image]::Fromfile($file_Vinkcnfp);
                $pictureBoxVinkcnfp.Image = $img_Vinkcnfp
                $global:configcheck = "No"
            } 
            else {
                $LblConfSet.Text = "config set: Yes"
                $LblConfSet.ForeColor = "White"
                $file_Vinkcnfp = (get-item "$Install_Path\media\Vink.png")
                $img_Vinkcnfp = [System.Drawing.Image]::Fromfile($file_Vinkcnfp);
                $pictureBoxVinkcnfp.Image = $img_Vinkcnfp
                $global:configcheck = "Yes"
            }

    }
)

# EnterUser Textbox
$textBoxEnterUser = New-Object System.Windows.Forms.TextBox
$textBoxEnterUser.Location = New-Object System.Drawing.Point(120,190)
$textBoxEnterUser.Size = New-Object System.Drawing.Size(300,20)
$textBoxEnterUser.Text = "DOMAIN\Administrator"

# EnterPassword Textbox
$textBoxEnterPasswd = New-Object System.Windows.Forms.MaskedTextBox
$textBoxEnterPasswd.PasswordChar = "*"
$textBoxEnterPasswd.Location = New-Object System.Drawing.Point(120,215)
$textBoxEnterPasswd.Size = New-Object System.Drawing.Size(300,20)

# Credentials Picturebox
$file_Credentials = (get-item "$Install_Path\media\creds_on.png")
$img_Credentials = [System.Drawing.Image]::Fromfile($file_Credentials);
$fileHVR_Credentials = (get-item "$Install_Path\media\creds_off.png")
$imgHVR_Credentials = [System.Drawing.Image]::Fromfile($fileHVR_Credentials);
$pictureBoxCredentials = new-object Windows.Forms.PictureBox
$pictureBoxCredentials.Width =  $img_Credentials.Size.Width;
$pictureBoxCredentials.Height =  $img_Credentials.Size.Height;
$pictureBoxCredentials.Image = $img_Credentials;
$pictureBoxCredentials.Location = New-Object System.Drawing.Size(50,190)
$pictureBoxCredentials.BackColor = [System.Drawing.Color]::FromName("Transparent")
$pictureBoxCredentials.add_MouseEnter({
    $LblToolTip.Text = "Enter Domain Admin Credentials "
})
$pictureBoxCredentials.add_MouseLeave({
    $LblToolTip.Text = ">.."
    $pictureBoxCredentials.Image= $img_Credentials;
})
$pictureBoxCredentials.add_MouseHover({
    $pictureBoxCredentials.Image= $imgHVR_Credentials;
})
$pictureBoxCredentials.Add_Click({ 
        $global:username = $textBoxEnterUser.Text
        $global:passwd = $textBoxEnterPasswd.Text
        
        
        if ($global:username -eq "") {
                $LblUsernSet.Text = "user set: No"
                $LblUsernSet.ForeColor = "Red"
                $file_Vinkuser = (get-item "$Install_Path\media\NoVink.png")
                $img_Vinkuser = [System.Drawing.Image]::Fromfile($file_Vinkuser);
                $pictureBoxVinkuser.Image = $img_Vinkuser
                $global:usercheck = "No"
            } 
            else 
            {
                $LblUsernSet.Text = "user set: Yes"
                $LblUsernSet.ForeColor = "White"
                $file_Vinkuser = (get-item "$Install_Path\media\Vink.png")
                $img_Vinkuser = [System.Drawing.Image]::Fromfile($file_Vinkuser);
                $pictureBoxVinkuser.Image = $img_Vinkuser
                $global:usercheck = "Yes"
            }  
        if ($global:passwd -ne "") {
            $Lblpasswdset.Text = "passw set: Yes"
            $Lblpasswdset.ForeColor = "White"
            $file_Vinkpass = (get-item "$Install_Path\media\Vink.png")
            $img_Vinkpass = [System.Drawing.Image]::Fromfile($file_Vinkpass);
            $pictureBoxVinkpass.Image = $img_Vinkpass
            $global:passwdcheck = "Yes"
        } else { 
            $lblpasswdset.Text = "passw set: No"
            $Lblpasswdset.ForeColor = "Red"
            $file_Vinkpass = (get-item "$Install_Path\media\NoVink.png")
            $img_Vinkpass = [System.Drawing.Image]::Fromfile($file_Vinkpass);
            $pictureBoxVinkpass.Image = $img_Vinkpass
            $global:passwdcheck = "No"
        }
})

# EnterRemote Textbox
$textBoxEnterRemote = New-Object System.Windows.Forms.TextBox
$textBoxEnterRemote.Location = New-Object System.Drawing.Point(120,260)
$textBoxEnterRemote.Size = New-Object System.Drawing.Size(300,20)
$textBoxEnterRemote.Text = "C:\Install"

# RemotePath Picturebox
$file_RemotePath = (get-item "$Install_Path\media\remote_on.png")
$img_RemotePath = [System.Drawing.Image]::Fromfile($file_RemotePath);
$fileHVR_RemotePath = (get-item "$Install_Path\media\remote_off.png")
$imgHVR_RemotePath = [System.Drawing.Image]::Fromfile($fileHVR_RemotePath);
$pictureBoxRemotePath = new-object Windows.Forms.PictureBox
$pictureBoxRemotePath.Width =  $img_RemotePath.Size.Width;
$pictureBoxRemotePath.Height =  $img_RemotePath.Size.Height;
$pictureBoxRemotePath.Image = $img_RemotePath;
$pictureBoxRemotePath.Location = New-Object System.Drawing.Size(50,260)
$pictureBoxRemotePath.BackColor = [System.Drawing.Color]::FromName("Transparent")
$pictureBoxRemotePath.add_MouseEnter({
    $LblToolTip.Text = "Set path of the Remote Folder to install sysmon (example: C:\Install) "
})
$pictureBoxRemotePath.add_MouseLeave({
    $LblToolTip.Text = ">.."
    $pictureBoxRemotePath.Image= $img_RemotePath;
})
$pictureBoxRemotePath.add_MouseHover({
    $pictureBoxRemotePath.Image= $imgHVR_RemotePath;
})
$pictureBoxRemotePath.Add_Click(
    { 
        $global:RemotePath = $textBoxEnterRemote.Text
        if ($global:RemotePath -eq "") {
                $LblRemoteSet.Text = "remote set: No"
                $LblRemoteSet.ForeColor = "Red"
                $file_Vinkremote = (get-item "$Install_Path\media\NoVink.png")
                $img_Vinkremote = [System.Drawing.Image]::Fromfile($file_Vinkremote);
                $pictureBoxVinkremote.Image = $img_Vinkcnfp
                $global:remotecheck = "No"
            } 
            else {
                $LblremoteSet.Text = "remote set: Yes"
                $LblremoteSet.ForeColor = "White"
                $file_Vinkremote = (get-item "$Install_Path\media\Vink.png")
                $img_Vinkremote = [System.Drawing.Image]::Fromfile($file_Vinkremote);
                $pictureBoxVinkremote.Image = $img_Vinkremote
                $global:remotecheck = "Yes"
            }

    }
)


# Install Picturebox
$file_Install = (get-item "$Install_Path\media\install_on.png")
$img_Install = [System.Drawing.Image]::Fromfile($file_Install);
$fileHVR_Install = (get-item "$Install_Path\media\install_off.png")
$imgHVR_Install = [System.Drawing.Image]::Fromfile($fileHVR_Install);
$pictureBoxInstall = new-object Windows.Forms.PictureBox
$pictureBoxInstall.Width =  $img_Install.Size.Width;
$pictureBoxInstall.Height =  $img_Install.Size.Height;
$pictureBoxInstall.Image = $img_Install;
$pictureBoxInstall.Location = New-Object System.Drawing.Size(50,340)
$pictureBoxInstall.BackColor = [System.Drawing.Color]::FromName("Transparent")
$pictureBoxInstall.add_MouseEnter({
    $LblToolTip.Text = "Install Sysmon on servers in servers.txt "
})
$pictureBoxInstall.add_MouseLeave({
    $LblToolTip.Text = ">.."
    $pictureBoxInstall.Image= $img_Install;
})
$pictureBoxInstall.add_MouseHover({
    $pictureBoxInstall.Image= $imgHVR_Install;
})
$pictureBoxInstall.Add_Click({ 
# DEBUG
write-host "Sure: $global:IamSure"
    

            if (($global:servercheck -eq "Yes") -and ($global:usercheck -eq "Yes") -and ($global:passwdcheck -eq "Yes") -and ($global:configcheck -eq "Yes") -and ($global:remotecheck -eq "Yes")) {  
                $LblsSure.Text = "Are you sure you want to install Sysmon?"
                $sec_form.Add_Shown( { $sec_form.Activate() } )
                $sec_form.ShowDialog()
                $sec_form.Topmost = $true
                if ($global:iamsure -eq "Yes") {
                    $inp = get-content "$Install_Path\config\servers.txt"
                    $securepass = ConvertTo-SecureString $global:passwd -AsPlainText -Force
                    $Cred = New-Object System.Management.Automation.PSCredential $global:username,$securepass
                    $rmtpth = $global:remotepath
                    $rmtsplit = $rmtpth -split "\\"
                    $drive = $rmtsplit[0] + "\"
                    $folder = $rmtsplit[1]
                    
                    foreach ($server in $inp) {
                        $Session = New-PSSession -ComputerName $server -Credential $cred
                        
                        # controleren of de destination map al bestaat op de server
                        if (Invoke-Command -Session $session -ScriptBlock {Test-Path -path $args[0]} -ArgumentList $rmtpth) {
                        # Zo nee, dan aanmaken.
                        } else {
                            Invoke-command -Session $session -ScriptBlock {New-Item -path $using:drive -name $using:folder -ItemType directory}
                        }
                        
                        # DEBUG
                        write-host "Configpath: $global:configpath"

                        # de config file van het UNC path op het netwerk kopieren naar de server    
                        Copy-Item "$global:configpath" -ToSession $Session -Destination $RmtPth
                        # sysmon64.exe kopieren naar de server
                        Copy-Item "$Install_path\config\sysmon64.exe" -ToSession $Session -Destination $RmtPth

                        # Sysmon64.exe -i met de config remote uitvoeren op de server
                        $configsplit = $global:configpath -split "\\"
                        $configcount = $configsplit.count
                        $configfile = $configsplit[$configcount-1]

                        # DEBUG
                        write-host $configsplit
                        write-host $configcount
                        write-host $configfile

                        Invoke-Command -Session $session -ScriptBlock {
                            cmd.exe /C "$using:rmtpth\Sysmon64.exe" -i $using:rmtpth\$using:configfile -accepteula
                            # Voor security redenen de configfile weer verwijderen van de server.
                            Remove-item "$using:rmtpth\$using:configfile" -force
                        }            
                    }    
                    # Melden dat het gelukt is

                    $readydate = Get-Date -format "dd-MM-yyyy"
                    $readytime = Get-Date -format "hh:mm:ss"

                    $LblInstreadyDate.Text = $readydate
                    $LblInstreadyTime.Text = $readytime
                    $file_InstReady = (get-item "$Install_Path\media\ready_on.png")
                    $img_InstReady = [System.Drawing.Image]::Fromfile($file_InstReady);
                    $pictureBoxInstReady.Image = $img_InstReady                
                }

            } else {
                $thrd_form.Add_Shown( { $thrd_form.Activate() } )
                $thrd_form.ShowDialog()
                $thrd_form.Topmost = $true

            } 

})

# InstReady Picturebox
$file_InstReady = (get-item "$Install_Path\media\ready_off.png")
$img_InstReady = [System.Drawing.Image]::Fromfile($file_InstReady);
$pictureBoxInstReady = new-object Windows.Forms.PictureBox
$pictureBoxInstReady.width = $img_InstReady.Size.Width;
$pictureBoxInstReady.height = $img_InstReady.Size.Height;
$pictureBoxInstReady.Image = $img_InstReady
$PictureBoxInstReady.BackColor = [System.Drawing.Color]::FromName("Transparent")
$pictureBoxInstReady.location = New-Object System.Drawing.Size(75,460)

# InstReadyDate Label
$LblInstreadyDate = New-Object System.Windows.Forms.Label
$LblInstreadyDate.AutoSize = $true
$LblInstreadyDate.ForeColor = "White"
$LblInstreadyDate.Location = New-Object System.Drawing.Size(66,510)
$LblInstreadyDate.BackColor = [System.Drawing.Color]::FromName("Transparent")
$LblInstreadyDate.Font = New-Object System.Drawing.Font("Tahoma",10,[System.Drawing.FontStyle]::Regular)

# InstreadyTime Label
$LblInstreadyTime = New-Object System.Windows.Forms.Label
$LblInstreadyTime.AutoSize = $true
$LblInstreadyTime.ForeColor = "White"
$LblInstreadyTime.Location = New-Object System.Drawing.Size(70,530)
$LblInstreadyTime.BackColor = [System.Drawing.Color]::FromName("Transparent")
$LblInstreadyTime.Font = New-Object System.Drawing.Font("Tahoma",10,[System.Drawing.FontStyle]::Regular)

# PushReady Picturebox
$file_PushReady = (get-item "$Install_Path\media\ready_off.png")
$img_PushReady = [System.Drawing.Image]::Fromfile($file_PushReady);
$pictureBoxPushReady = new-object Windows.Forms.PictureBox
$pictureBoxPushReady.width = $img_PushReady.Size.Width;
$pictureBoxPushReady.height = $img_PushReady.Size.Height;
$pictureBoxPushReady.Image = $img_PushReady
$PictureBoxPushReady.BackColor = [System.Drawing.Color]::FromName("Transparent")
$pictureBoxPushReady.location = New-Object System.Drawing.Size(215,460)

# PushReadyDate Label
$LblPushreadyDate = New-Object System.Windows.Forms.Label
$LblPushreadyDate.AutoSize = $true
$LblPushreadyDate.ForeColor = "White"
$LblPushreadyDate.Location = New-Object System.Drawing.Size(206,510)
$LblPushreadyDate.BackColor = [System.Drawing.Color]::FromName("Transparent")
$LblPushreadyDate.Font = New-Object System.Drawing.Font("Tahoma",10,[System.Drawing.FontStyle]::Regular)

# PushreadyTime Label
$LblPushreadyTime = New-Object System.Windows.Forms.Label
$LblPushreadyTime.AutoSize = $true
$LblPushreadyTime.ForeColor = "White"
$LblPushreadyTime.Location = New-Object System.Drawing.Size(210,530)
$LblPushreadyTime.BackColor = [System.Drawing.Color]::FromName("Transparent")
$LblPushreadyTime.Font = New-Object System.Drawing.Font("Tahoma",10,[System.Drawing.FontStyle]::Regular)

# Push Config Picturebox
$file_Config = (get-item "$Install_Path\media\Config_on.png")
$img_Config = [System.Drawing.Image]::Fromfile($file_Config);
$fileHVR_Config = (get-item "$Install_Path\media\Config_off.png")
$imgHVR_Config = [System.Drawing.Image]::Fromfile($fileHVR_Config);
$pictureBoxConfig = new-object Windows.Forms.PictureBox
$pictureBoxConfig.Width =  $img_Config.Size.Width;
$pictureBoxConfig.Height =  $img_Config.Size.Height;
$pictureBoxConfig.Image = $img_Config;
$pictureBoxConfig.Location = New-Object System.Drawing.Size(190,340)
$pictureBoxConfig.BackColor = [System.Drawing.Color]::FromName("Transparent")
$pictureBoxConfig.add_MouseEnter({
    $LblToolTip.Text = "Push the new Sysmon Config file to servers in servers.txt "
})
$pictureBoxConfig.add_MouseLeave({
    $LblToolTip.Text = ">.."
    $pictureBoxConfig.Image= $img_Config;
})
$pictureBoxConfig.add_MouseHover({
    $pictureBoxConfig.Image= $imgHVR_Config;
})
$pictureBoxConfig.Add_Click({ 
    if (($global:servercheck -eq "Yes") -and ($global:usercheck -eq "Yes") -and ($global:passwdcheck -eq "Yes") -and ($global:configcheck -eq "Yes") -and ($global:remotecheck -eq "Yes")) {  
        $LblsSure.Text = "Are you sure you want to push new config?"
        $sec_form.Add_Shown( { $sec_form.Activate() } )
        $sec_form.ShowDialog()
        $sec_form.Topmost = $true
        if ($global:iamsure -eq "Yes") {
            $inp = get-content "$Install_Path\config\servers.txt"
            $securepass = ConvertTo-SecureString $global:passwd -AsPlainText -Force
            $Cred = New-Object System.Management.Automation.PSCredential $global:username,$securepass
            $rmtpth = $global:remotepath
            $rmtsplit = $rmtpth -split "\\"
            $drive = $rmtsplit[0] + "\"
            $folder = $rmtsplit[1]

            foreach ($server in $inp) { 
                $Session = New-PSSession -ComputerName $server -Credential $cred
                # de config file van het UNC path op het netwerk kopieren naar de server
                Copy-Item "$global:configpath" -ToSession $Session -Destination $RmtPth
                # Sysmon64.exe -c met de nieuwe configfile remote uitvoeren op de server
                $configsplit = $global:configpath -split "\\"
                $configcount = $configsplit.count
                $configfile = $configsplit[$configcount-1]

                Invoke-Command -Session $session -ScriptBlock {
                    cmd.exe /C "$using:rmtpth\Sysmon64.exe" -c $using:rmtpth\$using:configfile 
                    # Voor security redenen de configfile weer verwijderen van de server.
                    Remove-item "$using:rmtpth\$using:configfile" -force
                }
            }
        }
    }
    # Melden dat het gelukt is

    $readydate = Get-Date -format "dd-MM-yyyy"
    $readytime = Get-Date -format "hh:mm:ss"

    $LblPushreadyDate.Text = $readydate
    $LblPushreadyTime.Text = $readytime
    $file_PushReady = (get-item "$Install_Path\media\ready_on.png")
    $img_PushReady = [System.Drawing.Image]::Fromfile($file_PushReady);
    $pictureBoxPushReady.Image = $img_PushReady   
})

# PermReady Picturebox
$file_PermReady = (get-item "$Install_Path\media\ready_off.png")
$img_PermReady = [System.Drawing.Image]::Fromfile($file_PermReady);
$pictureBoxPermReady = new-object Windows.Forms.PictureBox
$pictureBoxPermReady.width = $img_PermReady.Size.Width;
$pictureBoxPermReady.height = $img_PermReady.Size.Height;
$pictureBoxPermReady.Image = $img_PermReady
$PictureBoxPermReady.BackColor = [System.Drawing.Color]::FromName("Transparent")
$pictureBoxPermReady.location = New-Object System.Drawing.Size(355,460)

# PermReadyDate Label
$LblPermreadyDate = New-Object System.Windows.Forms.Label
$LblPermreadyDate.AutoSize = $true
$LblPermreadyDate.ForeColor = "White"
$LblPermreadyDate.Location = New-Object System.Drawing.Size(346,510)
$LblPermreadyDate.BackColor = [System.Drawing.Color]::FromName("Transparent")
$LblPermreadyDate.Font = New-Object System.Drawing.Font("Tahoma",10,[System.Drawing.FontStyle]::Regular)

# PermreadyTime Label
$LblPermreadyTime = New-Object System.Windows.Forms.Label
$LblPermreadyTime.AutoSize = $true
$LblPermreadyTime.ForeColor = "White"
$LblPermreadyTime.Location = New-Object System.Drawing.Size(350,530)
$LblPermreadyTime.BackColor = [System.Drawing.Color]::FromName("Transparent")
$LblPermreadyTime.Font = New-Object System.Drawing.Font("Tahoma",10,[System.Drawing.FontStyle]::Regular)

# Perms Picturebox
$file_Perms = (get-item "$Install_Path\media\Perms_on.png")
$img_Perms = [System.Drawing.Image]::Fromfile($file_Perms);
$fileHVR_Perms = (get-item "$Install_Path\media\Perms_off.png")
$imgHVR_Perms = [System.Drawing.Image]::Fromfile($fileHVR_Perms);
$pictureBoxPerms = new-object Windows.Forms.PictureBox
$pictureBoxPerms.Width =  $img_Perms.Size.Width;
$pictureBoxPerms.Height =  $img_Perms.Size.Height;
$pictureBoxPerms.Image = $img_Perms;
$pictureBoxPerms.Location = New-Object System.Drawing.Size(330,340)
$pictureBoxPerms.BackColor = [System.Drawing.Color]::FromName("Transparent")
$pictureBoxPerms.add_MouseEnter({
    $LblToolTip.Text = "Set Sysmon permissions for servers in servers.txt "
})
$pictureBoxPerms.add_MouseLeave({
    $LblToolTip.Text = ">.."
    $pictureBoxPerms.Image= $img_Perms;
})
$pictureBoxPerms.add_MouseHover({
    $pictureBoxPerms.Image= $imgHVR_Perms;
})
$pictureBoxPerms.Add_Click({ 
    if (($global:servercheck -eq "Yes") -and ($global:usercheck -eq "Yes") -and ($global:passwdcheck -eq "Yes") -and ($global:configcheck -eq "Yes") -and ($global:remotecheck -eq "Yes")) {  
        $LblsSure.Text = "Are you sure you want to set permissions?"
        $sec_form.Add_Shown( { $sec_form.Activate() } )
        $sec_form.ShowDialog()
        $sec_form.Topmost = $true
        if ($global:iamsure -eq "Yes") {
            $inp = get-content "$Install_Path\config\servers.txt"
            $securepass = ConvertTo-SecureString $global:passwd -AsPlainText -Force
            $Cred = New-Object System.Management.Automation.PSCredential $global:username,$securepass
            foreach ($server in $inp) { 
                $Session = New-PSSession -ComputerName $server -Credential $cred
                # wevtutil sl met de rechten remote uitvoeren op de server
                Invoke-Command -Session $session -ScriptBlock {
                    cmd.exe /C "wevtutil sl Microsoft-Windows-Sysmon/Operational /ca:O:BAG:SYD:(A;;0xf0007;;;SY)(A;;0x7;;;BA)(A;;0x1;;;BO)(A;;0x1;;;SO)(A;;0x1;;;S-1-5-32-573)(A;;0x1;;;S-1-5-20)"
                }
            }
        }    
    } 
    # Melden dat het gelukt is

    $readydate = Get-Date -format "dd-MM-yyyy"
    $readytime = Get-Date -format "hh:mm:ss"

    $LblPermreadyDate.Text = $readydate
    $LblPermreadyTime.Text = $readytime
    $file_PermReady = (get-item "$Install_Path\media\ready_on.png")
    $img_PermReady = [System.Drawing.Image]::Fromfile($file_PermReady);
    $pictureBoxPermReady.Image = $img_PermReady      
})

# Exit Picturebox
$file_Exit = (get-item "$Install_Path\media\exit.png")
$img_Exit = [System.Drawing.Image]::Fromfile($file_Exit);
$pictureBoxExit = new-object Windows.Forms.PictureBox
$pictureBoxExit.Width =  $img_Exit.Size.Width;
$pictureBoxExit.Height =  $img_Exit.Size.Height;
$pictureBoxExit.Image = $img_Exit;
$pictureBoxExit.Location = New-Object System.Drawing.Size(980,20)
$pictureBoxExit.BackColor = [System.Drawing.Color]::FromName("Transparent")
$pictureBoxExit.add_MouseEnter({
    $LblTooltip.Text = "Close SCC."
})
$PictureBoxExit.add_MouseLeave({
    $LblTooltip.Text = ">.."
})
$pictureBoxExit.Add_Click(
    { 
        $main_form.Close()
        if ($debug -eq "Yes" -or $debug -eq "yes" -or $debug -eq "YES") { stop-transcript}
    }
)


# Make form
$main_form.Controls.Add($PictureBoxLogo)
$main_form.Controls.Add($LblTooltip)
$main_form.Controls.Add($textBoxEnterPath)
$main_form.Controls.Add($pictureBoxCredentials)
$main_form.Controls.Add($pictureBoxInstall)
$main_form.Controls.Add($pictureBoxConfig)
$main_form.Controls.Add($pictureBoxPerms)
$main_form.Controls.Add($textBoxEnterUser)
$main_form.Controls.Add($textBoxEnterPasswd)
$main_form.Controls.Add($textBoxEnterRemote)
$main_form.Controls.Add($pictureBoxConfigPath)
$main_form.Controls.Add($pictureBoxRemotePath)
$main_form.Controls.Add($pictureBoxServersRefresh)
$main_form.Controls.Add($pictureBoxServersTxt)
$main_form.Controls.Add($Lblnrservers)
$main_form.Controls.Add($LblConfSet)
$main_form.Controls.Add($LblUsernSet)
$main_form.Controls.Add($LblpasswdSet)
$main_form.Controls.Add($LblremoteSet)
$main_form.Controls.Add($LblInstreadyDate)
$main_form.Controls.Add($LblInstreadyTime)
$main_form.Controls.Add($LblPushreadyDate)
$main_form.Controls.Add($LblPushreadyTime)
$main_form.Controls.Add($LblPermreadyDate)
$main_form.Controls.Add($LblPermreadyTime)
$main_form.Controls.Add($textBoxServers)
$main_form.Controls.Add($pictureBoxOutput)
$main_form.Controls.Add($pictureBoxVinksrvs)
$main_form.Controls.Add($pictureBoxVinkcnfp)
$main_form.Controls.Add($pictureBoxVinkuser)
$main_form.Controls.Add($pictureBoxVinkpass)
$main_form.Controls.Add($pictureBoxVinkremote)
$main_form.Controls.Add($pictureBoxInstReady)
$main_form.Controls.Add($pictureBoxPushReady)
$main_form.Controls.Add($pictureBoxPermReady)
$main_form.Controls.Add($pictureBoxExit)
$main_form.Add_Shown( { $main_form.Activate() } )
$main_form.ShowDialog()
$main_form.Topmost = $true




























<#

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

#>