#Requires AutoHotkey v2.0

;===========================
; F2 - 有道词典
;===========================
F2::
{
    winTitle := "ahk_exe YoudaoDict.exe"

    if WinActive(winTitle)
    {
        ;MsgBox WinActive("ahk_exe YoudaoDict.exe")
        ;WinMinimize(winTitle)
	WinMinimize("A")
        return
    }
    Send("^c")
    ClipWait(1)
    ;Sleep(500)
    ActivateOrRun(
        "D:\Program Files\Dict\YoudaoDict.exe",
        winTitle
    )

    FocusYoudaoInput(winTitle)

    Send("^v")
    Sleep(100)
    Send("^a")   ; 选中输入框中所有文字
  
}

;===========================
; F3 - Obsidian
;===========================
F3::
{
    winTitle := "ahk_exe Obsidian.exe"
    if WinActive(winTitle)
    {
	WinMinimize("A")
        return
    }
    ActivateOrRun(
        "D:\Program Files\Obsidian\Obsidian.exe",
        winTitle
    )
}

;===========================
; F4 - 最小化当前窗口
;===========================
F4::
{
    WinMinimize("A")
}

;===========================
; 通用函数：存在就激活，不存在就启动
;===========================
ActivateOrRun(exePath, winTitle)
{



    if WinExist(winTitle)
    {
        WinRestore(winTitle)
        WinActivate(winTitle)
        WinWaitActive(winTitle, , 2)
    }
    else
    {
        Run(exePath)
        WinWait(winTitle, , 10)
        WinActivate(winTitle)
        WinWaitActive(winTitle, , 2)
    }

}

FocusYoudaoInput(winTitle)
{
    if !WinWaitActive(winTitle, , 2)
        return false

    CoordMode("Mouse", "Client")
    MouseClick("Left", 400, 220)
    Sleep(50)
 
    return true
}
