REM -*- mode: basic-generic; coding: utf-8-unix; -*-

Dim hosts: Set hosts = CreateObject("Scripting.Dictionary")
hosts.Add "fedora", Array("fedora.host.shynur.fun", "PassWord")
hosts.Add "centos", Array("centos.host.shynur.fun", "PassWord")

Dim hostname, args: Set args = WScript.Arguments
If args.Count <> 1 Then
    WScript.Echo "Usage:" & vbCrLf & "hurry-ssh.vbs HOSTNAME"
    WScript.Quit(1)
Else
    hostname = args(0)
End If

If Not hosts.Exists(hostname) Then
    WScript.Echo "Error: Host doesn't exist!"
    WScript.Quit(22)
End If

set WshShell = CreateObject("WScript.Shell")
WshShell.SendKeys "ssh shynur@" & hosts(hostname)(0) & "{ENTER}"
WScript.Sleep 1500  '等待连接…
WScript.Echo ""
WshShell.SendKeys hosts(hostname)(1) & "{ENTER}"
