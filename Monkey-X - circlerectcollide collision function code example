Import mojo

Global circlex:Int=320
Global circley:Int=240
Global circleradius:Int=50

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawText "Move the rectangle in the circle to see collision.",0,0
        Local coll:Bool=circlerectcollide(circlex,circley,circleradius,MouseX(),MouseY(),50,50)
        If coll=True
            DrawText "Collision",2,16
        End If
        DrawRect MouseX(),MouseY(),50,50
        DrawCircle circlex,circley,circleradius
    End Method
End Class

Function circlerectcollide:Bool(cx:Int,cy:Int,cr:Int, rx:Int,ry:Int,rw:Int,rh:Int)
    Local closestx:Float = Clamp(cx, rx, rx+rw)
    Local closesty:Float = Clamp(cy, ry, ry+rh)
    Local distancex :Float = cx - closestx
    Local distancey:Float = cy - closesty
    Local distancesquared:Float = (distancex * distancex) + (distancey * distancey)
    Return distancesquared < (cr * cr)
End Function


Function Main()
    New MyGame()
End Function
