Import mojo

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(1)
		Local a:String="This is certainly not a test."
		DebugLog "Original string before replace 'certainly' with 'maybe' :"+a
		DebugLog "New string : "+a.Replace("certainly","maybe") 
    End Method
    Method OnUpdate()
    End Method
    Method OnRender()
    End Method
End Class

Function Main()
    New MyGame()
End Function
