' Ported from 
' http://iadbungler.free.fr/bcoder/cgi-bin/code/Wc5f42637ead45.htm
' By ashcroftman
' BROKEN!

'ported from 
'https://stackoverflow.com/questions/563198/how-do-you-detect-where-two-line-segments-intersect

Import mojo

Global x1:Int=150
Global y1:Int=100
Global x2:Int=150
Global y2:Int=200
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

'// Returns 1 if the lines intersect, otherwise 0. In addition, if the lines 
'// intersect the intersection point may be stored in the floats i_x and i_y.
Function lineintersect:Bool(p0_x:Float, p0_y:Float, p1_x:Float, p1_y:Float, p2_x:Float,p2_y:Float, p3_x:Float, p3_y:Float)
	
    Local s1_x:Float, s1_y:Float, s2_x:Float, s2_y:Float
    s1_x = p1_x - p0_x     
    s1_y = p1_y - p0_y
    s2_x = p3_x - p2_x
    s2_y = p3_y - p2_y

    Local s:Float, t:Float
    s = (-s1_y * (p0_x - p2_x) + s1_x * (p0_y - p2_y)) / (-s2_x * s1_y + s1_x * s2_y)
    t = ( s2_x * (p0_y - p2_y) - s2_y * (p0_x - p2_x)) / (-s2_x * s1_y + s1_x * s2_y)

    If (s >= 0 And s <= 1 And t >= 0 And t <= 1) Then Return True
    

    Return False '// No collision
End Function
' Function lineintersect:Bool(    x1:Float,y1:Float,x2:Float,y2:Float,
'                            u1:Float,v1:Float,u2:Float,v2:Float)
'     Local b1:Float = (y2 - y1) / (x2 - x1)
'     Local b2:Float = (v2 - v1) / (u2 - u1)
'     Local a1:Float = y1 - b1 *x1
'     Local a2:Float = v1 - b2 *u1
 '    Local xi:Float = - (a1-a2)/(b1-b2)
'     Local yi:Float = a1+b1*xi
'     If     (x1 - xi)*(xi-x2)> -1 And (u1-xi)*(xi - u2)> 0 And 
'            (y1-yi)*(yi-y2)>-1 And (v1-yi)*(yi-v2)>-1 Return Tru'e
'End Function

Function Main()
    New MyGame
End Function
