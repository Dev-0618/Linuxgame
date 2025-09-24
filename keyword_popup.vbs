Option Explicit

Dim fso, shell, desktop, demoFolder
Set fso = CreateObject("Scripting.FileSystemObject")
Set shell = CreateObject("WScript.Shell")

' ----------------------------
' Step 1: Create demo folder and 50 "suspicious" files
' ----------------------------
desktop = shell.ExpandEnvironmentStrings("%USERPROFILE%\Desktop")
demoFolder = desktop & "\pookie virus"

If Not fso.FolderExists(demoFolder) Then
    fso.CreateFolder demoFolder
End If

Dim adjectives, nouns, i, aIndex, nIndex, randNum, fileName, file
adjectives = Array("free","crack","keygen","update","secret","stolen")
nouns = Array("invoice","passwords","bank","mail","photos","backup")

Randomize

For i = 1 To 50
    aIndex = Int(Rnd * 6)
    nIndex = Int(Rnd * 6)
    randNum = Int(Rnd * 100000)
    fileName = adjectives(aIndex) & "-" & nouns(nIndex) & "-" & randNum & ".txt"
    Set file = fso.CreateTextFile(demoFolder & "\" & fileName, True)
    file.WriteLine "Demo file created for security-demo: " & fileName
    file.Close
Next

' ----------------------------
' Step 2: Open Chrome tabs
' ----------------------------
shell.Run "chrome ""https://dev-0618.github.io/127.4.7.8""", 1, False
WScript.Sleep 5000
' shell.Run "chrome ""https://atria.edu""", 1, False

' ----------------------------
' Step 3: Popup asking for keyword (no separate OK)
' ----------------------------
WScript.Sleep 5000
Dim keyword, userInput
keyword = "      "
userInput = ""

Do While userInput <> keyword
    userInput = InputBox("Your PC is infected by Dev0Root Virus!" & vbCrLf & "Enter keyword to clean:", "WARNING!")
Loop

' Once correct keyword entered, continue
' (Optional: you can also log "cleaned" message in folder or skip MsgBox)
