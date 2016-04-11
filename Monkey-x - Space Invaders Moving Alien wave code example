Import mojo

Global wavedirection:String = "Right"

Class alien
    Field x:Int
    Field y:Int
    Field alive:Bool
    Field hitcount:Int
    Method New(x1,y1)
        x = x1
        y = y1
        alive = True
        hitcount = 3
    End Method
End Class

Global alienlist:List<alien> = New List<alien>

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
        For Local x=0 Until 10
        For Local y=0 Until 5
            alienlist.AddLast(New alien(x*48,y*48))
        End For
        End For
    End Method
    Method OnUpdate()
        For Local i:alien = Eachin alienlist
            If i.x+48 > DeviceWidth Then wavedirection = "Left" ; Exit
            If i.x < 0 Then wavedirection = "Right" ; Exit
        End For
        For Local i:alien = Eachin alienlist
            If wavedirection = "Left"
                i.x -= 1
            End If
            If wavedirection = "Right"
                i.x += 1
            End If
        End For
    End Method
    Method OnRender()
        Cls(0,0,0)
        SetColor(255,255,255)
        For Local i:alien = Eachin alienlist
            DrawRect i.x+8,i.y+8,32,32
        End For
    End
End

Function Main()
    New MyGame()
End
