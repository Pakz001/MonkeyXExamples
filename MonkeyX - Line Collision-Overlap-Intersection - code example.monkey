' Ported from 
' http://iadbungler.free.fr/bcoder/cgi-bin/code/Wc5f42637ead45.htm
' By ashcroftman
Import mojo

Global x1:Int=320-25
Global y1:Int=240-25
Global x2:Int=320+25
Global y2:Int=240+25
Global x3:Int,y3:Int
Global x4:Int,y4:Int


Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()
        x3 = MouseX()
        y3 = MouseY()
        x4=x3+25
        y4=y3-25
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawLine x1,y1,x2,y2
        DrawLine x3,y3,x4,y4
        Local col:String="No Collision"
        If lineintersect(x1,y1,x2,y2,x3,y3,x4,y4)
            col = "Collision"
        End If
        DrawText "Line Collision example. Move the mouse on the line.",10,0
        DrawText col,10,30
    End Method
End Class

Function lineintersect:Bool(    x1:Float,y1:Float,x2:Float,y2:Float,
                            u1:Float,v1:Float,u2:Float,v2:Float)
     Local b1:Float = (y2 - y1) / (x2 - x1)
     Local b2:Float = (v2 - v1) / (u2 - u1)
     Local a1:Float = y1 - b1 *x1
     Local a2:Float = v1 - b2 *u1
     Local xi:Float = - (a1-a2)/(b1-b2)
     Local yi:Float = a1+b1*xi
     If     (x1 - xi)*(xi-x2)> -1 And (u1-xi)*(xi - u2)> 0 And 
            (y1-yi)*(yi-y2)>-1 And (v1-yi)*(yi-v2)>-1 Return True
End Function

Function Main()
    New MyGame
End Function

        
