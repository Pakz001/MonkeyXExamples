Import mojo

Import brl.FileSystem
Import brl.requesters
Import brl.process

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(1)
        renamedir()
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
    	Scale 2,2
        Cls 0,0,0 
        SetColor 255,255,255
		DrawText "Rename pakz Directory tool can be closed now..",10,10
    End Method
End Class

Function renamedir()
	' a variable contains the directory that the pakz examples are in
	Local a:String = RequestDir("Select Pakz examples directory to rename files..","")
	If a="" Then Return
	' add a directory character to a
	a+="\"
	' list a and b are String stack lists.
	' they contain the original file names
	' and the changed names
	Local lista:= New StringStack
	Local listb:= New StringStack
	' read the directory and put the names in
	' both lists	
    For Local f:=Eachin LoadDir(a)
		lista.Push(f)
		listb.Push(f)
    Next
    ' Here we put into listb the new names
    For Local i=0 Until lista.Length
    	Local ii:String=lista.Get(i)
    	ii = ii.ToLower.Replace("monkey-x - ","")
    	ii = ii.Replace("monkeyx - ","")
    	ii = ii.Replace(" - code example","")
    	ii = ii.Replace("monkey getting started - ","")
    	ii = ii.Replace("beginners - ","")
    	ii = ii.Replace(" ","_")
    	ii = ii.Replace("(","")
    	ii = ii.Replace(")","")
    	ii = ii.Replace("-_","")
    	'DebugLog i
    	listb.Set(i,ii)
'    	DebugLog listb.Get(i)
    Next
    ' here we copy the old file to a new file with
    ' the new name and then delete the old file
    Local cnt:Int=0
    For Local i:String=Eachin lista
    	CopyFile(a+i,a+listb.Get(cnt))
		DeleteFile(a+i)
    	cnt+=1
    Next
End Function

Function Main()
    New MyGame()
End Function
