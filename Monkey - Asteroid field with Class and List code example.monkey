Import mojo

Class asteroid
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

Global mylist:List<asteroid> = New List<asteroid>


Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
        For Local i:Int = 0 Until 10
            mylist.AddLast(New asteroid)
        End

    End
    Method OnUpdate()
        ' if outside the window then go back into the window from the other side
        For Local i:asteroid = Eachin mylist
            i.x+=i.incx
            i.y+=i.incy
            If i.x<0 Then i.x = 640
            If i.x>640 Then i.x = 0
            If i.y<0 Then i.y = 480
            If i.y>480 Then i.y = 0
        End
        For Local i:asteroid = Eachin mylist
        For Local ii:asteroid = Eachin mylist
            If i<>ii
            If rectsoverlap(i.x,i.y,10,10,ii.x,ii.y,10,10) = 1
                mylist.Remove ii
            End
            end
        End
        End
    End
    Method OnRender()
        Cls(0,0,0)
        SetColor(255,255,255)
        For Local i:asteroid = Eachin mylist
            DrawRect i.x,i.y,10,10
        End
    End
End

Function Main()
    New MyGame()
End

Function rectsoverlap:Int(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    If x1 > (x2 + w2) Or (x1 + w1) < x2 Then Return False
    If y1 > (y2 + h2) Or (y1 + h1) < y2 Then Return False
    Return True
End
