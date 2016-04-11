Import mojo

Global px:Float = 320
Global py:Float = 240
Global playerjump:Bool = False
Global pincy:Float = 0
Global doublejump:Bool = False

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
        'Double jump
        If playerjump = True And doublejump = False
               If KeyDown(KEY_SPACE)
                   If pincy < 0 And pincy >-2.0
                       pincy = -3
                       doublejump = True
                   End If
            End If
        End If
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
                        doublejump = False
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
        DrawText "Press space bar to jump. Press space again in jump to double jump.",10,10
        If doublejump = True
            DrawText "Doublejump",px+16,py-10,0.5
        End If
    End
End

Function Main()
    New MyGame()
End
