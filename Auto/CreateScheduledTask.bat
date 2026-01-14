@echo off
REM Template for creating a scheduled task in Windows
REM Modify the variables below according to your needs

REM Task Configuration
set TASK_NAME=FileCheckTask
set SCRIPT_PATH=C:\Users\braya\Auto\FileCheckTask.ps1
set SCHEDULE_TIME=21:50
set SCHEDULE_FREQUENCY=DAILY

REM You can also modify the schtasks command for different schedules:
REM Weekly: /sc WEEKLY /d MON (every Monday)
REM Monthly: /sc MONTHLY /d 15 (15th of each month)
REM Multiple days: /sc WEEKLY /d MON,WED,FRI

REM Create the scheduled task
echo Creating scheduled task: %TASK_NAME%
schtasks /create ^
    /tn "%TASK_NAME%" ^
    /tr "powershell.exe -ExecutionPolicy Bypass -File \"%SCRIPT_PATH%\"" ^
    /sc %SCHEDULE_FREQUENCY% ^
    /st %SCHEDULE_TIME% ^
    /f

if %errorlevel% equ 0 (
    echo Task created successfully!
    echo Task Name: %TASK_NAME%
    echo Script Path: %SCRIPT_PATH%
    echo Schedule: %SCHEDULE_FREQUENCY% at %SCHEDULE_TIME%
) else (
    echo Error creating the task. Make sure you're running as administrator.
)

pause