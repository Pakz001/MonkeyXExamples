Import mojo

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        Local pol:Float[6]
        pol[0] = 200
        pol[1] = 200
        pol[2] = 250
        pol[3] = 200
        pol[4] = 200
        pol[5] = 250
        Cls(0,0,0)
        SetColor(255,255,255)
        DrawPoly([100.0,100.0,150.0,150.0,100.0,150.0])
        DrawPoly(pol)
    End
End

Function Main()
    New MyGame()
End
