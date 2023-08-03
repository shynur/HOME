set WshShell = CreateObject("WScript.Shell")
WshShell.SendKeys "ssh username@IP.address{ENTER}"
WScript.Sleep 1500
WshShell.SendKeys "Password{ENTER}"

' Local Variables:
' coding: utf-8-unix
' End:
