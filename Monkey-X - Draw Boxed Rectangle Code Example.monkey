Import mojo

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        Cls(0,0,0)
        SetColor(255,255,255)
        drawboxedrect(100,100,100,100)
        For Local i=0 Until 10
            drawboxedrect Rnd(100)+200,Rnd(200)+100,Rnd(50)+50,Rnd(50)+50
        Next
    End
End

Function drawboxedrect:Void(x:Int,y:Int,w:Int,h:Int)
    DrawLine x,y,x+w,y
    DrawLine x,y,x,y+h
    DrawLine x,y+h,x+w,y+h
    DrawLine x+w,y,x+w,y+h
End Function

Function Main()
    New MyGame()
End
