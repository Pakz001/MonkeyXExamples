Import mojo

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(1)
		Local a:String="test."
		Local b:String="TEST."
		DebugLog a.ToUpper
		DebugLog b.ToLower
		DebugLog "This is A Test.".ToUpper
    End Method
    Method OnUpdate()
    End Method
    Method OnRender()
    End Method
End Class

Function Main()
    New MyGame()
End Function
