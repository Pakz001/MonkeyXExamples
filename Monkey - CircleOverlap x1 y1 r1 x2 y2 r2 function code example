Import mojo

Class bubble
    Field x:Float
    Field y:Float
    Field incx:Float
    Field incy:Float
    Method New()
        x = Rnd(640)
        y = Rnd(480)
        incx = Rnd(-1,1)
        incy = Rnd(-1,1)
    End
End

Global blist:List<bubble> = New List<bubble>

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
        For Local i:Int = 0 Until 10
            blist.AddLast(New bubble)
        End
    End
    Method OnUpdate()
        For Local i:bubble = Eachin blist
            i.x+=i.incx
            i.y+=i.incy
            If i.x<0 Then i.x = 640
            If i.x>640 Then i.x = 0
            If i.y<0 Then i.y = 480
            If i.y>480 Then i.y = 0
        End
        For Local i:bubble = Eachin blist
        For Local ii:bubble = Eachin blist
            If i<>ii
            If circleoverlap(i.x,i.y,10,ii.x,ii.y,10) = True
                blist.Remove ii
            End
            End
        End
        End

    End
    Method OnRender()
        Cls(0,0,0)
        SetColor(255,255,255)
        For Local i:bubble = Eachin blist
            DrawCircle i.x,i.y,10
        End
    End
End

Function Main()
    New MyGame()
End

Function circleoverlap:Bool(x1:Int,y1:Int,r1:Int,x2:Int,y2:Int,r2:Int)
    Local dx:Int = x1-x2
    Local dy:Int = y1-y2
    Local r:Int = r1+r2
    If dx*dx+dy*dy <= r*r Then Return True Else Return False
End
