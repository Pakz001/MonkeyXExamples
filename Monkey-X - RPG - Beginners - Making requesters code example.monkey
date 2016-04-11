Import mojo

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()        
    End Method
    Method OnRender()
        Cls(0,0,0)
        SetColor 100,100,100
        DrawRect 100,100,100,60
        SetColor(255,255,255)
        drawboxedrect(100,100,100,60)
        SetColor 255,255,255
        DrawText "Player",120,95
        DrawText "Bash",110,110
        DrawText "PSI",110,130
        DrawText "Goods",150,110
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
