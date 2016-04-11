Import mojo

Global px:Float = 320
Global py:Float = 240
Global playerjump:Bool = False
Global pincy:Float = 0

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
    End
    Method OnUpdate()
        ' If the player is on the ground and the space bar is pressed
        If playerjump = False And KeyDown(KEY_SPACE) = True
            pincy = -3
            playerjump = True
        End
        'If the player is in the jump
        If playerjump = True
            pincy += 0.1
            'if the player is going up
            If pincy <=0
                For Local i:Int = 0 Until Abs(pincy)
                    py -= 1
                End
            End
            ' if the player if going down
            If pincy > 0
                For Local i:Int = 0 Until pincy
                    py += 1
                    'if the player touches the ground
                    If py > 240 Then 
                        playerjump = False
                        py = 240
                        Exit
                    End
                End
            End
        End
    End
    Method OnRender()
        Cls(0,0,0)
        SetColor(255,255,255)
        DrawRect px,py,32,32
        DrawText "Press space bar to jump the rectangle player",10,10
    End
End

Function Main()
    New MyGame()
End
