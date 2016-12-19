Import mojo

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(1)
		Local a:String="myfile.monkey"
		Local b:String="c:\myinstallation\"
		If a.EndsWith(".monkey") Then DebugLog "variable a ends with .monkey"
		If b.EndsWith("\") Then DebugLog "variable b ends with \"
		If b.StartsWith("c:") Then DebugLog "variable b starts with c:"	
    End Method
    Method OnUpdate()
    End Method
    Method OnRender()
    End Method
End Class

Function Main()
    New MyGame()
End Function
