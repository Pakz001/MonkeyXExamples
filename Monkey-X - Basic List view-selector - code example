Import mojo

Global selecteditem:String=""

Class listview
    Field x:Int,y:Int
    Field w:Int=200
    Field h:Int=300
    Field item:String[100]
    Field pos:Int=0
    Field selected:Int=0
    Field itemcount:Int=100    
    Field vscrollerpos:Int=0
    Field keydelay:Int=0
    Field active:Bool=True
    Method setitemname(item:String,pos:Int)
        For Local i=0 Until itemcount
            If i = pos
                Self.item[i] = item
            End If
        Next
    End Method
    Method update()
        If active=False Then Return
        'keys
        If Millisecs()>keydelay
            If KeyDown(KEY_DOWN)
                selected+=1
                If selected > itemcount-1 Then selected = itemcount-1
                If selected > pos + (h-64)/15
                    pos+=1
                    If pos>itemcount-((h-64)/15) Then pos = itemcount-((h-64)/15)
                End If
                keydelay = Millisecs() + 60
            End If
            If KeyDown(KEY_UP)
                selected-=1
                If selected < 0 Then selected = 0
                If selected < pos 
                    pos-=1
                    If pos<0 Then pos=0
                End If
                keydelay = Millisecs() + 60
            End If    
        End If
        ' mouse on items
        Local i:Int=0
        Local exitloop:Bool=False
        While exitloop=False
            If MouseHit(MOUSE_LEFT)
            If rectsoverlap(MouseX(),MouseY(),1,1,x+10,y+20+i*15,w-32-20,15)
                selected = i+pos
                If selected > itemcount-1 Then selected=itemcount-1
            End If
            End If
            i+=1
            If i+pos>itemcount Then exitloop = True
            If i*15 > h-64 Then exitloop = True
        Wend
        'update vscroller
        vscrollerpos = pos*((h-96)/itemcount)
        If MouseDown(MOUSE_LEFT)
        If rectsoverlap(MouseX(),MouseY(),1,1,x+w-32,y+31,32-10,h-96)
            pos = (MouseY()-y-32)/((h-96)/itemcount)
            If pos>itemcount-((h-64)/15) Then pos = itemcount-((h-64)/15)
            If pos<0 Then pos = 0        
        End If
        End If
        '
        'update v scroll buttons
        If MouseDown(MOUSE_LEFT)
            If rectsoverlap(MouseX(),MouseY(),1,1,x+w-32,y+10,32-10,20)
                pos-=1
                If pos<0 Then pos=0
            End If
            If rectsoverlap(MouseX(),MouseY(),1,1,x+w-32,y+h-64,32-10,20)
                pos+=1
                If pos>itemcount-((h-64)/15) Then pos = itemcount-((h-64)/15)
            End If
        End If
        'Select using enter key
        If KeyHit(KEY_ENTER)        
            selecteditem=item[selected]
            active = False
        End If
        'Cancel select using esc
        If KeyHit(KEY_ESCAPE)
            selecteditem="Nothing"
            active=False            
        End If
        '
        ' Update ok cancel buttons
        If MouseHit(MOUSE_LEFT)
            'ok
            If rectsoverlap(MouseX(),MouseY(),1,1,x+10,y+h-32,w/2.2,32-8)
                selecteditem=item[selected]
                active = False
            End If
            'cancel
            If rectsoverlap(MouseX(),MouseY(),1,1,x+w/2,y+h-32,w/2.2,32-8)
                ' code here        
                selecteditem="Nothing"
                active=False
            End If
        End If
    End Method
    Method draw()
        If active=False Then Return
        SetColor 200,200,200
        DrawRect x,y,w,h
        SetColor 0,0,0
        DrawRect x+10,y+10,w-20,h-20
        SetColor 255,255,255
        Local i:Int=0
        Local exitloop:Bool=False
        While exitloop=False
            If selected = i+pos Then 
                drawboxedrect x+10,y+20+i*15-1,w-32-20,15
            End If
            DrawText item[i+pos],x+20,y+20+i*15            
            i+=1
            If i+pos>itemcount-1 Then exitloop = True
            If i*15 > h-64 Then exitloop = True
        Wend
        drawbutton(x+10,y+h-32,w/2.2,32-8,"Ok")
        drawbutton(x+w/2,y+h-32,w/2.2,32-8,"Cancel")
        drawbutton(x+w-32,y+10,32-10,20,"<")
        drawbutton(x+w-32,y+h-64,32-10,20,">")
        drawvscroller(x+w-32,y+31,32-10,h-96)
    End Method
    Method drawvscroller(x:Int,y:Int,w:Int,h:Int)
        SetColor 255,255,255
        drawboxedrect(x,y,w,h)
        DrawRect x+1,y+vscrollerpos,w-2,38
    End Method
    Method drawbutton(x:Int,y:Int,w:Int,h:Int,text:String)
        SetColor 200,200,200
        DrawRect x,y,w,h
        SetColor 0,0,0
        DrawRect x+2,y+2,w-4,h-4
        SetColor 255,255,255
        DrawText text,x+w/2,y+h/2,0.5,0.5
    End Method
    Method drawboxedrect(x:Int,y:Int,w:Int,h:Int)
        DrawLine x,y,x+w,y
        DrawLine x,y,x,y+h
        DrawLine x,y+h,x+w,y+h
        DrawLine x+w,y,x+w,y+h
    End Method
    Method rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
        If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
        If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
        Return True
    End    Method
End Class

Global l:listview = New listview

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        l.itemcount=100
           For Local i=0 Until l.itemcount
               l.setitemname(String(i),i)
           Next
       l.x=100
       l.y=50
    End Method
    Method OnUpdate()        
        l.update
        If l.active = False And Rnd(100)<2 
            l.active = True
            l.x = Rnd(50,320)
            l.y = Rnd(50,100)
        End If
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        l.draw
        DrawText "Use Mouse and enter and curs up/down for listview",0,0
        DrawText "Selected item :"+selecteditem,0,15
    End Method
End Class


Function Main()
    New MyGame()
End Function
