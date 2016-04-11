Import mojo

Const screenwidth:Int=640
Const screenheight:Int=480

Class effect
    Field x:Float
    Field y:Float
    Field incx:Float
    Field incy:Float
    Field w:Int
    Field h:Int
    Field col:Int
    Field angle:Int=Rnd(-180,180)
    Field angleturn:Int
    Field delete:Bool = False
    Method New(_x:Float,_y:Float,_w:Int,_h:Int)
        x = _x
        y = _y
        w = _w
        h = _h
        col = Rnd(50,150)
        incx = Rnd(-2,2)
        incy = Rnd(-10,-5)
        angleturn = Rnd(-5,5)
    End Method
    Method update()
        angle+=angleturn
        If angle>180 Then angle=-180
        If angle<-180 Then angle=180
        x+=incx
        y+=incy
        incy+=.1
        If y>screenheight Then delete = True
        For Local i:=Eachin e
            If i.delete = True Then e.Remove i
        Next
    End Method
    Method draw()
        PushMatrix()
        Translate x,y
        Rotate(-angle)
        Translate -x,-y
        SetColor 10+col,0,0
        SetAlpha 0.5 'part transparent setting
        DrawRect x,y,w,h
        PopMatrix()
        SetAlpha 1 'restore transparent setting to none transparent
    End Method
End Class

Global e:List<effect> = New List<effect>

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()        
        If Rnd(10) < 2 Then e.AddLast(New effect(320,240,Rnd(5,25),Rnd(5,25)))
        For Local i:=Eachin e
            i.update
        Next
    End Method
    Method OnRender()
        Cls 0,0,0 
        For Local i:=Eachin e
            i.draw
        Next
        SetColor 255,255,255
    End Method
End Class


Function Main()
    New MyGame()
End Function
