Import mojo

Global x:Int = 320
Global y:Int = 100
Global inc:Int = 1

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
    End
    Method OnUpdate()
        y+=inc
        If y>200 Then inc=-1
        If y<100 Then inc=1
    End
    Method OnRender()
        Cls(0,0,0)
        SetColor(255,0,0)
        DrawRect(x,y,16,16)
        
    End
End

Function Main()
    New MyGame()
End
