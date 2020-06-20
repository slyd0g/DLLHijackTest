# DLLHijackTest

![Get-PotentialDLLHijack.ps1](https://raw.githubusercontent.com/slyd0g/DLLHijackTest/master/example.png?token=AFLJJJ5LBXAJDSBGC7JLPTC65Z6RY)

## Usage
- Modify ```outputFile``` variable within ```write.cpp```
- Build the project for the appropriate architecture
- Open ```powershell.exe``` and load ```Get-PotentialDLLHijack.ps1``` into memory
	- ```. .\Get-PotentialDLLHijack.ps1```
- Run ```Get-PotentialDLLHijack``` with the appropriate flags
	- Example:
		- ```Get-PotentialDLLHijack -CSVPath .\Logfile.CSV -MaliciousDLLPath .\DLLHijackTest.dll -ProcessPath "C:\Users\John\AppData\Local\Programs\Microsoft VS Code\Code.exe"```
	- ```-CSVPath``` takes in a path to a .csv file exported from Procmon
	- ```-MaliciousDLLPath``` takes in a path to your compiled hijack DLL
	- ```-ProcessPath``` takes in a path to the executable you want to run
	- ```-ProcessArguments``` takes in commandline arguments you want to pass to the executeable
- View the contents of ```outputFile``` for found DLL hijacks
	- Run ```strings.exe``` on the ```outputFile``` to clean up the output paths
- Party!!!

