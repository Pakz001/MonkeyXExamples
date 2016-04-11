Import mojo

Global angle:Int=0
Global x1:Float=100
Global y1:Float=100

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()        
        angle = getangle(MouseX(),MouseY(),x1,y1)
        x1+=Cos(angle)*1
        y1+=Sin(angle)*1
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawOval x1,y1,10,10
    End Method
End Class

Function getangle:Int(x1:Int,y1:Int,x2:Int,y2:Int)
    Return ATan2(y1-y2, x1-x2)
End Function

Function Main()
    New MyGame()
End Function
