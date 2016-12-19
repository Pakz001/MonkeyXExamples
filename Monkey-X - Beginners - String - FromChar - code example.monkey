Import mojo

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(1)
        ' character code 97 is a.
        ' character code to character
		DebugLog String.FromChar(97)
    End Method
    Method OnUpdate()
    End Method
    Method OnRender()
    End Method
End Class

Function Main()
    New MyGame()
End Function
