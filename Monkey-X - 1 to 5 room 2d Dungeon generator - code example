Import mojo

Const screenwidth:Int=640
Const screenheight:Int=480
Global tilewidth:Int=16
Global tileheight:Int=16
Global mapwidth:Int=40
Global mapheight:Int=30
Const isnothing:Int=0
Const iswall:Int=1
Const isfloor:Int=2
Const isdoor:Int=3
Const minroomw:Int=5
Const minroomh:Int=5
Const maxroomw:Int=10
Const maxroomh:Int=10

Global map:Int[mapwidth][]

Global rcount:Int=0

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        Seed = Millisecs()
        For Local i = 0 Until mapwidth
            map[i] = New Int[mapheight]
        Next
        createmap(Rnd(1,6))
    End Method
    Method OnUpdate()        
        rcount+=1
        Local exitloop=False
           If KeyHit(KEY_SPACE) Or rcount > 140 Then 
               createmap(Rnd(1,6))
               rcount=0
           End If
    End Method
    Method OnRender()
        Cls 0,0,0
        SetColor 255,255,255
        DrawText "Generates dungeons with 1 to 5 rooms",0,0
        drawmap
        
    End Method
End Class


Function createmap:Bool(numrooms:Int)
    Local succes:Bool=False
    Seed = Millisecs()
    If numrooms<1 Then numrooms=1
    If numrooms>5 Then numrooms=4
    While succes = False
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth
            map[x][y] = isnothing
        Next
        Next
        Local startx:Int=mapwidth/2-5
        Local starty:Int=mapheight/2-5
        Local roomw:Int=Rnd(minroomw,maxroomw)
        Local roomh:Int=Rnd(minroomh,maxroomh)
        makeroom(startx,starty,roomw,roomh)
        If numrooms = 1 Then Return True
        Local roomcount:Int=1
        Local l1:Bool=False
        Local r1:Bool=False
        Local u1:Bool=False
        Local d1:Bool=False
        While roomcount < numrooms
            If Rnd(10)<2 And roomcount<numrooms And r1=False Then makedoor("right",startx,starty,roomw,roomh) ; roomcount+=1 ; r1=True
            If Rnd(10)<2 And roomcount<numrooms And l1=False Then makedoor("left",startx,starty,roomw,roomh) ; roomcount+=1;l1=True
            If Rnd(10)<2 And roomcount<numrooms And u1=False Then makedoor("up",startx,starty,roomw,roomh) ; roomcount+=1 ; u1=True
            If Rnd(10)<2 And roomcount<numrooms And d1=False Then makedoor("down",startx,starty,roomw,roomh) ; roomcount+=1;d1=True
        Wend

        Local doorfound=False
        Local x1:Int
        Local y1:Int
        roomcount=1
        Local cnt:Int=0
        While roomcount<numrooms        
            x1=Rnd(mapwidth)
            y1=Rnd(mapheight)
            If map[x1][y1] = isdoor Then 
                If makeroomondoor(x1,y1) = True Then roomcount+=1
            End If
            cnt+=1
            If cnt>1000 Then Exit
        Wend
    If cnt>1000 Then succes=False Else succes = true
Wend
End Function


Function makeroomondoor:Bool(x:Int,y:Int)
    Local makeroom:Bool=False
    Local cnt:Int=0
    Local x1:Int
    Local y1:Int
    Local w1:Int
    Local h1:Int
    Local facing:String
    If map[x-1][y]=isnothing Then facing = "left"
    If map[x+1][y]=isnothing Then facing = "right"
    If map[x][y-1]=isnothing Then facing = "up"
    If map[x][y+1]=isnothing Then facing = "down"
    While cnt<100
        w1 = Rnd(minroomw,maxroomw)
        h1 = Rnd(minroomh,maxroomh)
        x1=-1
        Select facing
            Case "left"
                x1=x-w1
                y1=y-Rnd(h1/2)
            Case "right"
                x1=x+1
                y1=y-Rnd(h1/2)
            Case "up"
                x1=x-Rnd(w1/2)
                y1=y-h1
            Case "down"
                x1=x-Rnd(w1/2)
                y1=y+1
        End Select
        If x1<>-1
            If spaceisempty(x1,y1,w1,h1) = True Then
                For Local y2=0 Until h1
                For Local x2=0 Until w1
                    map[x2+x1][y2+y1] = isfloor
                    If y2 = 0 Or x2 = 0 Or y2 = h1-1 Or x2 = w1-1 Then map[x2+x1][y2+y1] = 1  ' wall
                Next
                Next
                
            ' shift map
                Select facing
                    Case "left"        
                        For Local y2=0 Until h1
                        For Local x2=w1 Until 0 Step -1
                            If map[x2+x1][y2+y1] <> isdoor
                                map[x2+x1][y2+y1] = map[x2+x1-1][y2+y1]
                            End If                            
                        Next
                        Next
                        For Local y2=0 Until h1
                            map[x1][y2+y1] = isnothing
                        Next
                    Case "right"        
                        For Local y2=0 Until h1
                        For Local x2=0 Until w1
                            If map[x2+x1-1][y2+y1] <> isdoor
                                map[x2+x1-1][y2+y1] = map[x2+x1][y2+y1]
                            End If
                        Next
                        Next
                        For Local y2=0 Until h1
                            map[x1+w1-1][y2+y1] = isnothing
                        Next
                    Case "up"        
                        For Local y2=h1 Until 0 Step -1
                        For Local x2=0 Until w1
                            If map[x2+x1][y2+y1] <> isdoor
                                map[x2+x1][y2+y1] = map[x2+x1][y2+y1-1]
                            End If
                        Next
                        Next
                        For Local x2=0 Until w1
                            map[x1+x2][y1] = isnothing
                        Next
                    Case "down"        
                        For Local y2=0 Until h1
                        For Local x2=0 Until w1
                            If map[x2+x1][y2+y1-1] <> isdoor
                                map[x2+x1][y2+y1-1] = map[x2+x1][y2+y1]
                            End If
                        Next
                        Next
                        For Local x2=0 Until w1
                            map[x1+x2][y1+h1-1] = isnothing
                        Next
                End Select            
                Return True                
            End If            
        End If
        cnt+=1
    Wend
    Return False
End Function

Function spaceisempty:Bool(x:Int,y:Int,w:Int,h:Int)
    For Local y1=0 Until h
    For Local x1=0 Until w
        If map[x1+x][y1+y] <> isnothing Then Return False
    Next
    Next
    Return True
End Function

Function makedoor(side:String,x:Int,y:Int,w:Int,h:Int)
    Local x1:Int
    Local y1:Int
    Select side
        Case "left"
            x1=x
            y1=y+Rnd(h-6)+3    
        Case "right"
            x1=x+w-1
            y1=y+Rnd(h-6)+3        
        Case "up"
            x1=x+Rnd(w-6)+3
            y1=y
        Case "down"
            x1=x+Rnd(w-6)+3
            y1=y+h-1
    End Select
    map[x1][y1] = isdoor
End Function

Function makeroom(x:Int,y:Int,w:Int,h:Int)
    For Local y1=0 Until h
    For Local x1=0 Until w
        map[x1+x][y1+y] = 2  ' floor
        If y1 = 0 Or x1 = 0 Or y1 = h-1 Or x1 = w-1 Then map[x1+x][y1+y] = 1  ' wall
    Next
    Next
End Function

Function drawmap:Bool()
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth
        Select map[x][y]
            Case isnothing ; 
            Case iswall ; SetColor 150,150,150 ' wall
            Case isfloor ; SetColor 50,50,50 ' floor
            Case isdoor ; SetColor 200,200,0 ' door
        End Select
        If map[x][y]<>isnothing Then DrawRect x*tilewidth,y*tileheight,tilewidth,tileheight
    Next
    Next
End Function

Function Main()
    New MyGame()
End Function
