Import mojo

Const screenwidth:Int=640
Const screenheight:Int=480

Class baddie
    Field x:Float
    Field y:Float
    Field w:Int=32
    Field h:Int=48
    Field state:String="movein"
    Field laststate:String
    Field frame:String
    Field lastframe:String
    Field delay:Int
    Field fight:Bool
    Field hitcount:Int=3
    Field delete:Bool=False
    Field hashit:Bool
    Method update()
        Select state            
            Case "fight"
                If delay<Millisecs() And distance(x+w/2,y+h/2,p.x+p.w/2,p.y+p.h/2) < 40 Then state="verticalalign"
                If frame="right" And x>p.x Then frame="left"            
                If frame="left" And x<p.x Then frame="right"
                If delay< Millisecs() And distance(x+w/2,y+h/2,p.x+p.w/2,p.y+p.h/2) > 80 Then state = "movein" ; fight=False
                If delay < Millisecs() And (frame="hitright" Or frame="hitleft")                
                    frame=lastframe
                    hashit=False
                End If
                If delay < Millisecs() And (frame="left" Or frame="right")
                    If Rnd(100)<2
                        lastframe=frame
                        delay = Millisecs()+400
                        If frame="left" Then 
                            frame="hitleft" 
                            hashit = True
                            If rectsoverlap(x-w,y,w*2,h,p.x,p.y,p.w,p.h) = True Then p.hitcount-=1
                        Else
                            frame="hitright"                            
                            hashit=True
                            If rectsoverlap(x,y,w*2,h,p.x,p.y,p.w,p.h) = True Then p.hitcount-=1
                        End If
                    End If
                End If
            Case "verticalalign"                
                keepaidistance()        
                If x<p.x And distance(x+w/2,y+h/2,p.x+p.w/2,p.y+p.h/2) < 40 Then x-=1
                If x+w>p.x And distance(x+w/2,y+h/2,p.x+p.w/2,p.y+p.h/2) < 40 Then x+=1
                If y<p.y Then y+=1
                If y>p.y Then y-=1
                If y=p.y Then state="fight"
            Case "evaluate"
                Local otherfighting:Bool=False
                For Local i:=Eachin b
                    If i.fight=True Then otherfighting=True
                Next
                If otherfighting = False
                    fight=True
                    state="verticalalign"
                    Else
                    state="movein"
                End If
            Case "movein"
                keepaidistance()
                If distance(x+w/2,y+w/2,p.x+p.w/2,p.y+p.h/2) > 60
                    If x>p.x Then x-=1 ; frame="left"
                    If x<p.x Then x+=1 ; frame="right"
                Else
                    state="evaluate"
                End If
                If x=p.x Then state="evaluate"
        End Select
        For Local i:=Eachin b
            If i.delete = True Then b.Remove i
        Next
    End Method
    Method keepaidistance()
        For Local i:=Eachin b
            If x<>i.x And y<>i.y
                If distance(x+16,y+16,i.x+16,i.y+16) < 64 Then
                    If x<=i.x Then x-=1 Else x+=1
                    If y<=i.y Then y-=1 Else y+=1
                End If
            End If
        Next        
    End Method
    Method New(_x:Float,_y:Float)
        x=_x
        y=_y
    End Method
    Method draw()
        SetColor 255,255,255
        Select frame
            Case "right"
                DrawRect x,y,w,h
            Case "left"
                DrawRect x,y,w,h
            Case "hitright"
                DrawRect x,y,w,h
                DrawRect x,y+10,w*2,10
            Case "hitleft"
                DrawRect x,y,w,h
                DrawRect x-w,y+10,w,10
        End Select        
        DrawText "HC:"+hitcount,x+w/2,y+h/2,0.5,0.5
    End Method    
End Class

Class game
    Method update()
    End Method
End Class

Class player
    Field x:Float=100
    Field y:Float=240
    Field w:Int=32
    Field h:Int=48
    Field frame:String="right"
    Field lastframe:String
    Field delay:Int
    Field hitcount:Int=3
    Field hashit:Bool=False
    Method update()
        If frame="left" Or frame="right"
            If KeyDown(KEY_DOWN)
                y+=3
                If y>400 Then y=400
            End If
            If KeyDown(KEY_UP)
                y-=3
                If y<200 Then y=200
            End If
            If KeyDown(KEY_RIGHT)    
                frame="right"
                x+=3
                If x+w>screenwidth Then x=screenwidth-w                
            End If
            If KeyDown(KEY_LEFT)
                frame="left"
                x-=3
                If x<0 Then x=0
            End If
        End If
        If KeyDown(KEY_SPACE)    
            If frame="right" Or frame="left"
                hashit=False
                delay = Millisecs()+200
                If frame="right" Then            
                    frame = "hitright"
                    lastframe="right"
                End If
                If frame="left" Then
                    frame = "hitleft"
                    lastframe="left"
                End If
            End If
        End If
        Select frame
            Case "hitright"
                If hashit = False
                    For Local i:=Eachin b
                        If rectsoverlap(x,y,w*2,h,i.x,i.y,i.w,i.h) = True
                            i.hitcount -=1
                            If i.hitcount = 0 Then i.delete = True
                        End If
                    Next
                    hashit=True
                End If
                If delay < Millisecs()
                    frame=lastframe
                End If
            Case "hitleft"
                If hashit = False
                    For Local i:=Eachin b
                        If rectsoverlap(x-w,y,w*2,h,i.x,i.y,i.w,i.h) = true
                            i.hitcount -=1
                            If i.hitcount = 0 Then i.delete = True
                        End If
                    Next
                    hashit=True
                End If
                If delay < Millisecs()
                    frame=lastframe
                End If
        End Select
    End Method
    Method draw()
        SetColor 255,255,255
        Select frame
            Case "right"
                DrawRect x,y,w,h
            Case "left"
                DrawRect x,y,w,h
            Case "hitright"
                DrawRect x,y,w,h
                DrawRect x,y+10,w*2,10
            Case "hitleft"
                DrawRect x,y,w,h
                DrawRect x-w,y+10,w,10
        End Select
        DrawText "HC:"+hitcount,x+w/2,y+h/2,0.5,0.5
    End Method
End Class

Global g:game = New game
Global p:player = New player
Global b:List<baddie> = New List<baddie>

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        b.AddLast(New baddie(screenwidth+32,200))
        b.AddLast(New baddie(screenwidth+32,350))
    End Method
    Method OnUpdate()
        If b.IsEmpty() = True Then
            b.AddLast(New baddie(screenwidth+32,200))
            b.AddLast(New baddie(screenwidth+32,350))
        End If
        For Local i:=Eachin b
            i.update
        Next
        p.update
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawText "Use cursor left/right to move, space to hit.",0,0
        For Local i:=Eachin b
            i.draw
        Next
        p.draw
    End Method
End Class

Function distance:Int(x1:Int,y1:Int,x2:Int,y2:Int)
    Return Abs(x2-x1) + Abs(y2-y1)
End Function

Function rectsoverlap:Bool(x1:Int, y1:Int, w1:Int, h1:Int, x2:Int, y2:Int, w2:Int, h2:Int)
    If x1 >= (x2 + w2) Or (x1 + w1) <= x2 Then Return False
    If y1 >= (y2 + h2) Or (y1 + h1) <= y2 Then Return False
    Return True
End


Function Main()
    New MyGame()
End Function
