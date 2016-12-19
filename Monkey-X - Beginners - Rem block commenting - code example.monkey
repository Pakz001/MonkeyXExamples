#Rem
Anything typed here
will not cause a error.
#End
Import mojo

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(1)
        
        ' You can disable a part of the code between #rem and #end
		#Rem
		DebugLog "This will not"
		DebugLog "be executed."
		#End
    End Method
    Method OnUpdate()
    End Method
    Method OnRender()
    End Method
End Class

Function Main()
    New MyGame()
End Function
