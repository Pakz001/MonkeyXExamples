Import mojo

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawText "SetScissor Example (x,y,w,h)",10,10
        ' SetScissor x,y,w,h
        SetScissor(50,50,640-100,480-100)
        ' Here we draw a image on the entire screen
        ' and that will only be drawn inside the 
        ' scissor area.
        SetColor 50,20,0
        Local cx:Float=320
       	Local cy:Float=240
        For Local angle=0 Until 360-10 Step 32
        	Local x1:Float=cx+Cos(angle)*640
        	Local y1:Float=cy+Sin(angle)*480
        	Local x2:Float=cx+Cos(angle+10)*640
        	Local y2:Float=cy+Sin(angle+10)*480
        	DrawPoly([cx,cy,x1,y1,x2,y2])
        Next
        
    End Method
End Class


Function Main()
    New MyGame()
End function
