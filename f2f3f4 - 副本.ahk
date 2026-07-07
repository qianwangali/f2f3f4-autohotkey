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



#Requires AutoHotkey v2.0

F8::
{
    notepad3 := "C:\Program Files\Notepad3\Notepad3.exe"

    paths := GetSelectedFiles()

    if (paths.Length = 0)
        return

    args := ""

    for path in paths
    {
        ; 如果是 .lnk 快捷方式，解析真实目标
        if (StrLower(SubStr(path, -3)) = ".lnk")
        {
            target := ""
            FileGetShortcut(path, &target)

            if (target != "")
                path := target
        }

        args .= '"' path '" '
    }

    Run('"' notepad3 '" ' args)
}

GetSelectedFiles()
{
    paths := []

    ; 方法1：资源管理器窗口
    explorer := ComObject("Shell.Application")

    for window in explorer.Windows
    {
        try
        {
            if WinActive("ahk_id " window.HWND)
            {
                items := window.Document.SelectedItems()

                for item in items
                    paths.Push(item.Path)

                if (paths.Length > 0)
                    return paths
            }
        }
    }

    ; 方法2：桌面 / 其他地方，用 Ctrl+C 获取选中文件路径
    oldClip := ClipboardAll()
    A_Clipboard := ""

    Send("^c")

    if ClipWait(0.5)
    {
        for path in StrSplit(A_Clipboard, "`n", "`r")
        {
            if (path != "")
                paths.Push(path)
        }
    }

    A_Clipboard := oldClip

    return paths
}





!F8::
{
    folder := GetActiveFolderPath()
    if !folder
        folder := A_Desktop

    input := InputBox(
        "请输入文本文件名：`n不输入则使用默认名称。`n按 Esc 取消。",
        "新建文本文件",
        "w360 h150"
    )

    if (input.Result = "Cancel")
        return

    name := Trim(input.Value)

    if (name = "")
        file := GetNewTextFile(folder)
    else
        file := BuildTextFilePath(folder, name)

    FileAppend("", file, "UTF-8")
    Run('"' "C:\Program Files\Notepad3\Notepad3.exe" '" "' file '"')
}

GetActiveFolderPath()
{
    hwnd := WinActive("ahk_class CabinetWClass")
    if !hwnd
        hwnd := WinActive("ahk_class ExploreWClass")

    if hwnd
    {
        for window in ComObject("Shell.Application").Windows
        {
            try
            {
                if (window.HWND = hwnd)
                    return window.Document.Folder.Self.Path
            }
        }
    }

    if WinActive("ahk_class Progman") || WinActive("ahk_class WorkerW")
        return A_Desktop

    return ""
}

GetNewTextFile(folder)
{
    return AvoidDuplicateFile(folder "\新建文本文档.txt")
}

BuildTextFilePath(folder, name)
{
    ; 替换 Windows 文件名非法字符
    name := RegExReplace(name, '[\\/:*?<>|"]', "_")

    ; 如果用户没写扩展名，自动补 .txt
    if !RegExMatch(name, '\.[^\\/:*?<>|"]+$')
        name .= ".txt"

    return AvoidDuplicateFile(folder "\" name)
}

AvoidDuplicateFile(file)
{
    if !FileExist(file)
        return file

    SplitPath(file, &fileName, &dir, &ext, &nameNoExt)

    i := 2
    loop
    {
        if (ext != "")
            newFile := dir "\" nameNoExt " (" i ")." ext
        else
            newFile := dir "\" nameNoExt " (" i ")"

        if !FileExist(newFile)
            return newFile

        i++
    }
}





