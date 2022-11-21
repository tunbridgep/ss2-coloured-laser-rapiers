@echo off
::Don't forget quotes when specifying paths!
::Passing 1 as the fourth parameter will generate DML headers
call build/makedml.cmd -f "%~dp0\src" "%~dp0\out" "vanilla" "scp" "secmod"
@del "Coloured Laser Rapiers AIO.7z"
7z a "Coloured Laser Rapiers AIO.7z" "%~dp0\out\*"
pause