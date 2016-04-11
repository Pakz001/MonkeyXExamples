Import mojo

Global mysetting1:Bool=False

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
    End
    Method OnUpdate()
        If KeyHit(KEY_SPACE)
            If Int(Rnd(0,3)) = 1 Then 
                mysetting1 = True
            Else
                mysetting1 = False
            End If
        End If
    End
    Method OnRender()
        Cls 0,0,0 
        'set the color
        SetColor 255,255,255
        DrawText "Press space bar to create random value.",10,10
        If mysetting1 = True
            DrawText "Last random value was 1",100,50            
        End If
        If mysetting1 = False
            DrawText "Last random value was other then 1",100,50
        End If
    End
End

Function Main()
    New MyGame()
End
