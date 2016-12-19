Import mojo

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(1)
		Local a:String="test"
		Local b:String="this is a test."
		If b.Contains(a) Then DebugLog "found "+a+" in string."
		If Not b.Contains("battle") Then DebugLog "did not find battle in string" 
    End Method
    Method OnUpdate()
    End Method
    Method OnRender()
    End Method
End Class

Function Main()
    New MyGame()
End Function
