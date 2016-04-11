Import mojo

Class player
    Field x:Float,y:Float
End Class

Class bullet
    Field x:Float,y:Float
    Field active:Bool
End Class

Class enemy
    Field x:Float,y:Float
End Class

Global p:player = New player
Global e:enemy = New enemy
Global b:bullet = New bullet

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        p.x = 320
        p.y = 240
        e.x = 460
        e.y = 240
    End Method
    Method OnUpdate()
        ' if the user presses space
        If KeyHit(KEY_SPACE)
            ' if the bullet is not active
            If b.active = False
                ' put the bullet at the player position
                b.x = p.x+32
                b.y = p.y+12
                ' activate the bullet
                b.active = True
            End If
        End If
        ' if the bullet is active
        If b.active = True 
            ' increase the position by 1 to the right
            b.x += 1
            ' if the bullet hits the enemy then set the 
            ' bullet active to false
            If rectsoverlap(b.x,b.y,6,6,e.x,e.y,32,32)
                b.active = False
            End If
            ' if the bullet gets out of the screen area
            ' then set it to not active
            If rectsoverlap(b.x,b.y,0,0,0,0,640,480) = False Then b.active = False
        End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
           ' draw player
           DrawRect p.x,p.y,32,32
           ' draw enemy
           DrawRect e.x,e.y,32,32
           ' draw bullet if it is active
           If b.active = True Then DrawRect b.x,b.y,6,6
           DrawText "Press space to fire bullet.",0,0
    End Method
End Class

Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
    Return True
End

Function Main()
    New MyGame()
End Function
