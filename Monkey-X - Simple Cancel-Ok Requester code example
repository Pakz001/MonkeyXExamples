Import mojo

Class requester
    Field x:Int = 640/2-320/2
    Field y:Int = 200
    Field width:Int=320
    Field height:Int=100
    Field visible:Bool = True 'requester visible
    Field button1:String="Cancel"
    Field button2:String="Ok"
    Field button1p:Bool = False 'button pressed
    Field button2p:Bool = False
    Field b1x 'button 1/2 x y (w)idth (h)eight
    Field b1y
    Field b1w
    Field b1h
    Field b2x
    Field b2y
    Field b2w
    Field b2h
    Method New()
        b1x = x+10
        b1y = y+height-25
        b1w = 100
        b1h = 20
        b2x = x+width-110
        b2y = y+height-25
        b2w = 100
        b2h = 20    
    End Method
    Method requester()
        If visible = True
            drawbox "Do you wish to continue?",0,x,y,width,height
            If rectsoverlap(MouseX(),MouseY(),1,1,b1x,b1y,b1w,b1h) = True And MouseDown(MOUSE_LEFT) = True Then
                button1p = True
                drawbox button1,1,b1x,b1y,b1w,b1h
                Else
                drawbox button1,0,b1x,b1y,b1w,b1h
            End If
            If rectsoverlap(MouseX(),MouseY(),1,1,b1x,b1y,b1w,b1h) = False
                button1p = False
            End If
            If rectsoverlap(MouseX(),MouseY(),1,1,b2x,b2y,b2w,b2h) = True And MouseDown(MOUSE_LEFT) = True Then
                button2p = True
                drawbox button2,1,b2x,b2y,b2w,b2h
                Else
                drawbox button2,0,b2x,b2y,b2w,b2h
            End If
            If rectsoverlap(MouseX(),MouseY(),1,1,b2x,b2y,b2w,b2h) = False
                button2p = False
            End If
            If MouseDown(MOUSE_LEFT) = False And button1p = True Then
                visible=False
                button1p = False
            End If
            If MouseDown(MOUSE_LEFT) = False And button2p =True Then
                visible = False
                button2p = False
            End If
        End If
    End Method
    Method drawbox(text:String,_state,_x,_y,_width,_height)
        Select _state
        Case 0'not pressed
            SetColor 100,100,100
            DrawRect _x,_y,_width,_height
            SetColor 200,200,200
            DrawLine _x,_y,_x+_width,_y
            DrawLine _x,_y,_x,_y+_height
            SetColor 50,50,50
            DrawLine _x,_y+_height,_x+_width,_y+_height
            DrawLine _x+_width,_y,_x+_width,_y+_height
            If text <> ""
                SetColor 255,255,255
                DrawText text,_x+_width/2,_y+_height/2,0.5,0.5
            End If
        Case 1'pressed
            SetColor 100,100,100
            DrawRect _x,_y,_width,_height
            SetColor 50,50,50
            DrawLine _x,_y,_x+_width,_y
            DrawLine _x,_y,_x,_y+_height
            SetColor 100,100,100
            DrawLine _x,_y+_height,_x+_width,_y+_height
            DrawLine _x+_width,_y,_x+_width,_y+_height
            If text <> ""
                SetColor 255,255,255
                DrawText text,_x+_width/2,_y+_height/2,0.5,0.5
            End If
        End Select
    End Method
End Class

Global r:requester = New requester

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
    End Method
    Method OnUpdate()        
        If r.visible = False And Rnd(200)<5 Then r.visible=True
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        r.requester
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
