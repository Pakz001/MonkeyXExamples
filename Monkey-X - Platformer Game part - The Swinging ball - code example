Import mojo

Class swing
    Field x:Int
    Field y:Int
    Field height:Int=64
    Field angle:Float=0
    Field inc:Float=0
    Field direction:Int=1
    Method New(_x,_y)
        x = _x
        y = _y
    End Method
    Method drawswing()
        For Local i=0 Until height Step 8
            Local s=8
            If i>height-16 
                s=32
            End If
            DrawOval x+Cos(angle)*i-s/2,y+Sin(angle)*i-s/2,s,s
        Next
    End Method
    Method updateswing()
        If direction = 1 Then inc+=0.1
        If direction = -1 Then inc-=0.1
        angle+=inc
        If angle > 90 And direction = 1 Then direction = -1
        If angle < 90 And direction = -1 Then direction = 1
    End Method
    Method rectswingcollision:Bool(x1:Int,y1:Int,w1:Int,h1:Int)
        For Local i=0 Until height Step 8
            Local s=8
            If i>height-16 
                s=32
            End If
            If rectsoverlap(x1,y1,w1,h1,x+Cos(angle)*i-s/2,y+Sin(angle)*i-s/2,s,s) = True Then Return True
        Next
        Return False        
    End Method
End Class

Global swings:List<swing> = New List<swing>
Global coll:Bool=False

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
        swings.AddLast(New swing(100,100))
        swings.AddLast(New swing(320,100))
    End Method
    Method OnUpdate()        
        coll = False
        For Local i:=Eachin swings
            i.updateswing
            If i.rectswingcollision(MouseX(),MouseY(),32,32) = True Then coll = True
        Next
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawText "Game part - The swing. - Move the mouse inside the swing to collide.",0,0
        If coll = True Then
            DrawText "Collision",0,16
        End If
        DrawRect MouseX(),MouseY(),32,32
        For Local i:=Eachin swings
            i.drawswing
        Next
    End Method
End Class

Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
    Return True
End Function

Function Main()
    New MyGame()
End Function
