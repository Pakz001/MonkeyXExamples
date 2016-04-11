Import mojo

Class spike
    Field x:Int
    Field y:Int
    Field inc:Float
    Field offset:Float
    Field height:Int=64
    Field width:Int=8
    Field state:String="out"
    Field laststate:String=""
    Field starttime:Int
    Field time:Int
    Method New(_x,_y,_starttime)
        x = _x
        y = _y
        state="start"
        starttime=Millisecs()+_starttime
    End Method
    Method draw()
        DrawPoly([Float(x+width/2),y-offset, x+width,y+height-offset, x,y+height-offset])
    End Method
    Method collide:Bool(x1,y1,w1,h1)
        If rectsoverlap(x1,y1,w1,h1,x,y-offset,width,height) = True Then Return True
        Return False
    End Method
    Method update()
        Select state
            Case "start"
                If starttime < Millisecs() 
                    laststate="start"
                    state="out"
                End If
            Case "out"
                For Local i=0 Until 3
                    offset+=1
                    If offset >= height Then 
                        state="wait"
                        laststate="out"
                        time=Millisecs()
                        Exit
                    End If
                Next
            Case "wait"
                If time+2000 < Millisecs() 
                    Select laststate
                        Case "out"
                            state="in"
                            laststate = "wait"
                        Case "in"
                            state="out"
                            laststate="wait"
                    End Select
                End If
            Case "in"
                For Local i=0 Until 3
                    offset-=1
                    If offset <= 0 Then 
                        state="wait"
                        laststate="in"
                        time=Millisecs()
                        Exit
                    End If
                Next                
        End Select
    End Method
End Class

Global spikes:List<spike> = New List<spike>
Global coll:Bool=False

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        For Local x=2 Until 18
            If Rnd(1,10) < 3 Then spikes.AddLast(New spike(x*32,10*32,Rnd(500,2000)))
        Next
    End Method
    Method OnUpdate()
        coll = False
        For Local i:=Eachin spikes
            i.update
            If i.collide(MouseX(),MouseY(),32,32) = True Then coll = True
        Next        
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        DrawText "Move the mouse in the spikes for collision.",0,0
        If coll=True
            DrawText "Collide",0,16
        End If
        For Local i:=Eachin spikes
            i.draw
        Next
        DrawRect 0,10*32,20*32,5*32
        SetColor 255,0,0
        DrawRect MouseX(),MouseY(),32,32
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
