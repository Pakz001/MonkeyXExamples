Import mojo

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
    End
    Method OnUpdate()
    End
    Method OnRender()
        Cls(0,0,0)
        SetColor(255,0,0)
        For Local y:Int = 3 To 10
        For Local x:Int = 3 To 10
            If Int(Rnd(2)) = 1 Then DrawRect(x*16,y*16,16,16)
        End
        End
    End
End

Function Main()
    New MyGame()
End
