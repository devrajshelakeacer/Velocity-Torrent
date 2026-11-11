Set WshShell = CreateObject("WScript.Shell")
strPath = WshShell.CurrentDirectory
WshShell.Run """" & strPath & "\.venv\Scripts\python.exe"" -u """ & strPath & "\run_app.py""", 1, False
WScript.Sleep 1500
WshShell.AppActivate "VELOCITY"
