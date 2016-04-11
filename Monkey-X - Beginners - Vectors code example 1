Import mojo

Global x1:Float,y1:Float,x2:Float,y2:Float
Global length:Float,angle:Float

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        x1=640/2
        y1=480/2
    End Method
    Method OnUpdate()
        x2 = MouseX()
        y2 = MouseY()
        length=vectordistance(x2-x1,y2-y1)
        angle=vectorangle(x2-x1,y2-y1)
        x2 = x1+vectorx(length,angle)
        y2 = y1+vectory(length,angle)
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawLine x1,y1,x2,y2
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
