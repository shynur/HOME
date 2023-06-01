'2022-12-16, Shynur

set WshShell = CreateObject("WScript.Shell")
WshShell.SendKeys "ssh username@IP.address{ENTER}"
WScript.Sleep 1500
WshShell.SendKeys "Password{ENTER}"
