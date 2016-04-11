Import mojo


Global layer1:Int[][] = [    [1,1,1,1,1,1,1,1,1,1],
                            [1,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,1,1,1,1],
                            [1,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,0,1],
                            [1,1,1,1,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,0,1],
                            [1,1,1,1,1,1,1,1,1,1] ]
Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
    End
    Method OnUpdate()
    End
    Method OnRender()
        Cls(0,0,0)
        SetColor(255,255,255)
        For Local y:Int = 0 Until 10
        For Local x:Int = 0 Until 10
            If layer1[y][x] = 1 Then DrawRect(x*32,y*32,32,32)
        End
        End
        DrawText("Tilemap Example",640-200,10)
    End
End

Function Main()
    New MyGame()
End
