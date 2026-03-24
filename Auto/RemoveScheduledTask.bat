@echo off

set TASK_NAME=FileCheckTask

echo Deleting scheduled task: %TASK_NAME%
schtasks /delete /tn "%TASK_NAME%" /f

if %errorlevel% equ 0 (
		echo Task deleted successfully!
) else (
		echo Error deleting the task.
)

pause
