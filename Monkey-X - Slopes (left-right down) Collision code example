Import mojo

Global block1x:Int = 100
Global block1y:Int = 100
Global blockwidth:Int = 32
Global blockheight:Int = 32
Global block2x:Int = 320+100
Global block2y:Int = 100

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawText "Move mouse inside sloped images to see collision.",10,10
        DrawText "Slopeleft",block1x,block1y-25
        drawslopeleft(block1x,block1y)
        DrawText "Sloperight",block2x,block2y-25
        drawsloperight(block2x,block2y)
        '
        DrawRect MouseX(),MouseY(),32,32
           '
           If slopeleftcollision(MouseX(),MouseY(),block1x,block1y) = True
               DrawText "Left slope collision",10,50           
           End If
           If sloperightcollision(MouseX(),MouseY(),block2x,block2y) = True
               DrawText "Right slope collision",10,50
           End If
    End Method
End Class

Function sloperightcollision:Bool(x1:Int,y1:Int,x2:Int,y2:Int)
    Local y3=y2
    For Local x3=x2 Until x2+blockwidth
        If rectsoverlap(x1,y1,blockwidth,blockheight,x3,y3,1,1) = True Then Return True
        y3+=1
    Next
    Return False
End Function

Function slopeleftcollision:Bool(x1:Int,y1:Int,x2:Int,y2:Int)
    Local y3=blockheight+y2
    For Local x3=x2 Until x2+blockwidth
        If rectsoverlap(x1,y1,blockwidth,blockheight,x3,y3,1,1) = True Then Return True
        y3-=1
    Next
    Return False
End Function

Function drawslopeleft:Void(x:Int,y:Int)
    DrawPoly([Float(x),y+blockheight,x+blockwidth,y+blockheight,x+blockwidth,y])
End Function

Function drawsloperight:Void(x:Int,y:Int)
    DrawPoly([Float(x),y,x,y+blockheight,x+blockwidth,y+blockheight,x,y])
End Function

Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
    Return True
End Function


Function Main()
    New MyGame()
End Function
