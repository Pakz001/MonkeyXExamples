Import mojo

Class tab
    Field x:Int,y:Int
    Field buttontext:String[10]
    Field numbuttons:Int
    Field activetab:Int=0
    Method update()
        If MouseDown(MOUSE_LEFT)
            Local x1:Int=0
            For Local i=0 Until numbuttons
                Local tw:Int = TextWidth(buttontext[i])+16
                If rectsoverlap(MouseX(),MouseY(),1,1,x+x1,y,tw,16)
                    activetab = i
                    Exit
                End If
                x1+=tw
            Next    
        End If
    End Method
    Method draw()
        Local x1:Int=0
        For Local i=0 Until numbuttons
            Local tw:Int = TextWidth(buttontext[i])+16
            Local at:Bool=False
            Local mo:Bool=False
            If activetab=i Then at=True Else at=False
            mo = rectsoverlap(MouseX(),MouseY(),1,1,x+x1,y,tw,16)
            drawbutton(x+x1,y,tw,16,at,mo)
            SetColor 255,255,255
            DrawText buttontext[i],x+x1+(tw/2),y+8,0.5,0.5
            x1+=tw
        Next
    End Method
    Method drawbutton(x:Int,y:Int,w:Int,h:Int,selected:Bool,mouseover:Bool)
        If selected = False
            If mouseover=False Then 
                SetColor 150,150,150
            Else
                SetColor 180,180,180
            End If
            DrawRect x,y,w,h
            SetColor 200,200,200
            DrawLine x,y,x+w,y
            DrawLine x,y,x,y+h
            SetColor 100,100,100
            DrawLine x,y+h,x+w,y+h
            DrawLine x+w,y,x+w,y+h
        End If
        If selected = True
            If mouseover=False Then            
                SetColor 100,100,100
            Else
                SetColor 130,130,130
            End If
            DrawRect x,y,w,h
            SetColor 50,50,50
            DrawLine x,y,x+w,y
            DrawLine x,y,x,y+h
            SetColor 70,70,70
            DrawLine x,y+h,x+w,y+h
            DrawLine x+w,y,x+w,y+h        
        End If
    End Method
    Method rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
        If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
        If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
        Return True
    End Method    
End Class

Global t:tab = New tab

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        t.x = 50
        t.y = 32
        t.buttontext[0] = "City 1"
        t.buttontext[1] = "City 2"
        t.buttontext[2] = "City 3"
        t.buttontext[3] = "City 4"
        t.buttontext[4] = "City 5"
        t.buttontext[5] = "City 6"
        t.numbuttons = 6
    End Method
    Method OnUpdate()        
        t.update
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawText "Simple Tabber, press mouse on buttons to switch screens",0,0
        DrawText "Tab Selected : "+t.activetab,t.x+100,t.y+100
        t.draw
        
    End Method
End Class


Function Main()
    New MyGame()
End Function
