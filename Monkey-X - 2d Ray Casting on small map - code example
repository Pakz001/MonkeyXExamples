Import mojo

Global mapwidth:Int=10
Global mapheight:Int=10
Global tilewidth:Int=640/mapwidth
Global tileheight:Int=480/mapheight

Global map:Int[][] = [        [1,1,1,1,1,1,1,1,1,1],
                            [1,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,0,0,1],
                            [1,0,0,0,0,0,1,1,1,1],
                            [1,0,0,1,0,0,0,0,0,1],
                            [1,0,0,1,0,0,0,0,0,1],
                            [1,1,1,1,0,0,0,0,0,1],
                            [1,0,0,0,0,0,0,1,0,1],
                            [1,0,0,0,0,0,0,1,0,1],
                            [1,1,1,1,1,1,1,1,1,1] ]

Global hlmap:Int[mapwidth][]

Class players
    Field x:Float,y:Float
    Field angle:Int=100
    Method New(x:Float,y:Float)
        Self.x = x
        Self.y = y
    End Method
    Method update()
        angle-=1
        If KeyDown(KEY_LEFT) Then angle+=3
        If KeyDown(KEY_RIGHT) Then angle-=3
        If angle<-180 Then angle = 180
        If angle>180 Then angle = -180
        
        'clear the higlight map
        For Local y=0 Until mapheight
        For Local x=0 Until mapwidth
            hlmap[x][y] = 0
        Next
        Next
        'get the angle minus 45 degrees
        Local a=angle-45
        Local cnt:Int=0
        ' keep inside angle ragne
        If a<0 Then a=a-360
        
        'loop 90 degrees
        For Local i=0 Until 90
            Local aa=a+i
            If aa>360 Then aa=aa+360
            ' ray cast 320 pixels distance
            For Local d=0 Until 320 Step 8
                Local x1:Float=((x+tilewidth/2)+(Sin(aa)*d))
                Local y1:Float=((y+tileheight/2)+(Cos(aa)*d))
                x1/=tilewidth
                y1/=tileheight
                ' if inside map
                If x1>-1 And y1>-1 And x1<mapwidth And y1<mapheight
                    ' if wall then exit
                    If map[y1][x1] = 1 Then 
                        hlmap[x1][y1] = 1
                        Exit
                    End If
                    ' set ground 
                    hlmap[x1][y1] = 2
                End If
            Next
            cnt+=1
        Next
    End Method
    Method draw()
        SetColor 0,0,255
        DrawOval x,y,tilewidth,tileheight
        Local x1:Int=x+tilewidth/2
        Local y1:Int=y+tileheight/2
        DrawLine x1,y1,x1+(Sin(angle)*tilewidth),y1+(Cos(angle)*tileheight)
    End Method
End Class

Global p:List<players> = New List<players>

Class MyGame Extends App

    Method OnCreate()
        SetUpdateRate(60)
        For Local i = 0 Until mapwidth
            hlmap[i] = New Int[mapheight]
        Next
        p.AddLast(New players(5*tilewidth,5*tileheight))
    End Method
    Method OnUpdate()   
        For Local i:=Eachin p
            i.update
        Next     
    End Method
    Method OnRender()
        Cls 0,0,0 
        SetColor 255,255,255
        drawmap
        For Local i:=Eachin p
            i.draw
        Next
        SetColor 255,255,255
        DrawText "Ray Casting example.",0,0
    End Method
End Class

Function drawmap:Void()
    SetColor 200,200,200
    For Local y=0 Until mapheight
    For Local x=0 Until mapwidth
        If map[y][x] = 1
            SetColor 200,200,200
            DrawRect x*tilewidth,y*tileheight,tilewidth,tileheight
        End If
        ' draw the highlight map (1 =wall 2 = floor
        If hlmap[x][y] = 1
            SetColor 255,255,255
            DrawRect x*tilewidth,y*tileheight,tilewidth,tileheight        
        End If
        If hlmap[x][y] = 2
            SetColor 55,55,55
            DrawRect x*tilewidth,y*tileheight,tilewidth,tileheight        
        End If

    Next
    Next
End Function

Function Main()
    New MyGame()
End Function
