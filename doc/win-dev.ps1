Set-PSDebug -Trace 1


$VsVersion = 2019
$BoostVersion = @(1, 71, 0)
$OpensslVersion = '1_1_1h'


function Install-Exe {
	param (
		[string]$Url,
		[string]$Dir
	)

	$TempDir = Join-Path ([System.IO.Path]::GetTempPath()) ([System.Guid]::NewGuid().Guid)
	$ExeFile = Join-Path $TempDir inst.exe

	New-Item -ItemType Directory -Path $TempDir
	Invoke-WebRequest -Uri $Url -OutFile $ExeFile -UseBasicParsing
	Start-Process -Wait -FilePath $ExeFile -ArgumentList @('/VERYSILENT', '/INSTALL', '/PASSIVE', '/NORESTART', "/DIR=${Dir}")
	Remove-Item -Recurse -Path $TempDir
}


Invoke-Expression (New-Object Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')

$RegEnv = 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment'
$ChocoPath = ";$(Join-Path $Env:AllUsersProfile chocolatey\bin)"

Set-ItemProperty -Path $RegEnv -Name Path -Value ((Get-ItemProperty -Path $RegEnv -Name Path).Path + $ChocoPath)
$Env:Path += $ChocoPath


choco install -y "visualstudio${VsVersion}community"
choco install -y "visualstudio${VsVersion}-workload-netcoretools"
choco install -y "visualstudio${VsVersion}-workload-vctools"
choco install -y "visualstudio${VsVersion}-workload-manageddesktop"
choco install -y "visualstudio${VsVersion}-workload-nativedesktop"
choco install -y "visualstudio${VsVersion}-workload-universal"
choco install -y "visualstudio${VsVersion}buildtools"


choco install -y git
choco install -y cmake
choco install -y winflexbison3
choco install -y windows-sdk-8.1
choco install -y wixtoolset


Install-Exe -Url "https://master.dl.sourceforge.net/project/boost/boost-binaries/$($BoostVersion -join '.')/boost_$($BoostVersion -join '_')-msvc-14.2-64.exe" -Dir "C:\local\boost_$($BoostVersion -join '_')-Win64"

Install-Exe -Url "https://slproweb.com/download/Win64OpenSSL-${OpensslVersion}.exe" -Dir "C:\local\OpenSSL_${OpensslVersion}-Win64"
