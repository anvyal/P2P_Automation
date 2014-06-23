mkdir Logs
perl WiFi_Direct.pl | tee Logs/stdout.log
@echo off
set /p pathName=Press any key to continue..%=%
