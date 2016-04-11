Import mojo

Global numdots:Int=100

Class dots
    Field x:Float,y:Float
    Field lastangle:Float
    Field color:Int
    Method New(x:Float,y:Float,lastangle:Float,color:Int)
        Self.x = x
        Self.y = y
        Self.lastangle = lastangle
        Self.color = color
    End Method
    Method update()
        Local length:Float,angle:Float,incx:Float,incy:Float
        Repeat
          incx = Rnd(-5,5)
          incy = Rnd(-5,5)
          length = vectordistance(incx,incy)
          angle = vectorangle(incx,incy)
        Until length >= 2 And length <= 5 And Abs(lastangle-angle)<=10
        lastangle=angle
        x+=incx
        If x<0 Then x=640
        If x>640 Then x=0
        y+=incy
        If y<0 Then y=480
        If y>480 Then y=0 
    End Method
    Method draw()
        SetColor color,color,color
        DrawOval x,y,6,6
    End Method
End Class

Global dot:List<dots> = New List<dots>

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        For Local i=0 Until numdots
            dot.AddLast(New dots(Rnd(0,640),Rnd(0,480),Rnd(0,360),Rnd(32,200)))
        Next
    End Method
    Method OnUpdate()
        For Local i:=Eachin dot
            i.update
        Next
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        For Local i:=Eachin dot
            i.draw
        Next
    End Method
End Class

' Thanks to Blitzcoder for the functions
';= Get horizontal size of vector using distance and angle
Function vectorx:Float(distance:Float,angle:Float)
    Return Sin(angle)*distance
End Function
';= Get vertical size of vector using distance and angle
Function vectory:Float(distance:Float,angle:Float)
    Return Sin(angle-90)*distance
End Function
';= Get True length of a vector
Function vectordistance:Float(x:Float,y:Float)
    Return Sqrt(x*x+y*y)
End Function
';= Get True angle of a vector
Function vectorangle:Float(x:Float,y:Float)
    Return -ATan2(x,y)+180
End Function


Function Main()
    New MyGame()
End Function
