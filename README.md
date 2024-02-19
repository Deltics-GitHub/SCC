# SCC
**Sysmon Control Center v1.2**



Sysmon Control Center is a tool that helps you deploy Sysmon64.exe and the XML settings file easily throughout your Windows Domain Servers environment. 

* Download the ZIP
* Extract the ZIP on a (management-)server in your Windows Domain
* Open a Powershell prompt as admin
* CD to the folder where you extracted the ZIP
* Issue the following command to set the parameters for SCC
* `notepad .\config\localconfig.ini`
*  Change the value next to the [PTH] parameter to match the path where you have extracted the ZIP (it should match the path to SysmonControlCenter.ps1)
*  If you leave [DBG] to `Yes`, a logfile will be generated in the .\log directory.
*  Save the file and close Notepad
*  Run SCC with the command: `.\SysmonControlCenter.ps1`

![image](https://github.com/golnebo/SCC/assets/18641580/518b65b6-005e-466d-9e59-9750802c3b7e)

* Fill in all the empty white fields
  * _Set config path_ : Enter the path from where SCC can copy the XML config file. Use the path and the full name. (`\\server\share\config.xml`). 
  * _Set credentials_ : Enter a domain and user name for a user with permissions to copy, write and execute SCC to and from the target machines. (`DOMAIN\Administrator`)
  * _Set remote folder_ : Enter a folder (including drive) that SCC will use to operate a copy of SCC out of. (`C:\SCC`)
    * As of a bug, you can only enter a single folder and no subfolders. This will be adressed in a future release. Also the folder is not cleaned up yet after running SCC.
  * _edit servers.txt_ : This will open servers.txt in which you can enter the FQDN's of all the servers you want to configure Sysmon on. Each FQDN must be on it's own line.
  * _refresh server_list_ : You can also fill the servers.txt externally. Always use this button to make sure the latest list of FQDN's is used when running SCC.
* Click the buttons
  * To commit your settings, you must click each aforementioned button. If you do, and there is no error, the checks on the right of the screen will turn from orange to green. Only if all checks are green you can proceed to install.
 
When you are Ready, click the Install Sysmon button to proceed and Yes to confirm.

When SCC is ready, a green button will appear beneath the Install Sysmon button indicating RDY.


[Push New Config]
[Set Perms]
