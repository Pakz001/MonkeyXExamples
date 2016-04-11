Import mojo

Class rpgselector
    Field x:Int,y:Int
    Field w:Int=180,h:Int=70
    Field title:String
    Field opt1:String,opt2:String,opt3:String
    Field cs:Int=0
    Method New(    title:String,opt1:String,opt2:String,
                opt3:String,x:Int,y:Int)
        Self.x = x
        Self.y = y
        Self.opt1 = opt1
        Self.opt2 = opt2
        Self.opt3 = opt3
        Self.title = title
    End Method
    Method update()
        If KeyHit(KEY_RIGHT)
            If cs = 0 Then cs = 1 ; Return
            If cs = 2 Then cs = 1 ; Return
        End If
        If KeyHit(KEY_DOWN)
            If cs = 0 Then cs = 2 ; Return
            If cs = 2 Then cs = 1 ; Return
            If cs = 1 Then cs = 2 ; Return
        End If
        If KeyHit(KEY_UP)
            If cs = 2 Then cs = 0 ; Return
            If cs = 1 Then cs = 0 ; Return
        End If
        If KeyHit(KEY_LEFT)
            If cs = 1 Then cs = 0 ; Return
        End If
    End Method
    Method draw()
        SetColor 100,100,100
        DrawRect x,y,w,h
        SetColor 255,255,255
        DrawText title,x+20,y-5
        DrawText opt1,x+20,y+20
        If cs = 0 Then DrawRect x+10,y+22,8,8
        DrawText opt2,x+90,y+20
        If cs = 1 Then DrawRect x+80,y+22,8,8        
        DrawText opt3,x+20,y+40
        If cs = 2 Then DrawRect x+10,y+42,8,8        
    End Method
End Class

Global myrpgsel:rpgselector

Class MyGame Extends App
    Method OnCreate()
        SetUpdateRate(60)
        myrpgsel = New rpgselector(    "Action",
                                    "Option 1",
                                    "Option 2",
                                    "Option 3",
                                    300,100)
    End Method
    Method OnUpdate()        
        myrpgsel.update
    End Method
    Method OnRender()
        Cls(0,0,0)
        SetColor 255,255,255
        DrawText     "Use the cursor keys to move through the"+
                    "selector...",2,2
        myrpgsel.draw
    End
End


Function Main()
    New MyGame()
End
